import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:on_chain_wallet/app/core.dart';
import 'package:on_chain_wallet/crypto/keys/access/crypto_keys/crypto_keys.dart';
import 'package:on_chain_wallet/crypto/requets/argruments/argruments.dart';
import 'package:on_chain_wallet/crypto/requets/messages/core/message.dart';

final class WalletRequestImportNewKey
    extends WalletRequest<EncryptedMasterKey, MessageArgsOneBytes> {
  final ImportedKeyStorage newKey;
  const WalletRequestImportNewKey._(this.newKey);

  factory WalletRequestImportNewKey(ImportedKeyStorage newKey) {
    return WalletRequestImportNewKey._(newKey);
  }
  factory WalletRequestImportNewKey.deserialize(
      {List<int>? bytes, CborObject? object, String? hex}) {
    final CborListValue values = CborSerializable.cborTagValue(
        cborBytes: bytes,
        object: object,
        hex: hex,
        tags: WalletRequestMethod.updateWalletKeys.tag);
    return WalletRequestImportNewKey(ImportedKeyStorage.fromCborBytesOrObject(
        obj: values.elementAsCborTag(0)));
  }

  @override
  CborTagValue toCbor() {
    return CborTagValue(
        CborSerializable.fromDynamic([newKey.toCbor()]), method.tag);
  }

  @override
  WalletRequestMethod get method => WalletRequestMethod.updateWalletKeys;

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
    final newWallet = wallet.masterKey.importCustomKey(newKey);
    return newWallet.encrypt(wallet);
  }
}
