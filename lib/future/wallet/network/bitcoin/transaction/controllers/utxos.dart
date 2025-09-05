import 'package:bitcoin_base/bitcoin_base.dart';
import 'package:on_chain_wallet/app/core.dart';
import 'package:on_chain_wallet/future/state_managment/state_managment.dart';
import 'package:on_chain_wallet/future/wallet/network/bitcoin/transaction/types/types.dart';
import 'package:on_chain_wallet/future/wallet/transaction/fields/fields.dart';
import 'package:on_chain_wallet/wallet/chain/account.dart';
import 'package:on_chain_wallet/wallet/models/network/core/network/network.dart';

mixin BitcoinTransactionUtxosController on DisposableMixin {
  WalletBitcoinNetwork get network;
  final Cancelable _cancelable = Cancelable();
  BitcoinChain get account;
  bool get includeTokens => true;
  late final StreamValue<List<BitcoinAccountFetchedUtxos>> accountUtxos =
      StreamValue(account.addresses
          .map((e) => BitcoinAccountFetchedUtxos(address: e))
          .toList());
  void onSelectedUtxosChanged(List<BitcoinUtxoInfo> utxos);
  bool get hasUtxos => totalUtxos.value.largerThanZero;
  bool _allSelected = false;
  bool get allUtxosSelected => _allSelected;

  late final LiveFormField<IntegerBalance, IntegerBalance> totalUtxos =
      LiveFormField(
          title: "spendable_amount".tr,
          subtitle: "total_selected_amount".tr,
          value: IntegerBalance.zero(network.token),
          optional: false);

  Future<void> initAccountUtxos(
      {required List<IBitcoinAddress> addresses}) async {
    accountUtxos.value =
        addresses.map((e) => BitcoinAccountFetchedUtxos(address: e)).toList();
    getAccountsUtxos();
  }

  Future<void> getAccountsUtxos(
      {List<BitcoinAccountFetchedUtxos>? accountUtxos}) async {
    _cancelable.cancel();
    accountUtxos ??= this.accountUtxos.value;
    final result = await MethodUtils.call(() async {
      await Future.wait(accountUtxos!.map((e) {
        return e.lock.synchronized(() async {
          try {
            if (e.isSuccess) return;
            e.setPending();
            List<UtxoWithAddress> utxos =
                await account.getAccountUtxos(e.address);
            if (!includeTokens) {
              utxos = utxos.where((e) => e.utxo.token == null).toList();
            }
            e.setUtxo(BitcoinAccountWithUtxos(
                address: e.address,
                addressDetails: e.address.toUtxoRequest,
                utxos: utxos,
                network: account.network));
          } catch (err) {
            e.setError();
          }
        });
      }));
    }, cancelable: _cancelable);
    if (result.isCancel) return;
    this
        .accountUtxos
        .value
        .removeWhere((e) => e.isSuccess && e.utxos!.utxosWithBalance.isEmpty);
    this.accountUtxos.notify();
    _updateTotoalSelectedUtxos();
  }

  void _onSelectedUtxosChanged() {
    final utxos = accountUtxos.value.expand((e) => e.selectedUtxos).toList();
    onSelectedUtxosChanged(utxos);
  }

  void _updateTotoalSelectedUtxos() {
    final allSelected = accountUtxos.value.every((e) => e.allSelected);
    if (allSelected != _allSelected) {
      _allSelected = accountUtxos.value.every((e) => e.allSelected);
      accountUtxos.notify();
    }
  }

  void _updateAmount() {
    final total =
        accountUtxos.value.fold(BigInt.zero, (p, c) => p + c.totalUtxo);
    totalUtxos.value.updateBalance(total);
    totalUtxos.notify();

    _onSelectedUtxosChanged();
    _updateTotoalSelectedUtxos();
  }

  void addUtxo(BitcoinAccountFetchedUtxos address, BitcoinUtxoInfo utxo) {
    address.addUtxo(utxo);
    totalUtxos.value.updateBalance();
    _updateAmount();
  }

  void toggleAllAddressUtxos(BitcoinAccountFetchedUtxos address) {
    address.toggleAll();
    totalUtxos.value.updateBalance();
    _updateAmount();
  }

  void toggleAllUtxos() {
    for (final i in accountUtxos.value) {
      if (!i.isSuccess) continue;
      i.selectAll(select: !_allSelected);
      totalUtxos.value.updateBalance();
    }
    _updateAmount();
    _updateTotoalSelectedUtxos();
  }

  @override
  void dispose() {
    _cancelable.cancel();
    totalUtxos.dispose();
    for (final i in accountUtxos.value) {
      i.dispose();
    }
    accountUtxos.value = [];
    accountUtxos.dispose();

    appLogger.debug(
        functionName: "dispose", runtime: runtimeType, msg: "Utxos");
    super.dispose();
  }
}
