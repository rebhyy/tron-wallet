import 'package:on_chain_wallet/app/live_listener/live.dart';
import 'package:on_chain_wallet/app/models/models/typedef.dart';
import 'package:on_chain_wallet/future/state_managment/state_managment.dart';
import 'package:on_chain_wallet/future/wallet/network/monero/transaction/types/types.dart';
import 'package:on_chain_wallet/future/wallet/transaction/fields/fields.dart';
import 'package:on_chain_wallet/wallet/chain/account.dart';
import 'package:on_chain_wallet/wallet/models/network/core/network/network.dart';
import 'package:on_chain_wallet/wallet/models/networks/monero/models/account_related.dart';

mixin MoneroTransactionUtxosController on DisposableMixin {
  WalletMoneroNetwork get network;
  late final StreamValue<List<MoneroAccountFetchedUtxos>> accountUtxos =
      StreamValue([]);
  void onSelectedUtxosChanged(List<MoneroOutputDetailsWithAddress> utxos);
  bool get hasUtxos => totalUtxos.value.largerThanZero;
  bool _allSelected = false;
  bool get allUtxosSelected => _allSelected;

  late final LiveFormField<IntegerBalance, IntegerBalance> totalUtxos =
      LiveFormField(
          title: "spendable_amount".tr,
          value: IntegerBalance.zero(network.token),
          optional: false);

  Future<void> initAccountUtxos(
      {required MoneroChain account, required IMoneroAddress address}) async {
    final utxos = account
        .relatedTxAccountsUtxos(address.addrDetails.viewKey)
        .where((e) => e.utxos.isNotEmpty)
        .toList();
    accountUtxos.value = utxos
        .map((e) => MoneroAccountFetchedUtxos(
            address: e.address.account as IMoneroAddress, utxos: e))
        .toList();
  }

  void _onSelectedUtxosChanged() {
    final utxos = accountUtxos.value
        .expand((e) => e.selectedUtxos.map((i) =>
            MoneroOutputDetailsWithAddress(
                paymet: i.output, address: e.address)))
        .toList();
    onSelectedUtxosChanged(utxos);
  }

  void _updateTotoalSelectedUtxos() {
    final allSelected = accountUtxos.value.every((e) => e.allSelected);
    if (allSelected != _allSelected) {
      _allSelected = accountUtxos.value.every((e) => e.allSelected);
      accountUtxos.notify();
    }
  }

  int get _totalSelected =>
      accountUtxos.value.fold(0, (p, c) => p + c.selectedUtxos.length);

  void _updateAmount() {
    final total =
        accountUtxos.value.fold(BigInt.zero, (p, c) => p + c.totalUtxo);
    totalUtxos.value.updateBalance(total);
    totalUtxos.notify();
    _onSelectedUtxosChanged();
    _updateTotoalSelectedUtxos();
  }

  void onUpdateUtxo(MoneroAccountFetchedUtxos address,
      MoneroViewOutputDetails utxo, DynamicVoid onMaxInput) {
    address.addUtxo(utxo, _totalSelected, onMaxInput);
    totalUtxos.value.updateBalance();
    _updateAmount();
  }

  void onToggleAddressUtxos(
      MoneroAccountFetchedUtxos address, DynamicVoid onMaxInput) {
    address.toggleAll(_totalSelected, onMaxInput);
    totalUtxos.value.updateBalance();
    _updateAmount();
  }

  void onToggleAllUtxos(DynamicVoid onMaxInput) {
    for (final i in accountUtxos.value) {
      i.selectAll(_totalSelected, onMaxInput, select: !_allSelected);
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
