import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:flutter/material.dart';
import 'package:on_chain_wallet/crypto/keys/access/crypto_keys/crypto_keys.dart';
import 'package:on_chain_wallet/future/wallet/network/cardano/web3/pages/get_account_pub_key.dart';
import 'package:on_chain_wallet/future/wallet/network/cardano/web3/types/types.dart';
import 'package:on_chain_wallet/future/wallet/web3/core/state.dart';
import 'package:on_chain_wallet/wallet/api/api.dart';
import 'package:on_chain_wallet/wallet/chain/account.dart';
import 'package:on_chain_wallet/wallet/web3/networks/cardano/cardano.dart';

class Web3ADAGetAccountPubKeyStateController extends Web3CardanoStateController<
    List<int>, ADAClient?, Web3ADAGetAccountPub> {
  Bip32AddressIndex? _keyIndex;
  @override
  Future<Web3RequestResponseData<List<int>>> getResponse() async {
    final signature =
        await walletProvider.wallet.getKeyDerivationPublicKey(_keyIndex!);
    final key = signature.result;

    return Web3RequestResponseData(
        response: CborBytesValue(key.key.bip32KeyBytes()).encode());
  }

  Web3ADAGetAccountPubKeyStateController(
      {required super.walletProvider, required super.request});

  @override
  Widget widgetBuilder(BuildContext context) {
    return Web3CardanoGetAccoutPubKeyStateView(form: this);
  }

  @override
  Future<void> initForm(ADAClient? client) async {
    await super.initForm(client);
    final web3Account = params.accessAccount;
    Bip32AddressIndex? correctKeyIndex;
    final keyIndex = web3Account.keyIndex;
    if (keyIndex.isMultiSig) {
      final mAccount = defaultAccount as ICardanoMultiSigAddress;
      if (web3Account.isRewardAddress) {
        final isPubKey =
            mAccount.addressInfo.stakeCredential?.type.isPublicKey ?? false;
        if (isPubKey) {
          correctKeyIndex = mAccount.addressInfo.stakeCredential!
              .cast<CardanoMultiSignatureKey>()
              .signer
              .keyIndex;
        }
      } else {
        final isPubKey = mAccount.addressInfo.credential.type.isPublicKey;
        if (isPubKey) {
          correctKeyIndex = mAccount.addressInfo.credential
              .cast<CardanoMultiSignatureKey>()
              .signer
              .keyIndex;
        }
      }
    } else {
      correctKeyIndex = defaultAccount.keyIndex.cast();
    }

    if (correctKeyIndex == null) {
      throw Web3ADAExceptionConstant.unableToAccessBip32PublicKey;
    }
    _keyIndex = correctKeyIndex;
  }
}
