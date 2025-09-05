import 'package:on_chain_wallet/future/wallet/network/bitcoin/web3/types/types.dart';
import 'package:on_chain_wallet/wallet/chain/account.dart';
import 'package:on_chain_wallet/wallet/web3/networks/bitcoin/params/core/request.dart';
import 'package:on_chain_wallet/wallet/web3/networks/bitcoin/permission/models/account.dart';

abstract class Web3BitcoinTransactionStateController<
        RESPONSE,
        T extends BaseWeb3BitcoinRequestParam<RESPONSE, IBitcoinAddress,
            Web3BitcoinChainAccount>,
        E extends IWeb3BitcoinTransactionData,
        TRANSACTION extends IWeb3BitcoinTransaction<E>,
        SIGNEDTX extends IWeb3BitcoinSignedTransaction<TRANSACTION, Object>>
    extends BaseWeb3BitcoinTransactionStateController<RESPONSE, T, E,
        TRANSACTION, SIGNEDTX> {
  Web3BitcoinTransactionStateController(
      {required super.walletProvider, required super.request});
}
