import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:on_chain_wallet/app/core.dart';
import 'package:on_chain_wallet/crypto/requets/argruments/argruments.dart';
import 'package:on_chain_wallet/crypto/requets/messages/core/message.dart';

class CryptoRequestDecodeBackup
    extends CryptoRequest<List<int>, MessageArgsOneBytes> {
  final String password;
  final String backup;
  final SecretWalletEncoding encoding;
  CryptoRequestDecodeBackup(
      {required this.password, required this.backup, required this.encoding});
  factory CryptoRequestDecodeBackup.deserialize(
      {List<int>? bytes, CborObject? object, String? hex}) {
    final CborListValue values = CborSerializable.cborTagValue(
        cborBytes: bytes,
        object: object,
        hex: hex,
        tags: CryptoRequestMethod.decodeBackup.tag);
    final encoding = SecretWalletEncoding.values.firstWhere(
        (element) => element.name == values.elementAs<String>(2),
        orElse: () => throw AppSerializationException(
            objectName: "CryptoRequestDecodeBackup.deserialize"));
    return CryptoRequestDecodeBackup(
        password: values.elementAs(0),
        backup: values.elementAs(1),
        encoding: encoding);
  }

  @override
  CborTagValue toCbor() {
    return CborTagValue(
        CborSerializable.fromDynamic([password, backup, encoding.name]),
        method.tag);
  }

  @override
  CryptoRequestMethod get method => CryptoRequestMethod.decodeBackup;

  @override
  MessageArgsOneBytes getResult() {
    final decode = Web3SecretStorageDefinationV3.decode(backup, password,
        encoding: encoding);
    return MessageArgsOneBytes(keyOne: decode.data);
  }

  @override
  List<int> parsResult(MessageArgsOneBytes result) {
    return result.keyOne;
  }

  @override
  List<int> result() {
    final decode = Web3SecretStorageDefinationV3.decode(backup, password,
        encoding: encoding);
    return decode.data;
  }
}
