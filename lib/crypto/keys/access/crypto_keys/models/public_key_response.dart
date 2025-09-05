part of 'package:on_chain_wallet/crypto/keys/access/crypto_keys/crypto_keys.dart';

final class PublicKeyData extends CryptoPublicKeyData {
  @override
  final String keyName;

  PublicKeyData.__(
      {required super.extendedKey,
      required super.comprossed,
      required super.uncomprossed,
      required this.keyName,
      required super.chainCode,
      required super.curve})
      : super._(
          type: CryptoPublicKeyDataType.public,
        );
  factory PublicKeyData._fromBip32(
      {required Bip32Base account, required String keyName}) {
    final comperesed = BytesUtils.toHexString(account.publicKey.compressed);
    final uncompresed = BytesUtils.toHexString(account.publicKey.uncompressed);
    return PublicKeyData.__(
        extendedKey: account.publicKey.toExtended,
        comprossed: comperesed,
        uncomprossed: uncompresed == comperesed ? null : uncompresed,
        keyName: keyName,
        chainCode: account.publicKey.chainCode.toHex(),
        curve: account.curveType);
  }
  factory PublicKeyData._(
      {required IPublicKey key,
      required CryptoCoins coin,
      required String keyName}) {
    final comperesed = BytesUtils.toHexString(key.compressed);
    final uncompresed = BytesUtils.toHexString(key.uncompressed);
    return PublicKeyData.__(
        extendedKey: null,
        comprossed: key.toHex(),
        uncomprossed: uncompresed == comperesed ? null : uncompresed,
        keyName: keyName,
        chainCode: null,
        curve: key.curve);
  }

  factory PublicKeyData.deserialize({List<int>? bytes, CborObject? obj}) {
    final CborListValue cbor = CborSerializable.cborTagValue(
        cborBytes: bytes,
        object: obj,
        tags: CryptoKeyConst.accessPubliKeyResponse);
    return PublicKeyData.__(
        extendedKey: cbor.valueAs(0),
        comprossed: cbor.valueAs(1),
        uncomprossed: cbor.valueAs(2),
        keyName: cbor.valueAs(3),
        chainCode: cbor.valueAs(4),
        curve: EllipticCurveTypes.fromName(cbor.valueAs(5)));
  }

  @override
  CborTagValue toCbor() {
    return CborTagValue(
        CborSerializable.fromDynamic([
          extendedKey,
          comprossed,
          uncomprossed ?? const CborNullValue(),
          keyName,
          chainCode,
          curve.name
        ]),
        type.tag);
  }
}
