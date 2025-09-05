import 'package:flutter/material.dart';
import 'package:on_chain_wallet/crypto/utils/ripple/ripple.dart';
import 'package:on_chain_wallet/future/state_managment/state_managment.dart';
import 'package:on_chain_wallet/future/wallet/controller/controller.dart';
import 'package:on_chain_wallet/future/wallet/network/ripple/transaction/controllers/controller.dart';
import 'package:on_chain_wallet/future/wallet/network/ripple/transaction/widgets/escrow/create.dart';
import 'package:on_chain_wallet/future/wallet/transaction/fields/fields.dart';
import 'package:on_chain_wallet/future/wallet/transaction/core/controller.dart';
import 'package:on_chain_wallet/wallet/wallet.dart';
import 'package:xrpl_dart/xrpl_dart.dart';

class RippleTransactionEscrowCreateOperation
    extends RippleTransactionStateController<EscrowCreate> {
  RippleTransactionEscrowCreateOperation._(
      {required super.walletProvider,
      required super.account,
      required super.address});
  factory RippleTransactionEscrowCreateOperation(
      {required WalletProvider walletProvider,
      required XRPChain account,
      required IXRPAddress address}) {
    return RippleTransactionEscrowCreateOperation._(
        walletProvider: walletProvider, account: account, address: address);
  }

  late final LiveFormField<IntegerBalance, IntegerBalance> amount =
      LiveFormField(
    title: "amount".tr,
    subtitle: "ripple_escrow_create_amount".tr,
    optional: false,
    value: IntegerBalance.zero(network.token),
    onValidateError: (field, value) {
      if (value.largerThanZero) return null;
      return "field_is_required".tr.replaceOne(field.title.tr);
    },
  );
  final LiveFormField<ReceiptAddress<XRPAddress>?, ReceiptAddress<XRPAddress>>
      destination = LiveFormField(
    title: "destination".tr,
    subtitle: "ripple_escrow_create_destionation".tr,
    optional: false,
    value: null,
  );
  final LiveFormField<DateTime?, DateTime> cancelAfter = LiveFormField(
    title: "CancelAfter",
    subtitle: "ripple_escrow_create_cancel_after".tr,
    optional: true,
    value: null,
  );
  final LiveFormField<DateTime?, DateTime> finishAfter = LiveFormField(
    title: "FinishAfter",
    subtitle: "ripple_escrow_create_finish_after".tr,
    optional: true,
    value: null,
  );
  final LiveFormField<String?, String> condition = LiveFormField(
    title: "condition".tr,
    subtitle: "ripple_escrow_create_condition".tr,
    optional: true,
    value: null,
  );

  BigInt getMaxInput() {
    final total = address.address.currencyBalance - txFee.fee.fee.balance;
    if (total.isNegative) return BigInt.zero;
    return total;
  }

  void onUpdateAmount(BigInt? amount) {
    if (amount == null) return;
    this.amount.value.updateBalance(amount);
    this.amount.notify();
    onStateUpdated();
    estimateFee();
  }

  void onUpdateDestination(ReceiptAddress<XRPAddress>? address) {
    if (address == null) return;
    destination.setValue(address);
    onStateUpdated();
    estimateFee();
  }

  void onUpdateFinishAfter(DateTime? finishAfter) {
    this.finishAfter.setValue(finishAfter);
    onStateUpdated();
    estimateFee();
  }

  void onUpdateCancelAfter(DateTime? cancelAfter) {
    this.cancelAfter.setValue(cancelAfter);
    onStateUpdated();
    estimateFee();
  }

  void onUpdateCondition(String? condition) {
    this.condition.setValue(condition);
    onStateUpdated();
    estimateFee();
  }

  @override
  EscrowCreate buildTransactionInternal() {
    return EscrowCreate(
        amount: XRPAmount(amount.value.balance),
        destination: destination.value!.networkAddress.toAddress(),
        cancelAfterTime: cancelAfter.value,
        finishAfterTime: finishAfter.value,
        condition: condition.value,
        destinationTag: destination.value!.networkAddress.tag,
        account: address.networkAddress.toAddress(),
        sourceTag: address.networkAddress.tag,
        memos: RippleUtils.toXrplMemos(memos),
        fee: txFee.fee.fee.balance);
  }

  @override
  TransactionStateController cloneController(IXRPAddress address) {
    return RippleTransactionEscrowCreateOperation(
        walletProvider: walletProvider, account: account, address: address);
  }

  @override
  Widget widgetBuilder(BuildContext context) {
    return RippleTransactionEscrowCreateWidget(form: this);
  }

  @override
  SubmittableTransactionType get transactionType =>
      SubmittableTransactionType.escrowCreate;
  @override
  List<LiveFormField<Object?, Object>> get fields =>
      [amount, destination, cancelAfter, condition, finishAfter];
}
