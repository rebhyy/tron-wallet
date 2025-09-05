import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:on_chain_wallet/app/core.dart';
import 'package:on_chain_wallet/crypto/keys/access/crypto_keys/crypto_keys.dart';
import 'package:on_chain_wallet/crypto/requets/argruments/argruments.dart';
import 'package:on_chain_wallet/crypto/requets/messages/core/message.dart';

final class WalletRequestBackupWallet
    extends WalletRequest<String, MessageArgsOneBytes> {
  final String? passhrase;
  final String? newPassword;
  final List<int> checksum;

  WalletRequestBackupWallet(
      {required this.passhrase,
      required this.newPassword,
      required List<int> checksum})
      : checksum = checksum.asImmutableBytes;

  factory WalletRequestBackupWallet.deserialize(
      {List<int>? bytes, CborObject? object, String? hex}) {
    final CborListValue values = CborSerializable.cborTagValue(
        cborBytes: bytes,
        object: object,
        hex: hex,
        tags: WalletRequestMethod.walletBackup.tag);
    return WalletRequestBackupWallet(
        newPassword: values.valueAs(0),
        passhrase: values.valueAs(1),
        checksum: values.valueAs(2));
  }

  @override
  CborTagValue toCbor() {
    return CborTagValue(
        CborSerializable.fromDynamic(
            [newPassword, passhrase, CborBytesValue(checksum)]),
        method.tag);
  }

  @override
  WalletRequestMethod get method => WalletRequestMethod.walletBackup;

  @override
  Future<MessageArgsOneBytes> getResult(WalletInMemory wallet) async {
    final encrypt = await result(wallet);
    return MessageArgsOneBytes(keyOne: BytesUtils.fromHexString(encrypt));
  }

  @override
  Future<String> parsResult(MessageArgsOneBytes result) async {
    return BytesUtils.toHexString(result.keyOne);
  }

  @override
  Future<String> result(WalletInMemory wallet) async {
    final masterKey = WalletMasterKeys.generate(
        mnemonic: wallet.masterKey.mnemonic().mnemonic.toStr(),
        passphrase: passhrase);
    if (!BytesUtils.bytesEqual(masterKey.checksum, wallet.masterKey.checksum)) {
      throw WalletExceptionConst.invalidBackupChecksum;
    }
    final web3SD = Web3SecretStorageDefinationV3.encode(
        wallet.masterKey.toCbor(backupChecksum: checksum).encode(),
        newPassword ?? wallet.password);
    return web3SD.encrypt(encoding: SecretWalletEncoding.cbor);
  }
}

final class WalletRequestBackupKey
    extends WalletRequest<String, MessageArgsOneBytes> {
  final List<int> backup;
  final SecretWalletEncoding encoding;

  WalletRequestBackupKey({required this.encoding, required List<int> backup})
      : backup = backup.asImmutableBytes;

  factory WalletRequestBackupKey.deserialize(
      {List<int>? bytes, CborObject? object, String? hex}) {
    final CborListValue values = CborSerializable.cborTagValue(
        cborBytes: bytes,
        object: object,
        hex: hex,
        tags: WalletRequestMethod.encodeBackup.tag);
    final encoding = SecretWalletEncoding.values.firstWhere(
        (element) => element.name == values.elementAs<String>(1),
        orElse: () => throw AppSerializationException(
            objectName: "WalletRequestBackupKey.deserialize"));
    return WalletRequestBackupKey(
        backup: values.valueAs(0), encoding: encoding);
  }

  @override
  CborTagValue toCbor() {
    return CborTagValue(
        CborSerializable.fromDynamic([CborBytesValue(backup), encoding.name]),
        method.tag);
  }

  @override
  WalletRequestMethod get method => WalletRequestMethod.encodeBackup;

  @override
  Future<MessageArgsOneBytes> getResult(WalletInMemory wallet) async {
    final encrypt = await result(wallet);
    return MessageArgsOneBytes(keyOne: BytesUtils.fromHexString(encrypt));
  }

  @override
  Future<String> parsResult(MessageArgsOneBytes result) async {
    return BytesUtils.toHexString(result.keyOne);
  }

  @override
  Future<String> result(WalletInMemory wallet) async {
    final web3SD =
        Web3SecretStorageDefinationV3.encode(backup, wallet.password);
    return web3SD.encrypt(encoding: encoding);
  }
}
