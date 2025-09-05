import 'package:bitcoin_base/bitcoin_base.dart';
import 'package:on_chain_wallet/app/core.dart';
import 'package:on_chain_wallet/crypto/types/networks.dart';
import 'package:on_chain_wallet/wallet/api/client/core/client.dart';
import 'package:on_chain_wallet/wallet/api/client/networks/bitcoin/types/types.dart';
import 'package:on_chain_wallet/wallet/api/provider/networks/bitcoin/bitcoin.dart';
import 'package:on_chain_wallet/wallet/chain/account.dart';
import 'package:on_chain_wallet/wallet/models/network/core/network/network.dart';
import 'package:on_chain_wallet/wallet/models/token/network/token.dart';
import 'package:on_chain_wallet/wallet/models/transaction/core/transaction.dart';
import 'package:on_chain_wallet/wallet/models/transaction/networks/bitcoin.dart';
import 'package:on_chain_swap/on_chain_swap.dart';

abstract class BitcoinClient<T extends IBitcoinAddress> extends NetworkClient<
    BitcoinWalletTransaction,
    BaseBitcoinAPIProvider,
    BaseNetworkToken,
    BitcoinBaseAddress> with HttpImpl implements BaseSwapBitcoinClient {
  @override
  abstract final WalletBitcoinNetwork network;

  Future<BigInt> getAccountBalance(BitcoinBaseAddress address);
  Future<List<UtxoWithAddress>> readUtxos(UtxoAddressDetails address,
      [bool includeTokens = false]);
  @override
  Future<String> sendTransaction(String digest);
  Future<BitcoinFeeRate?> getFeeRate();
  @override
  Future<WalletTransactionStatus> transactionStatus({required String txId});
  @override
  Future<String> genesisHash();
  Future<BtcTransaction> getTx(String txId);
  BitcoinClient clone();
  Future<ElectrumVerbosTxResponse?> getTransactionData(String txId);

  @override
  Future<List<PsbtUtxo>> getAccountsUtxos(
      List<BitcoinSpenderAddress> addresses) async {
    final utxos = await _getAccountsUtxo(addresses);
    return utxos.where((e) {
      final height = e.utxo.blockHeight;
      return height != null && height > 0;
    }).toList();
  }

  Future<List<PsbtUtxo>> _getAccountsUtxo(
      List<BitcoinSpenderAddress> addresses) async {
    final accountsUtxos = await Future.wait(addresses.map((e) async {
      return await readUtxos(
          UtxoAddressDetails.watchOnly(e.address.baseAddress));
    }));
    final accountsPsbtUtxos =
        await Future.wait(List.generate(accountsUtxos.length, (i) async {
      final request = addresses[i];
      final accountUtxos = accountsUtxos[i];
      final psbtUtxos = await Future.wait(
          accountUtxos.map((e) => getTx(e.utxo.txHash)).toList());
      return List.generate(
        accountUtxos.length,
        (index) {
          return PsbtUtxo(
              utxo: accountUtxos[index].utxo,
              p2shRedeemScript: request.p2shreedemScript,
              p2wshWitnessScript: request.witnessScript,
              tx: psbtUtxos[index],
              scriptPubKey: request.address.baseAddress.toScriptPubKey(),
              xOnlyOrInternalPubKey: request.taprootInternal);
        },
      );
    }));
    return accountsPsbtUtxos.expand((e) => e).toList();
  }

  @override
  Future<bool> onInit() async {
    final genesisHash = await this.genesisHash();
    return genesisHash == network.genesisBlock;
  }

  @override
  Future<SwapBitcoinAccountAssetBalance> getAccountsAssetBalance(
      BitcoinSwapAsset asset, BitcoinBaseAddress account) async {
    return SwapBitcoinAccountAssetBalance(
        address: account, balance: await getBalance(account), asset: asset);
  }

  Future<List<BitcoinBlockTransactionInfo>> getTrasactionsBlockInfo(
      List<String> txIds) async {
    txIds = txIds.toSet().toList();
    List<BitcoinBlockTransactionInfo> transactions = [];
    await Future.wait(txIds.map((e) async {
      final result = await getTransactionData(e);
      if (result == null) return;
      final confirmed = (result.confirmations ?? 0) > 0;
      assert(!confirmed || result.blocktime != null);
      if (confirmed && result.blocktime == null) return;
      transactions.add(BitcoinBlockTransactionInfo(
          confirmed: confirmed,
          blockTime: confirmed
              ? DateTimeUtils.detectEpochUnit(result.blocktime!)
              : null,
          txId: e));
    }));
    return transactions;
  }

  @override
  NetworkType get networkType => network.type;

  @override
  Future<bool> initSwapClient() async {
    final init = await this.init();
    if (!init) {
      throw ApiProviderExceptionConst.initializeClientFailed;
    }
    return true;
  }
}
