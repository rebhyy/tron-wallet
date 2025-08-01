import 'package:on_chain_wallet/future/state_managment/state_managment.dart';
import 'package:on_chain_wallet/future/wallet/network/stellar/transaction/types/types.dart';
import 'package:on_chain_wallet/future/wallet/transaction/fields/fields.dart';
import 'package:stellar_dart/stellar_dart.dart';

mixin StellarTransactionMemoontroller on BaseStellarTransactionController {
  final LiveFormField<StellarMemoDetils?, StellarMemoDetils?> memo =
      LiveFormField(title: "setup_memo".tr, value: null, optional: true);

  void onUpdateMemo(StellarMemo? memo) {
    if (memo == null) return;
    this.memo.setValue(StellarMemoDetils(memo));
    onStateUpdated();
  }

  void onRemoveMemo() {
    memo.setValue(null);
    onStateUpdated();
  }

  @override
  void dispose() {
    super.dispose();
    memo.dispose();
  }
}
