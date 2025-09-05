import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:on_chain_wallet/app/core.dart';
import 'package:on_chain_wallet/crypto/keys/access/crypto_keys/crypto_keys.dart';
import 'package:on_chain_wallet/crypto/requets/argruments/argruments.dart';
import 'package:on_chain_wallet/crypto/requets/messages/core/message.dart';

final class WalletRequestReadPublicKeys
    extends WalletRequest<List<CryptoPublicKeyData>, MessageArgsOneBytes> {
  final AccessCryptoPrivateKeysRequest request;
  const WalletRequestReadPublicKeys._(this.request);

  factory WalletRequestReadPublicKeys(AccessCryptoPrivateKeysRequest request) {
    return WalletRequestReadPublicKeys._(request);
  }
  factory WalletRequestReadPublicKeys.deserialize(
      {List<int>? bytes, CborObject? object, String? hex}) {
    final CborListValue values = CborSerializable.cborTagValue(
        cborBytes: bytes,
        object: object,
        hex: hex,
        tags: WalletRequestMethod.readPublicKeys.tag);
    return WalletRequestReadPublicKeys(
        AccessCryptoPrivateKeysRequest.fromCborBytesOrObject(
            obj: values.elementAsCborTag(0)));
  }

  @override
  CborTagValue toCbor() {
    return CborTagValue(
        CborSerializable.fromDynamic([request.toCbor()]), method.tag);
  }

  @override
  WalletRequestMethod get method => WalletRequestMethod.readPublicKeys;

  @override
  Future<MessageArgsOneBytes> getResult(WalletInMemory wallet) async {
    final keys = wallet.masterKey.readPublicKeys(request.indexes);
    return MessageArgsOneBytes(keyOne: keys.toCbor().encode());
  }

  @override
  Future<List<CryptoPublicKeyData>> parsResult(
      MessageArgsOneBytes result) async {
    final response =
        CryptoPublicKeysResponse.fromCborBytesOrObject(bytes: result.keyOne);
    return response.keys;
  }

  @override
  Future<List<CryptoPublicKeyData>> result(WalletInMemory wallet) async {
    final keys = wallet.masterKey.readPublicKeys(request.indexes);
    return keys.keys;
  }
}
