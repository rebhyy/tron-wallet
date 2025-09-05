import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:on_chain_wallet/app/core.dart';
import 'package:on_chain_wallet/crypto/requets/argruments/argruments.dart';
import 'package:on_chain_wallet/crypto/requets/messages/core/message.dart';
import 'package:on_chain_wallet/crypto/utils/crypto/utils.dart';

class CryptoRequestWalletKey
    extends CryptoRequest<List<int>, MessageArgsOneBytes> {
  final List<int> key;
  final List<int> checksum;
  CryptoRequestWalletKey._(
      {required List<int> key, required List<int> checksum})
      : key = key.asImmutableBytes,
        checksum = checksum.asImmutableBytes;
  factory CryptoRequestWalletKey.fromString(
      {required String key, required List<int> checksum, int version = 2}) {
    final keyBytes = StringUtils.encode(key);
    return CryptoRequestWalletKey._(key: keyBytes, checksum: checksum);
  }

  factory CryptoRequestWalletKey.deserialize(
      {List<int>? bytes, CborObject? object, String? hex}) {
    final CborListValue values = CborSerializable.cborTagValue(
        cborBytes: bytes,
        object: object,
        hex: hex,
        tags: CryptoRequestMethod.walletKey.tag);
    return CryptoRequestWalletKey._(
        key: values.valueAs(0), checksum: values.valueAs(1));
  }

  @override
  CborTagValue toCbor() {
    return CborTagValue(
        CborSerializable.fromDynamic(
            [CborBytesValue(key), CborBytesValue(checksum)]),
        method.tag);
  }

  @override
  CryptoRequestMethod get method => CryptoRequestMethod.walletKey;

  @override
  MessageArgsOneBytes getResult() {
    final walletKey =
        WorkerCryptoUtils.hashKeyNew(key: key, checksum: checksum);
    return MessageArgsOneBytes(keyOne: walletKey);
  }

  @override
  List<int> parsResult(MessageArgsOneBytes result) {
    return result.keyOne;
  }

  @override
  List<int> result() {
    return WorkerCryptoUtils.hashKeyNew(key: key, checksum: checksum);
  }
}
