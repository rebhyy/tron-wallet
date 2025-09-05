import 'package:blockchain_utils/bip/bip/conf/core/coins.dart';
import 'package:blockchain_utils/bip/mnemonic/mnemonic.dart';
import 'package:blockchain_utils/bip/ton/mnemonic/ton_mnemonic_validator.dart';
import 'package:blockchain_utils/cbor/cbor.dart';
import 'package:blockchain_utils/utils/utils.dart';
import 'package:on_chain_wallet/app/serialization/cbor/cbor.dart';
import 'package:on_chain_wallet/crypto/coins/coins.dart';
import 'package:on_chain_wallet/crypto/keys/access/crypto_keys/crypto_keys.dart';
import 'package:on_chain_wallet/crypto/requets/argruments/argruments.dart';
import 'package:on_chain_wallet/crypto/requets/messages/core/message.dart';
import 'package:on_chain_wallet/crypto/utils/ton/ton.dart';

class TonMnemonicToPrivateKeyMessage
    extends CryptoRequest<ImportCustomKeys, MessageArgsOneBytes> {
  final String mnemonic;
  final String? password;
  final bool validateTonMnemonic;
  final CryptoCoins coin;
  const TonMnemonicToPrivateKeyMessage._({
    required this.mnemonic,
    required this.password,
    required this.validateTonMnemonic,
    required this.coin,
  });

  factory TonMnemonicToPrivateKeyMessage(
      {required String mnemonic,
      String? password,
      required bool validateTonMnemonic,
      required CryptoCoins coin}) {
    return TonMnemonicToPrivateKeyMessage._(
        mnemonic: mnemonic,
        password: password,
        validateTonMnemonic: validateTonMnemonic,
        coin: coin);
  }
  factory TonMnemonicToPrivateKeyMessage.deserialize(
      {List<int>? bytes, CborTagValue? object}) {
    final CborListValue values = CborSerializable.cborTagValue(
        cborBytes: bytes,
        object: object,
        tags: CryptoRequestMethod.tonMnemonicToPrivateKey.tag);
    return TonMnemonicToPrivateKeyMessage(
        mnemonic: values.elementAs(0),
        password: values.elementAs(1),
        validateTonMnemonic: values.elementAs(2),
        coin: CustomCoins.getSerializationCoin(values.elementAs(3)));
  }

  @override
  CborTagValue toCbor() {
    return CborTagValue(
        CborSerializable.fromDynamic([
          mnemonic,
          password ?? const CborNullValue(),
          validateTonMnemonic,
          coin.toCbor()
        ]),
        method.tag);
  }

  @override
  MessageArgsOneBytes getResult() {
    final importedKey = CryptoKeyUtils.tonMnemonicToPrivateKey(
        coin: coin,
        mnemonic: mnemonic,
        password: password,
        validateTonMnemonic: validateTonMnemonic);
    return MessageArgsOneBytes(keyOne: importedKey.toCbor().encode());
  }

  @override
  ImportCustomKeys parsResult(MessageArgsOneBytes result) {
    return ImportCustomKeys.deserialize(bytes: result.keyOne);
  }

  @override
  CryptoRequestMethod get method => CryptoRequestMethod.tonMnemonicToPrivateKey;

  @override
  ImportCustomKeys result() {
    return CryptoKeyUtils.tonMnemonicToPrivateKey(
        coin: coin,
        mnemonic: mnemonic,
        password: password,
        validateTonMnemonic: validateTonMnemonic);
  }
}

class TonMenmonicGenerateMessage
    extends CryptoRequest<Mnemonic, MessageArgsOneBytes> {
  final String? password;
  final int wordsNum;
  const TonMenmonicGenerateMessage(
      {required this.password, required this.wordsNum});
  factory TonMenmonicGenerateMessage.deserialize(
      {List<int>? bytes, CborTagValue? object}) {
    final CborListValue values = CborSerializable.cborTagValue(
        cborBytes: bytes,
        object: object,
        tags: CryptoRequestMethod.generateMnemonic.tag);
    return TonMenmonicGenerateMessage(
        password: values.elementAs(0), wordsNum: values.elementAs(1));
  }

  @override
  CborTagValue toCbor() {
    return CborTagValue(
        CborSerializable.fromDynamic(
            [password ?? const CborNullValue(), wordsNum]),
        method.tag);
  }

  @override
  CryptoRequestMethod get method => CryptoRequestMethod.generateMnemonic;

  @override
  MessageArgsOneBytes getResult() {
    final mnemonic =
        TonUtils.generateTonMnemonic(wordsNum: wordsNum, password: password);

    return MessageArgsOneBytes(keyOne: StringUtils.encode(mnemonic.toStr()));
  }

  @override
  Mnemonic parsResult(MessageArgsOneBytes result) {
    return Mnemonic.fromString(StringUtils.decode(result.keyOne));
  }

  @override
  Mnemonic result() {
    return TonUtils.generateTonMnemonic(wordsNum: wordsNum, password: password);
  }
}

class TonMnemonicValidateMessage
    extends CryptoRequest<bool, MessageArgsOneBytes> {
  final String mnemonic;
  final String? password;
  const TonMnemonicValidateMessage._(
      {required this.mnemonic, required this.password});

  factory TonMnemonicValidateMessage(
      {required String mnemonic, String? password}) {
    return TonMnemonicValidateMessage._(mnemonic: mnemonic, password: password);
  }
  factory TonMnemonicValidateMessage.deserialize(
      {List<int>? bytes, CborTagValue? object}) {
    final CborListValue values = CborSerializable.cborTagValue(
        cborBytes: bytes,
        object: object,
        tags: CryptoRequestMethod.tonMnemonicValidate.tag);
    return TonMnemonicValidateMessage(
        mnemonic: values.valueAs(0), password: values.valueAs(1));
  }

  @override
  CborTagValue toCbor() {
    return CborTagValue(
        CborSerializable.fromDynamic(
            [mnemonic, password ?? const CborNullValue()]),
        method.tag);
  }

  @override
  MessageArgsOneBytes getResult() {
    return MessageArgsOneBytes.fromBool(result());
  }

  @override
  bool parsResult(MessageArgsOneBytes result) {
    return result.asBoolean();
  }

  @override
  CryptoRequestMethod get method => CryptoRequestMethod.tonMnemonicValidate;

  @override
  bool result() {
    try {
      TomMnemonicValidator()
          .validate(Mnemonic.fromString(mnemonic), password: password ?? "");
      return true;
    } catch (e) {
      return false;
    }
  }
}
