import 'dart:async';
import 'package:on_chain/aptos/aptos.dart';
import 'package:on_chain_wallet/future/future.dart';
import 'package:on_chain_wallet/crypto/worker.dart';
import 'package:on_chain_wallet/wallet/wallet.dart';

mixin AptosTransactionSignerController {
  WalletProvider get walletProvider;
  WalletAptosNetwork get network;

  Future<List<AptosAnySignature>> signTransactionInternal(
      {required AptosRawTransaction rawTransaction,
      required IAptosAddress address,
      AptosAddress? feePayerAddress,
      List<AptosAddress>? secondarySignerAddresses,
      bool fakeSignature = false}) async {
    if (fakeSignature) {
      return [];
    }
    final signingDigest = rawTransaction.signingSerialize(
        feePayerAddress: feePayerAddress,
        secondarySignerAddresses: secondarySignerAddresses);
    final signedTr = await walletProvider.wallet.signTransaction(
        request: WalletSigningRequest(
      network: network,
      addresses: [address],
      sign: (generateSignature) async {
        if (address.multiSigAccount) {
          List<AptosAnySignature> anySignatures = [];
          final multisigAddress =
              address.cast<IAptosMultiSigAddress>().multiSignatureAddress;
          for (int i = 0; i < multisigAddress.requiredSignature; i++) {
            final publicKey = multisigAddress.publicKeys[i];
            final Bip32AddressIndex signer = publicKey.keyIndex;
            final signRequest =
                GlobalSignRequest.aptos(digest: signingDigest, index: signer);
            final signature = await generateSignature(signRequest);
            anySignatures.add(AptosUtils.generateSignature(
                signature.signature, publicKey.keyScheme.curve));
          }
          return anySignatures;
        }
        final Bip32AddressIndex signer = address.keyIndex.cast();
        final signRequest =
            GlobalSignRequest.aptos(digest: signingDigest, index: signer);
        final signature = await generateSignature(signRequest);
        return [
          AptosUtils.generateSignature(
              signature.signature, address.keyScheme.curve)
        ];
      },
    ));
    return signedTr.result;
  }
}
