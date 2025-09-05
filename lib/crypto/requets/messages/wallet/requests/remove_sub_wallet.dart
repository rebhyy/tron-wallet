import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:on_chain_wallet/app/core.dart';
import 'package:on_chain_wallet/crypto/keys/access/crypto_keys/crypto_keys.dart';
import 'package:on_chain_wallet/crypto/requets/argruments/argruments.dart';
import 'package:on_chain_wallet/crypto/requets/messages/core/message.dart';

final class WalletRequestRemoveSubWallet
    extends WalletRequest<EncryptedMasterKey, MessageArgsOneBytes> {
  final int id;
  const WalletRequestRemoveSubWallet({required this.id});

  factory WalletRequestRemoveSubWallet.deserialize(
      {List<int>? bytes, CborObject? object, String? hex}) {
    final CborListValue values = CborSerializable.cborTagValue(
        cborBytes: bytes,
        object: object,
        hex: hex,
        tags: WalletRequestMethod.removeSubWallet.tag);
    return WalletRequestRemoveSubWallet(id: values.valueAs(0));
  }

  @override
  CborTagValue toCbor() {
    return CborTagValue(
        CborSerializable.fromDynamic([CborIntValue(id)]), method.tag);
  }

  @override
  WalletRequestMethod get method => WalletRequestMethod.removeSubWallet;

  @override
  Future<MessageArgsOneBytes> getResult(WalletInMemory wallet) async {
    final newWallet = wallet.masterKey.removeSubWallet(id);
    final encryptWallet = newWallet.encrypt(wallet);
    return MessageArgsOneBytes(keyOne: encryptWallet.toCbor().encode());
  }

  @override
  Future<EncryptedMasterKey> parsResult(MessageArgsOneBytes result) async {
    return EncryptedMasterKey.deserialize(bytes: result.keyOne);
  }

  @override
  Future<EncryptedMasterKey> result(WalletInMemory wallet) async {
    final newWallet = wallet.masterKey.removeSubWallet(id);
    return newWallet.encrypt(wallet);
  }
}
