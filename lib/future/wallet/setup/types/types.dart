import 'package:blockchain_utils/bip/mnemonic/mnemonic_utils.dart';
import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:on_chain_wallet/crypto/keys/access/crypto_keys/crypto_keys.dart';
import 'package:on_chain_wallet/wallet/models/wallet/models/backup.dart';

enum WalletStupPage {
  main,
  mainWalletSetting;
}

enum APPWalletType {
  subwallet("subwallet"),
  mainwallet("mainwallet");

  final String tr;
  const APPWalletType(this.tr);
  bool get isMainWallet => this == mainwallet;
}

enum SetupWalletMode {
  generate,
  exist,
  backup;
}

enum MnemonicType {
  bip39(tr: "bip39", desc: "bip39_mnemonic_desc", supportPassPhrase: true),
  monero(tr: "monero", desc: "monero_mnemonic_desc2", supportPassPhrase: false),
  ton(tr: "ton", desc: "ton_mnemonic_desc2", supportPassPhrase: true);

  const MnemonicType(
      {required this.tr, required this.desc, required this.supportPassPhrase});
  final String desc;
  final String tr;
  final bool supportPassPhrase;

  SubWalletType get walletType => switch (this) {
        MnemonicType.bip39 => SubWalletType.bip39,
        MnemonicType.monero => SubWalletType.monero,
        MnemonicType.ton => SubWalletType.ton,
      };
}

class MenemonicLanguageView {
  final MnemonicLanguages language;
  final String name;
  final String identifier;
  const MenemonicLanguageView(
      {required this.language, required this.name, required this.identifier});
}

class MnemonicWordCountView {
  final int number;
  final String name;
  const MnemonicWordCountView({required this.number, required this.name});
}

class GeneratedMnemonic {
  final List<String> mnemonicWords;
  final Mnemonic mnemonic;
  final String? passphrase;
  final MnemonicLanguages? language;
  final MnemonicType type;
  final String? languageIdentifer;
  GeneratedMnemonic(
      {required this.mnemonic,
      required this.type,
      required this.languageIdentifer,
      this.passphrase,
      this.language})
      : mnemonicWords = mnemonic.toList().immutable;
}

typedef ONMNEMONICREADY = void Function(GeneratedMnemonic);

enum SetupMnemonicPage { generate, review, verify }

enum WalletBackupPage { backup, review }

typedef ONGENERATEMNEMONIC = Future<GeneratedMnemonic?> Function(
    MnemonicType? type, SetupWalletMode mode);

typedef ONRESTOREWALLETBACKUP = Future<WalletRestoreV2?> Function(
    String password);
