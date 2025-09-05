import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:on_chain_wallet/app/core.dart';
import 'package:on_chain_wallet/crypto/keys/access/crypto_keys/crypto_keys.dart';
import 'package:on_chain_wallet/crypto/requets/argruments/argruments.dart';
import 'package:on_chain_wallet/crypto/requets/messages/core/message.dart';
import 'package:on_chain_wallet/crypto/utils/crypto/utils.dart';

final class WalletRequestChangePassword
    extends WalletRequest<EncryptedMasterKey, MessageArgsOneBytes> {
  final List<int> newPassword;
  final List<int> checksum;
  WalletRequestChangePassword._(
      {required List<int> newPassword, required List<int> checksum})
      : newPassword = newPassword.asImmutableBytes,
        checksum = checksum.asImmutableBytes;

  factory WalletRequestChangePassword(
      {required String newPassword, required List<int> checksum}) {
    return WalletRequestChangePassword._(
        newPassword: StringUtils.encode(newPassword), checksum: checksum);
  }
  factory WalletRequestChangePassword.deserialize(
      {List<int>? bytes, CborObject? object, String? hex}) {
    final CborListValue values = CborSerializable.cborTagValue(
        cborBytes: bytes,
        object: object,
        hex: hex,
        tags: WalletRequestMethod.changeWalletPassword.tag);
    return WalletRequestChangePassword._(
        newPassword: values.valueAs(0), checksum: values.valueAs(1));
  }

  @override
  CborTagValue toCbor() {
    return CborTagValue(
        CborSerializable.fromDynamic(
            [CborBytesValue(newPassword), CborBytesValue(checksum)]),
        method.tag);
  }

  @override
  WalletRequestMethod get method => WalletRequestMethod.changeWalletPassword;

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
    return wallet.masterKey.encrypt_(
        key: WorkerCryptoUtils.hashKeyNew(key: newPassword, checksum: checksum),
        rawKey: newPassword,
        memoryKey: wallet.memoryKey);
  }
}
