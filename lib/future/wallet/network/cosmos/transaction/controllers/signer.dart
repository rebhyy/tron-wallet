import 'package:on_chain_wallet/app/live_listener/live.dart';
import 'package:on_chain_wallet/crypto/constant/const.dart';
import 'package:on_chain_wallet/crypto/requets/messages/models/models/signing.dart';
import 'package:on_chain_wallet/future/wallet/wallet.dart';
import 'package:on_chain_wallet/wallet/chain/account.dart';
import 'package:on_chain_wallet/wallet/models/network/core/network.dart';
import 'package:on_chain_wallet/wallet/models/signing/signing.dart';

mixin CosmosTransactionSignerController on DisposableMixin {
  WalletProvider get walletProvider;
  WalletCosmosNetwork get network;
  Future<CosmosSignedTransaction> signTransactionInternal(
      {required List<int> payload,
      required ICosmosAddress signer,
      bool fakeSignature = false}) async {
    if (fakeSignature) {
      return CosmosSignedTransaction(
          signature: CryptoConst.fakeEd25519Signature, payload: payload);
    }
    final signRequest = WalletSigningRequest(
      addresses: [signer],
      network: network,
      sign: (generateSignature) async {
        final signRequest = CosmosSigningRequest(
            digest: payload,
            index: signer.keyIndex.cast(),
            alg: signer.algorithm);
        final sss = await generateSignature(signRequest);
        return sss.signature;
      },
    );
    final signature =
        await walletProvider.wallet.signTransaction(request: signRequest);
    return CosmosSignedTransaction(
        signature: signature.result, payload: payload);
  }
}
