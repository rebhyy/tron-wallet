import 'package:on_chain_wallet/app/core.dart';
import 'package:on_chain_wallet/future/state_managment/state_managment.dart';
import 'package:on_chain_wallet/future/wallet/network/cardano/transaction/types/types.dart';
import 'package:on_chain_wallet/future/wallet/transaction/fields/fields.dart';
import 'package:on_chain_wallet/wallet/models/chain/chain/chain.dart';

import 'provider.dart';

mixin ADATransactionUtxosController
    on BaseADATransactionController, ADATransactionApiController {
  late final StreamValue<List<ADAAccountFetchedUtxos>> accountUtxos =
      StreamValue(account.addresses
          .where((e) => !e.isRewardAddress)
          .map((e) => ADAAccountFetchedUtxos(address: e))
          .toList());
  void onSelectedUtxosChanged(List<CardanoAccountUtxo> utxos);
  bool get hasUtxos => totalUtxos.value.largerThanZero;
  bool _allSelected = false;
  bool get allUtxosSelected => _allSelected;

  late final LiveFormField<IntegerBalance, IntegerBalance> totalUtxos =
      LiveFormField(
          title: "spendable_amount".tr,
          value: IntegerBalance.zero(account.network.token),
          optional: false);

  Future<void> getAccountsUtxos(
      {List<ADAAccountFetchedUtxos>? accountUtxos}) async {
    accountUtxos ??= this.accountUtxos.value;
    await Future.wait(accountUtxos.map((e) {
      return e.lock.synchronized(() async {
        try {
          if (e.isSuccess) return;
          e.setPending();
          final utxos = await getAccountUtxos(account, e.address);
          e.setUtxo(utxos);
        } catch (err) {
          e.setError();
        }
      });
    }));
    this.accountUtxos.value.removeWhere((e) => e.isSuccess && e.utxos!.isEmpty);
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

  void onUpdateUtxo(ADAAccountFetchedUtxos address, CardanoAccountUtxo utxo) {
    address.addUtxo(utxo);
    totalUtxos.value.updateBalance();
    _updateAmount();
  }

  void onToggleAddressUtxos(ADAAccountFetchedUtxos address) {
    address.toggleAll();
    totalUtxos.value.updateBalance();
    _updateAmount();
  }

  void onToggleAllUtxos() {
    for (final i in accountUtxos.value) {
      i.selectAll(select: !_allSelected);
      totalUtxos.value.updateBalance();
    }
    _updateAmount();
    _updateTotoalSelectedUtxos();
  }

  @override
  void dispose() {
    super.dispose();
    for (final i in accountUtxos.value) {
      i.dispose();
    }
    accountUtxos.dispose();
    accountUtxos.value = [];
    totalUtxos.dispose();
  }
}
