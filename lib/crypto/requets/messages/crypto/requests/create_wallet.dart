import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:on_chain_wallet/app/core.dart';
import 'package:on_chain_wallet/crypto/keys/access/crypto_keys/crypto_keys.dart';
import 'package:on_chain_wallet/crypto/requets/argruments/argruments.dart';
import 'package:on_chain_wallet/crypto/requets/messages/core/message.dart';
import 'package:on_chain_wallet/crypto/requets/messages/models/models/create_wallet.dart';
import 'package:on_chain_wallet/crypto/utils/crypto/utils.dart';

final class CryptoRequestCreateHDWallet
    extends CryptoRequest<CryptoCreateWalletResponse, MessageArgsTwoBytes> {
  final String mnemonic;
  final String? passphrase;
  final String password;
  final List<int> checksum;
  const CryptoRequestCreateHDWallet(
      {required this.mnemonic,
      required this.passphrase,
      required this.password,
      required this.checksum});

  factory CryptoRequestCreateHDWallet.deserialize(
      {List<int>? bytes, CborObject? object, String? hex}) {
    final CborListValue values = CborSerializable.cborTagValue(
        cborBytes: bytes,
        object: object,
        hex: hex,
        tags: CryptoRequestMethod.createWallet.tag);
    return CryptoRequestCreateHDWallet(
        mnemonic: values.valueAs(0),
        passphrase: values.valueAs(1),
        password: values.valueAs(2),
        checksum: values.valueAs(3));
  }

  /// MasterKey, storage encryptedBytes, checksum
  static CryptoCreateWalletResponse createHdWallet({
    required String mnemonic,
    required String? passphrase,
    required String password,
    required List<int> checksum,
  }) {
    final masterKey =
        WalletMasterKeys.generate(mnemonic: mnemonic, passphrase: passphrase);
    final key = WorkerCryptoUtils.hashKeyNew(
        key: StringUtils.encode(password), checksum: checksum);
    final encrypt = masterKey.encrypt_(
        key: key,
        rawKey: StringUtils.encode(password),
        memoryKey: QuickCrypto.generateRandom());
    return CryptoCreateWalletResponse(masterKey: encrypt, checksum: checksum);
  }

  @override
  MessageArgsTwoBytes getResult() {
    final data = createHdWallet(
        mnemonic: mnemonic,
        passphrase: passphrase,
        password: password,
        checksum: checksum);
    return MessageArgsTwoBytes(
        keyOne: data.masterKey.toCbor().encode(), keyTwo: data.checksum);
  }

  @override
  CryptoCreateWalletResponse parsResult(MessageArgsTwoBytes result) {
    return CryptoCreateWalletResponse(
        masterKey: EncryptedMasterKey.deserialize(bytes: result.keyOne),
        checksum: result.keyTwo);
  }

  @override
  CborTagValue toCbor() {
    return CborTagValue(
        CborSerializable.fromDynamic(
            [mnemonic, passphrase, password, CborBytesValue(checksum)]),
        method.tag);
  }

  @override
  CryptoRequestMethod get method => CryptoRequestMethod.createWallet;

  @override
  CryptoCreateWalletResponse result() {
    return createHdWallet(
        mnemonic: mnemonic,
        passphrase: passphrase,
        password: password,
        checksum: checksum);
  }
}
