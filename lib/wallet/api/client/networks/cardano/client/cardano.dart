import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:blockchain_utils/cbor/extention/extenton.dart';
import 'package:on_chain_wallet/app/core.dart';
import 'package:on_chain_wallet/crypto/types/networks.dart';
import 'package:on_chain_wallet/wallet/api/client/core/client.dart';
import 'package:on_chain_wallet/wallet/api/client/networks/cardano/types/types.dart';
import 'package:on_chain_wallet/wallet/api/provider/networks/cardano.dart';
import 'package:on_chain_wallet/wallet/api/services/service.dart';
import 'package:on_chain_wallet/wallet/models/network/network.dart';
import 'package:on_chain_wallet/wallet/models/token/network/token.dart';
import 'package:on_chain_wallet/wallet/models/transaction/core/transaction.dart';
import 'package:on_chain_wallet/wallet/models/transaction/networks/ada.dart';
import 'package:on_chain/ada/src/provider/exception/blockfrost_api_error.dart';
import 'package:on_chain/on_chain.dart';

class _ADAClientConst {
  static const int blockfrostMaxUtxoResponse = 100;
}

class ADAClient extends NetworkClient<ADAWalletTransaction, CardanoAPIProvider,
    BaseNetworkToken, ADAAddress> {
  ADAClient({required this.provider, required this.network});
  final BlockFrostProvider provider;
  @override
  final WalletCardanoNetwork network;
  @override
  NetworkServiceProtocol<CardanoAPIProvider> get service =>
      provider.rpc as NetworkServiceProtocol<CardanoAPIProvider>;

  Future<List<ADAAccountUTXOResponse>> getAccountUtxos(
      {required ADAAddress address}) async {
    try {
      int page = 1;
      List<ADAAccountUTXOResponse> utxos = [];
      while (true) {
        final result = await provider.request(BlockfrostRequestAddressUTXOs(
            address,
            filter: BlockFrostRequestFilterParams(
                count: _ADAClientConst.blockfrostMaxUtxoResponse, page: page)));
        utxos.addAll(result);
        page++;
        if (result.length < _ADAClientConst.blockfrostMaxUtxoResponse) break;
      }
      return utxos;
    } on RPCError catch (e) {
      if (e.errorCode == BlockfrostStatusCode.resourceDoesNotExist) {
        return [];
      }
      rethrow;
    }
  }

  Future<List<TransactionUnspentOutput>> getUtxosOutputs(
      List<TransactionInput> inputs) async {
    final txIds = inputs.map((e) => e.txIdHex).toSet();
    List<TransactionUnspentOutput> outputs = [];
    await Future.wait(txIds.map((e) async {
      final tx = await tryGetTransaction(e);
      if (tx == null) return null;
      final input = inputs.where((i) => StringUtils.hexEqual(i.txIdHex, e));
      for (final e in input) {
        final rOutput = tx.body.outputs?.outputs.elementAtOrNull(e.index);
        if (rOutput != null) {
          outputs.add(TransactionUnspentOutput(output: rOutput, input: e));
        }
      }
    }));
    return outputs;
  }

  Future<ADATransaction?> tryGetTransaction(String txId) async {
    final tx = await () async {
      try {
        final cbor =
            await provider.request(BlockfrostRequestTransactionCbor(txId));
        return ADATransaction.deserialize(CborObject.fromCborHex(cbor).cast());
      } catch (_) {
        return null;
      }
    }();
    assert(tx != null, "fetch tx id failed $txId");
    return tx;
  }

  Future<List<ADATransactionWithTxId>> getTxesFromInputs(
      List<TransactionInput> inputs) async {
    final txIds = inputs.map((e) => e.txIdHex).toSet();
    List<ADATransactionWithTxId> txes = [];
    await Future.wait(txIds.map((e) async {
      final tx =
          await provider.request(BlockfrostRequestSpecificTransaction(e));
      final cbor = await provider.request(BlockfrostRequestTransactionCbor(e));
      final txInputs = inputs.where((i) => i.txIdHex == e);
      final adaTransaction =
          ADATransaction.deserialize(CborObject.fromCborHex(cbor).cast());
      for (final i in txInputs) {
        final output =
            adaTransaction.body.outputs?.outputs.elementAtOrNull(i.index);
        assert(output != null, "invalid utxo output");
        if (output == null) continue;
        txes.add(ADATransactionWithTxId(
            txInput: i,
            blockTime: DateTimeUtils.fromSecondsSinceEpoch(tx.blockTime),
            output: output));
      }
    }));

    return txes;
  }

  Future<ADAEpochParametersResponse> latestEpochProtocolParameters() async {
    return await provider
        .request(BlockfrostRequestLatestEpochProtocolParameters());
  }

  Future<ADAGenesisParametersResponse> getNetworkGenesisParameters() async {
    return await provider.request(BlockfrostRequestBlockchainGenesis());
  }

  Future<String> broadcastTransaction(List<int> txCborBytes) async {
    return await provider.request(
        BlockfrostRequestSubmitTransaction(transactionCborBytes: txCborBytes));
  }

  @override
  Future<WalletTransactionStatus> transactionStatus(
      {required String txId}) async {
    try {
      await provider.request(BlockfrostRequestSpecificTransaction(txId));

      return WalletTransactionStatus.block;
    } catch (e) {
      return WalletTransactionStatus.unknown;
    }
  }

  @override
  Future<bool> onInit() async {
    final magic = await getNetworkGenesisParameters();
    return magic.networkMagic == network.coinParam.networkType.protocolMagic;
  }

  @override
  NetworkType get networkType => NetworkType.cardano;
}
