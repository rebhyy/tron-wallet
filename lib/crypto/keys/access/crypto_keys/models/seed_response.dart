part of 'package:on_chain_wallet/crypto/keys/access/crypto_keys/crypto_keys.dart';

class AccessMnemonicResponse extends CryptoKeyData {
  final Mnemonic mnemonic;
  final List<SubWalletMnemonicResponse> subWallets;
  AccessMnemonicResponse._(
      {required this.mnemonic,
      required List<SubWalletMnemonicResponse> subWallets})
      : subWallets = subWallets.immutable,
        super._();

  factory AccessMnemonicResponse.deserialize(
      {List<int>? bytes, CborObject? obj}) {
    final CborListValue values = CborSerializable.cborTagValue(
        cborBytes: bytes,
        object: obj,
        tags: CryptoKeyConst.accessMnemonicResponse);
    return AccessMnemonicResponse._(
      mnemonic: Mnemonic.fromString(values.valueAs(0)),
      subWallets: values
          .elementAsListOf<CborTagValue>(1)
          .map((e) => SubWalletMnemonicResponse.deserialize(obj: e))
          .toList(),
    );
  }

  @override
  CborTagValue toCbor() {
    return CborTagValue(
        CborListValue<CborObject>.definite([
          CborStringValue(mnemonic.toStr()),
          CborListValue.definite(subWallets.map((e) => e.toCbor()).toList())
        ]),
        CryptoKeyConst.accessMnemonicResponse);
  }

  @override
  String get keyName => "mnemonic";
}

final class SubWalletMnemonicResponse with CborSerializable {
  final int subWalletId;
  final Mnemonic mnemonic;
  const SubWalletMnemonicResponse._(
      {required this.subWalletId, required this.mnemonic});

  factory SubWalletMnemonicResponse.deserialize(
      {List<int>? bytes, CborObject? obj}) {
    final CborListValue values = CborSerializable.cborTagValue(
        cborBytes: bytes,
        object: obj,
        tags: CryptoKeyConst.subWalletMnemonicResponse);
    return SubWalletMnemonicResponse._(
        mnemonic: Mnemonic.fromString(values.valueAs(0)),
        subWalletId: values.valueAs(1));
  }

  @override
  CborTagValue<CborObject> toCbor() {
    return CborTagValue(
        CborListValue<CborObject>.definite([
          CborStringValue(mnemonic.toStr()),
          CborIntValue(subWalletId),
        ]),
        CryptoKeyConst.subWalletMnemonicResponse);
  }
}
