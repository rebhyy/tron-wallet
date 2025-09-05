import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:on_chain_wallet/app/core.dart';
import 'package:on_chain_wallet/crypto/keys/access/crypto_keys/crypto_keys.dart';
import 'package:on_chain_wallet/crypto/requets/argruments/argruments.dart';
import 'package:on_chain_wallet/crypto/requets/messages/core/message.dart';

final class WalletRequestRemoveKey
    extends WalletRequest<EncryptedMasterKey, MessageArgsOneBytes> {
  final String keyId;
  const WalletRequestRemoveKey._(this.keyId);

  factory WalletRequestRemoveKey(String keyId) {
    return WalletRequestRemoveKey._(keyId);
  }
  factory WalletRequestRemoveKey.deserialize(
      {List<int>? bytes, CborObject? object, String? hex}) {
    final CborListValue values = CborSerializable.cborTagValue(
        cborBytes: bytes,
        object: object,
        hex: hex,
        tags: WalletRequestMethod.removeWalletKeys.tag);
    return WalletRequestRemoveKey(values.elementAs(0));
  }

  @override
  CborTagValue toCbor() {
    return CborTagValue(CborSerializable.fromDynamic([keyId]), method.tag);
  }

  @override
  WalletRequestMethod get method => WalletRequestMethod.removeWalletKeys;

  @override
  Future<MessageArgsOneBytes> getResult(WalletInMemory wallet) async {
    return MessageArgsOneBytes(
        keyOne: (await result(wallet)).toCbor().encode());
  }

  @override
  Future<EncryptedMasterKey> parsResult(MessageArgsOneBytes result) async {
    return EncryptedMasterKey.deserialize(bytes: result.keyOne);
  }

  @override
  Future<EncryptedMasterKey> result(WalletInMemory wallet) async {
    final newWallet = wallet.masterKey.removeKey(keyId);
    return newWallet.encrypt(wallet);
  }
}
