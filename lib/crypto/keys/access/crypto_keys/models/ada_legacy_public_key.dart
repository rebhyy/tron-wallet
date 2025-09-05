part of 'package:on_chain_wallet/crypto/keys/access/crypto_keys/crypto_keys.dart';

final class AdaLegacyPublicKeyData extends CryptoPublicKeyData {
  final String hdPathKey;
  @override
  String get chainCode => super.chainCode!;
  @override
  final String keyName;
  AdaLegacyPublicKeyData._(
      {required super.extendedKey,
      required super.comprossed,
      required super.uncomprossed,
      required this.keyName,
      required this.hdPathKey,
      required String super.chainCode,
      required super.curve})
      : super._(type: CryptoPublicKeyDataType.ada);
  factory AdaLegacyPublicKeyData._fromBip32(
      {required Bip32Base account,
      required List<int> hdPathKey,
      required String keyName}) {
    final comperesed = BytesUtils.toHexString(account.publicKey.compressed);
    final uncompresed = BytesUtils.toHexString(account.publicKey.uncompressed);
    return AdaLegacyPublicKeyData._(
        extendedKey: account.publicKey.toExtended,
        comprossed: comperesed,
        uncomprossed: uncompresed == comperesed ? null : uncompresed,
        keyName: keyName,
        chainCode: account.chainCode.toHex(),
        hdPathKey: BytesUtils.toHexString(hdPathKey),
        curve: account.curveType);
  }
  factory AdaLegacyPublicKeyData.deserialize(
      {List<int>? bytes, CborObject? obj}) {
    final CborListValue cbor = CborSerializable.cborTagValue(
        cborBytes: bytes,
        object: obj,
        tags: CryptoKeyConst.accessAdaPubliKeyResponse);
    return AdaLegacyPublicKeyData._(
        extendedKey: cbor.valueAs(0),
        comprossed: cbor.valueAs(1),
        uncomprossed: cbor.valueAs(2),
        keyName: cbor.valueAs(3),
        hdPathKey: cbor.valueAs(4),
        chainCode: cbor.valueAs(5),
        curve: EllipticCurveTypes.fromName(cbor.valueAs(6)));
  }

  @override
  CborTagValue toCbor() {
    return CborTagValue(
        CborSerializable.fromDynamic([
          extendedKey,
          comprossed,
          uncomprossed ?? const CborNullValue(),
          keyName,
          hdPathKey,
          chainCode,
          curve.name
        ]),
        type.tag);
  }

  List<int> hdPathKeyBytes() {
    return BytesUtils.fromHexString(hdPathKey);
  }

  @override
  List<int> chainCodeBytes() {
    return BytesUtils.fromHexString(chainCode);
  }
}
