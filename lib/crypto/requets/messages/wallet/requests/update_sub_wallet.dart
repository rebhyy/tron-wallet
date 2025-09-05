import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:on_chain_wallet/app/core.dart';
import 'package:on_chain_wallet/crypto/keys/access/crypto_keys/crypto_keys.dart';
import 'package:on_chain_wallet/crypto/requets/argruments/argruments.dart';
import 'package:on_chain_wallet/crypto/requets/messages/core/message.dart';
import 'package:on_chain_wallet/crypto/requets/messages/models/models/generate_master_key.dart';

final class WalletRequestImportSubWallet
    extends WalletRequest<CryptoImportSubWalletResponse, MessageArgsTwoBytes> {
  final String mnemonic;
  final String? passphrase;
  final SubWalletType type;
  const WalletRequestImportSubWallet(
      {required this.mnemonic, required this.passphrase, required this.type});

  factory WalletRequestImportSubWallet.deserialize(
      {List<int>? bytes, CborObject? object, String? hex}) {
    final CborListValue values = CborSerializable.cborTagValue(
        cborBytes: bytes,
        object: object,
        hex: hex,
        tags: WalletRequestMethod.importSubWallet.tag);
    return WalletRequestImportSubWallet(
        mnemonic: values.valueAs(0),
        passphrase: values.valueAs(1),
        type: SubWalletType.fromValue(values.valueAs(2)));
  }

  @override
  CborTagValue toCbor() {
    return CborTagValue(
        CborSerializable.fromDynamic(
            [CborStringValue(mnemonic), passphrase, CborBytesValue(type.tags)]),
        method.tag);
  }

  @override
  WalletRequestMethod get method => WalletRequestMethod.importSubWallet;

  @override
  Future<MessageArgsTwoBytes> getResult(WalletInMemory wallet) async {
    final newWallet = wallet.masterKey.importNewSubWallet(
        mnemonic: mnemonic, type: type, passphrase: passphrase);
    final encryptWallet = newWallet.$1.encrypt(wallet);
    return MessageArgsTwoBytes(
        keyOne: encryptWallet.toCbor().encode(),
        keyTwo: IntUtils.toBytes(newWallet.$2, length: 4));
  }

  @override
  Future<CryptoImportSubWalletResponse> parsResult(
      MessageArgsTwoBytes result) async {
    return CryptoImportSubWalletResponse(
        masterKey: EncryptedMasterKey.deserialize(bytes: result.keyOne),
        subWalletId: IntUtils.fromBytes(result.keyTwo));
  }

  @override
  Future<CryptoImportSubWalletResponse> result(WalletInMemory wallet) async {
    final newWallet = wallet.masterKey.importNewSubWallet(
        mnemonic: mnemonic, type: type, passphrase: passphrase);
    final encryptWallet = newWallet.$1.encrypt(wallet);
    return CryptoImportSubWalletResponse(
        masterKey: encryptWallet, subWalletId: newWallet.$2);
  }
}
