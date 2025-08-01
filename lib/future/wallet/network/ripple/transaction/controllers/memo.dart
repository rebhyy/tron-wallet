import 'package:on_chain_wallet/future/state_managment/extension/extension.dart';
import 'package:on_chain_wallet/future/wallet/network/ripple/transaction/types/types.dart';
import 'package:on_chain_wallet/future/wallet/transaction/fields/fields.dart';
import 'package:xrpl_dart/xrpl_dart.dart';

mixin RippleTransactionMemoController<T extends IXRPTransactionData>
    on BaseRippleTransactionController<T> {
  final LiveFormFields<XRPLMemo> memo = LiveFormFields(
      title: "memos".tr, subtitle: "memo_desc".tr, optional: true);
  List<XRPLMemo> get memos => memo.value;

  void onUpdateMemo(XRPLMemo memo) {
    this.memo.addValue(memo);
    onStateUpdated();
    estimateFee();
  }

  void onRemoveMemo(XRPLMemo memo) {
    this.memo.removeValue(memo);
    onStateUpdated();
    estimateFee();
  }

  @override
  void dispose() {
    super.dispose();
    memo.dispose();
  }
}
