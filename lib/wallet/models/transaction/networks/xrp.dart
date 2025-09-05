import 'package:blockchain_utils/cbor/cbor.dart';
import 'package:on_chain_wallet/app/core.dart';
import 'package:on_chain_wallet/crypto/types/networks.dart';
import 'package:on_chain_wallet/wallet/models/network/core/network/network.dart';
import 'package:on_chain_wallet/wallet/models/transaction/core/transaction.dart';
import 'package:xrpl_dart/xrpl_dart.dart';

class XRPWalletTransaction extends ChainTransaction {
  XRPWalletTransaction(
      {required super.txId,
      DateTime? time,
      super.outputs = const [],
      super.web3Client,
      super.totalOutput,
      required WalletXRPNetwork network,
      super.type = WalletTransactionType.send,
      super.status = WalletTransactionStatus.pending,
      List<XRPWalletTransactionOperationInput> super.inputs = const []})
      : super(time: time ?? DateTime.now());

  factory XRPWalletTransaction.deserialize(WalletXRPNetwork network,
      {List<int>? bytes, String? cborHex, CborObject? object}) {
    final CborListValue values = CborSerializable.cborTagValue(
        cborBytes: bytes,
        hex: cborHex,
        object: object,
        tags: NetworkType.xrpl.tag);
    return XRPWalletTransaction(
        txId: values.valueAs(0),
        time: values.valueAs(1),
        network: network,
        totalOutput: values.elemetMybeAs<WalletTransactionAmount, CborTagValue>(
            2, (e) => WalletTransactionAmount.deserialize(network, object: e)),
        outputs: values
            .elementAsListOf<CborTagValue>(3)
            .map((e) =>
                XRPWalletTransactionOutput.deserialize(network, object: e))
            .toList(),
        web3Client:
            values.elemetMybeAs<WalletWeb3ClientTransaction, CborTagValue>(
                4, (e) => WalletWeb3ClientTransaction.deserialize(object: e)),
        type: WalletTransactionType.fromValue(values.valueAs(5)),
        status: WalletTransactionStatus.fromValue(values.valueAs(6)),
        inputs: values
            .elementAsListOf<CborTagValue>(7, emyptyOnNull: true)
            .map((e) => XRPWalletTransactionOperationInput.deserialize(obj: e))
            .toList());
  }

  @override
  NetworkType get network => NetworkType.xrpl;
}

abstract class XRPWalletTransactionOutput extends WalletTransactionOutput {
  const XRPWalletTransactionOutput({required super.type});
  factory XRPWalletTransactionOutput.deserialize(WalletXRPNetwork network,
      {List<int>? bytes, String? cborHex, CborObject? object}) {
    final CborTagValue tag =
        CborSerializable.decode(cborBytes: bytes, hex: cborHex, object: object);
    final type = WalletTransactionOutputType.fromTag(tag.tags);
    return switch (type) {
      WalletTransactionOutputType.transfer =>
        XRPWalletTransactionTransferOutput.deserialize(network,
            bytes: bytes, cborHex: cborHex, object: object),
      WalletTransactionOutputType.operation =>
        XRPWalletTransactionOperationOutput.deserialize(network,
            bytes: bytes, cborHex: cborHex, object: object),
      _ => throw WalletExceptionConst.invalidWalletTransactionData
    };
  }
}

class XRPWalletTransactionTransferOutput
    extends WalletTransactionTransferOutput<XRPAddress>
    implements XRPWalletTransactionOutput {
  const XRPWalletTransactionTransferOutput(
      {required super.to, required super.amount});

  factory XRPWalletTransactionTransferOutput.deserialize(
      WalletXRPNetwork network,
      {List<int>? bytes,
      String? cborHex,
      CborObject? object}) {
    final CborListValue values = CborSerializable.cborTagValue(
        cborBytes: bytes,
        hex: cborHex,
        object: object,
        tags: WalletTransactionOutputType.transfer.tag);
    return XRPWalletTransactionTransferOutput(
        amount: WalletTransactionAmount.deserialize(network,
            object: values.elementAs<CborTagValue>(0)),
        to: XRPAddress(values.elementAs(1)));
  }

  @override
  CborTagValue toCbor() {
    return CborTagValue(
        CborSerializable.fromDynamic([amount.toCbor(), to.address]), type.tag);
  }

  @override
  String get address => to.address;
}

class XRPWalletTransactionOperationInput
    extends WalletTransactionOperationInput<XRPAddress> {
  @override
  final XRPAddress address;

  const XRPWalletTransactionOperationInput(
      {required this.address, required super.operation});
  factory XRPWalletTransactionOperationInput.deserialize(
      {List<int>? bytes, CborObject? obj, String? hex}) {
    final CborListValue values = CborSerializable.cborTagValue(
        cborBytes: bytes,
        hex: hex,
        object: obj,
        tags: WalletTransactionInputType.operation.tag);
    return XRPWalletTransactionOperationInput(
        address: XRPAddress(values.elementAs(0)),
        operation: values.elementAs<String?>(1) ?? "Payment");
  }
  @override
  CborTagValue<CborObject> toCbor() {
    return CborTagValue(
        CborListValue.definite([
          CborStringValue(addressStr),
          CborStringValue(operation),
        ]),
        type.tag);
  }

  @override
  String get addressStr => address.toAddress();
}

class XRPWalletTransactionOperationOutput
    extends WalletTransactionOperationOutput
    implements XRPWalletTransactionOutput {
  const XRPWalletTransactionOperationOutput(
      {required super.name, super.amount, super.content});

  factory XRPWalletTransactionOperationOutput.deserialize(
      WalletXRPNetwork network,
      {List<int>? bytes,
      String? cborHex,
      CborObject? object}) {
    final CborListValue values = CborSerializable.cborTagValue(
        cborBytes: bytes,
        hex: cborHex,
        object: object,
        tags: WalletTransactionOutputType.operation.tag);
    return XRPWalletTransactionOperationOutput(
        name: values.elementAs(0),
        amount: values.elemetMybeAs<WalletTransactionAmount, CborTagValue>(
            1, (e) => WalletTransactionAmount.deserialize(network, object: e)),
        content: values.elementAs(2));
  }

  @override
  CborTagValue toCbor() {
    return CborTagValue(
        CborSerializable.fromDynamic([name, amount?.toCbor(), content]),
        type.tag);
  }
}
