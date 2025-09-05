import 'package:blockchain_utils/cbor/cbor.dart';
import 'package:on_chain_wallet/app/core.dart';
import 'package:on_chain_wallet/crypto/types/networks.dart';
import 'package:on_chain_wallet/wallet/models/network/core/network/network.dart';
import 'package:on_chain_wallet/wallet/models/transaction/core/transaction.dart';

class ADAWalletTransaction extends ChainTransaction {
  ADAWalletTransaction(
      {required super.txId,
      DateTime? time,
      super.outputs,
      super.web3Client,
      super.totalOutput,
      required WalletCardanoNetwork network,
      super.type = WalletTransactionType.send,
      super.status = WalletTransactionStatus.pending})
      : super(time: time ?? DateTime.now());

  factory ADAWalletTransaction.deserialize(WalletCardanoNetwork network,
      {List<int>? bytes, String? cborHex, CborObject? object}) {
    final CborListValue values = CborSerializable.cborTagValue(
        cborBytes: bytes,
        hex: cborHex,
        object: object,
        tags: NetworkType.cardano.tag);
    return ADAWalletTransaction(
        txId: values.elementAs(0),
        time: values.elementAs(1),
        network: network,
        totalOutput: values.elemetMybeAs<WalletTransactionAmount, CborTagValue>(
            2, (e) => WalletTransactionAmount.deserialize(network, object: e)),
        outputs: [],
        web3Client:
            values.elemetMybeAs<WalletWeb3ClientTransaction, CborTagValue>(
                4, (e) => WalletWeb3ClientTransaction.deserialize(object: e)),
        type: WalletTransactionType.fromValue(values.elementAs(5)),
        status: WalletTransactionStatus.fromValue(values.elementAs(6)));
  }

  @override
  NetworkType get network => NetworkType.cardano;
}
