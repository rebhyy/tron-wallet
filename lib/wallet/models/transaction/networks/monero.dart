import 'package:blockchain_utils/cbor/cbor.dart';
import 'package:blockchain_utils/helper/helper.dart';
import 'package:monero_dart/monero_dart.dart';
import 'package:on_chain_wallet/app/serialization/serialization.dart';
import 'package:on_chain_wallet/app/utils/list/extension.dart';
import 'package:on_chain_wallet/crypto/types/networks.dart';
import 'package:on_chain_wallet/wallet/constant/constant.dart';
import 'package:on_chain_wallet/wallet/models/network/core/network/network.dart';
import 'package:on_chain_wallet/wallet/models/transaction/core/transaction.dart';

class MoneroWalletTransactionProof {
  final String txId;
  final List<List<int>>? txKeys;
  final MoneroAddress recepient;
  const MoneroWalletTransactionProof(
      {required this.txKeys, required this.recepient, required this.txId});
}

class MoneroWalletTransaction extends ChainTransaction {
  final List<List<int>>? txKeys;
  MoneroWalletTransaction(
      {required super.txId,
      required super.time,
      required super.outputs,
      required WalletMoneroNetwork network,
      required List<List<int>>? txKeys,
      required super.totalOutput,
      super.type = WalletTransactionType.send,
      super.status = WalletTransactionStatus.pending})
      : txKeys = txKeys?.map((e) => e.asImmutableBytes).toImutableList,
        super();

  factory MoneroWalletTransaction.deserialize(WalletMoneroNetwork network,
      {List<int>? bytes, String? cborHex, CborObject? object}) {
    final CborListValue values = CborSerializable.cborTagValue(
        cborBytes: bytes,
        hex: cborHex,
        object: object,
        tags: NetworkType.monero.tag);
    return MoneroWalletTransaction(
      txId: values.elementAs(0),
      time: values.elementAs(1),
      network: network,
      totalOutput: values.elemetMybeAs<WalletTransactionAmount, CborTagValue>(
          2, (e) => WalletTransactionAmount.deserialize(network, object: e)),
      outputs: values
          .elementAsListOf<CborTagValue>(3)
          .map((e) =>
              MoneroWalletTransactionOutput.deserialize(network, object: e))
          .toList(),
      type: WalletTransactionType.fromValue(values.elementAs(5)),
      status: WalletTransactionStatus.fromValue(values.elementAs(6)),
      txKeys: values
          .elementAsListOf<CborBytesValue>(7, emyptyOnNull: true)
          .map((e) => e.value)
          .nullOnEmoty,
    );
  }

  @override
  CborTagValue toCbor() {
    return CborTagValue(
        CborSerializable.fromDynamic([
          txId,
          time,
          totalOutput?.toCbor(),
          CborSerializable.fromDynamic(outputs.map((e) => e.toCbor()).toList()),
          web3Client?.toCbor(),
          type.value,
          status.value,
          CborSerializable.fromDynamic(
              txKeys?.map((e) => CborBytesValue(e)).toList() ?? []),
        ]),
        network.tag);
  }

  @override
  NetworkType get network => NetworkType.monero;

  MoneroWalletTransactionProof generateProofRequest(MoneroAddress recepient) {
    return MoneroWalletTransactionProof(
        txKeys: txKeys, recepient: recepient, txId: txId);
  }
}

class MoneroWalletTransactionOutput
    extends WalletTransactionTransferOutput<MoneroAddress> {
  MoneroWalletTransactionOutput({required super.amount, required super.to});

  @override
  String get address => to.address;

  factory MoneroWalletTransactionOutput.deserialize(WalletMoneroNetwork network,
      {List<int>? bytes, String? cborHex, CborObject? object}) {
    final CborListValue values = CborSerializable.cborTagValue(
        cborBytes: bytes,
        hex: cborHex,
        object: object,
        tags: CborTagsConst.moneroWalletTransactionOutput);
    return MoneroWalletTransactionOutput(
      amount: WalletTransactionIntegerAmount.deserialize(network,
          object: values.elementAsCborTag(0)),
      to: MoneroAddress(values.elementAs(1)),
    );
  }

  @override
  CborTagValue toCbor() {
    return CborTagValue(
        CborSerializable.fromDynamic([amount.toCbor(), to.address]),
        CborTagsConst.moneroWalletTransactionOutput);
  }
}
