import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:on_chain_wallet/app/error/exception/app_exception.dart';
import 'package:on_chain_wallet/app/serialization/serialization.dart';
import 'package:on_chain_wallet/wallet/constant/tags/constant.dart';

enum WalletPlatformCredentialType {
  webAuth(CborTagsConst.walletPlatformCredentialWebAuth),
  localAuth(CborTagsConst.walletPlatformCredentialLocalAuth);

  final List<int> tags;
  const WalletPlatformCredentialType(this.tags);
  static WalletPlatformCredentialType fromValue(List<int>? tags) {
    return values.firstWhere((e) => BytesUtils.bytesEqual(tags, e.tags),
        orElse: () => throw AppSerializationException(
            objectName: "WalletPlatformCredentialType.fromValue"));
  }
}

abstract final class WalletPlatformCredential with CborSerializable {
  final WalletPlatformCredentialType type;
  const WalletPlatformCredential({required this.type});
  factory WalletPlatformCredential.deserialize(
      {List<int>? bytes, CborObject? obj, String? hex}) {
    final CborTagValue decode =
        CborSerializable.decode(cborBytes: bytes, hex: hex, object: obj);
    final type = WalletPlatformCredentialType.fromValue(decode.tags);
    return switch (type) {
      WalletPlatformCredentialType.localAuth =>
        WalletPlatformCredentialIo.deserialize(obj: decode),
      WalletPlatformCredentialType.webAuth =>
        WalletPlatformCredentialWeb.deserialize(obj: decode)
    };
  }
}

final class WalletPlatformCredentialIo extends WalletPlatformCredential {
  const WalletPlatformCredentialIo()
      : super(type: WalletPlatformCredentialType.localAuth);
  factory WalletPlatformCredentialIo.deserialize(
      {List<int>? bytes, CborObject? obj, String? hex}) {
    CborSerializable.cborTagValue(
        cborBytes: bytes,
        hex: hex,
        object: obj,
        tags: WalletPlatformCredentialType.localAuth.tags);
    return WalletPlatformCredentialIo();
  }
  @override
  CborTagValue<CborObject> toCbor() {
    return CborTagValue(CborListValue.definite(<CborObject>[]), type.tags);
  }
}

final class WalletPlatformCredentialWeb extends WalletPlatformCredential {
  final List<int> id;
  final List<int> publicKey;
  WalletPlatformCredentialWeb(
      {required List<int> id, required List<int> publicKey})
      : id = id.asImmutableBytes,
        publicKey = publicKey.asImmutableBytes,
        super(type: WalletPlatformCredentialType.webAuth);
  factory WalletPlatformCredentialWeb.deserialize(
      {List<int>? bytes, CborObject? obj, String? hex}) {
    final CborListValue values = CborSerializable.cborTagValue(
        cborBytes: bytes,
        hex: hex,
        object: obj,
        tags: WalletPlatformCredentialType.webAuth.tags);
    return WalletPlatformCredentialWeb(
        id: values.valueAs(0), publicKey: values.valueAs(1));
  }

  @override
  CborTagValue<CborObject> toCbor() {
    return CborTagValue(
        CborListValue.definite(
            <CborObject>[CborBytesValue(id), CborBytesValue(publicKey)]),
        type.tags);
  }
}
