import 'app_exception.dart';

class WalletException implements AppException {
  const WalletException.error(this.message);
  @override
  final String message;

  const WalletException._(this.message);
  @override
  String toString() {
    return message;
  }

  @override
  bool operator ==(other) {
    if (other is! WalletException) return false;
    return other.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}

class WalletExceptionConst {
  static const WalletException pubkeyRequired =
      WalletException._("public_key_required_derive_address");

  static const WalletException toManyNetworkImported =
      WalletException._("to_many_networks_imported");

  static const WalletException invalidRequest =
      WalletException._("invalid_request");
  static WalletException invalidAccountDeta(String where) =>
      WalletException._("invalid_account_details");
  static const WalletException networkAlreadyExist =
      WalletException._("network_chain_id_already_exist");
  static const WalletException invalidBitcoinAddressType =
      WalletException._("invalid_bitcoin_address_type");
  static const WalletException invalidBackup =
      WalletException._("invalid_wallet_backup");
  static const WalletException invalidBackupOptions =
      WalletException._("invalid_backup_options");
  static const WalletException invalidBackupChecksum =
      WalletException._("invalid_wallet_backup_checksum");
  static const WalletException authFailed = WalletException._("auth_failed");
  static const WalletException passwordTooWeak =
      WalletException._("weak_password_validator");
  static const WalletException passwordUsedBefore =
      WalletException._("password_used_before");
  static const WalletException incorrectWalletData =
      WalletException._("wallet_data_is_invalid");
  static const WalletException tooManyAccounts =
      WalletException._("to_many_accounts");
  static const WalletException incorrectNetwork =
      WalletException._("incorrect_network");
  static const WalletException invalidProviderInformation =
      WalletException._("invalid_provider_infomarion");
  static const WalletException addressAlreadyExist =
      WalletException._("address_already_exist");
  static const WalletException keyAlreadyExist =
      WalletException._("key_already_exists");
  static const WalletException accountDoesNotFound =
      WalletException._("account_not_found");
  static const WalletException notAuthorizedSigningAccount =
      WalletException._("signing_auth_validator");
  static const WalletException signerAccountNotFound =
      WalletException._("signer_account_does_not_exists");
  static const WalletException noActiveProvider =
      WalletException._("no_acitve_provider");

  /// signer_account_does_not_exists
  static const WalletException incompleteWalletSetup =
      WalletException._("incomplete_wallet_setup");
  static const WalletException walletDoesNotExists =
      WalletException._("wallet_does_not_exists");

  static const WalletException toManyRequests =
      WalletException._("to_many_request");
  static const WalletException rejectSigning =
      WalletException._("user_rejected_signing_request");
  static const WalletException incorrectStatus =
      WalletException._("incorrect_wallet_status");
  static const WalletException invalidContactDetails =
      WalletException._("invalid_contact_details");
  static const WalletException contactExists =
      WalletException._("contact_already_exist");
  static const WalletException invalidBalance =
      WalletException._("invalid_balance");
  static const WalletException unsuportedFeature =
      WalletException._("unsuported_feature");
  static const WalletException unsuportedBackupVersion =
      WalletException._("unsuported_backup_version");
  static const WalletException featureUnavailableForMultiSignature =
      WalletException._("feature__unavailable_for_multi_signature");
  static const WalletException insufficientBalance =
      WalletException._("insufficient_balance");
  static const WalletException decryptionFailed =
      WalletException._("decryption_failed");
  static const WalletException invalidNetworkInformation =
      WalletException._("invalid_network_information");

  static const WalletException emptyThrow = WalletException._("");
  static const WalletException invalidChainState =
      WalletException._("invalid_chain_state");
  static const WalletException invalidWeb3AccountData =
      WalletException._("invalid_web3_account_data");

  static const WalletException invalidRipplePrivateKeyAlgorithm =
      WalletException._("invalid_ripple_privatekey_algorithm");

  static const WalletException inaccessibleKeyAlgorithm =
      WalletException._("inaccessible_key_algorithm");
  static const WalletException invalidTokenInformation =
      WalletException._("invalid_token_information");
  static const WalletException invalidNftInformation =
      WalletException._("invalid_nft_information");

  static const WalletException walletIsLocked =
      WalletException._("wallet_is_locked");
  static const WalletException networkTokenUnsuported =
      WalletException._("network_support_token_error");
  static const WalletException networkNFTsUnsuported =
      WalletException._("network_support_nft_error");
  static const WalletException tokenAlreadyExist =
      WalletException._("token_already_exists");
  static const WalletException nftsAlreadyExist =
      WalletException._("nfts_already_exists");

  static const WalletException walletAlreadyExists =
      WalletException._("wallet_already_exists");
  static const WalletException walletNameExists =
      WalletException._("wallet_name_exists");
  static const WalletException pageClosed = WalletException._("page_closed");
  static const WalletException walletIsNotavailable =
      WalletException._("wallet_is_not_available");

  static const WalletException ethSubscribe =
      WalletException._("eth_subscribe_websocket_requirment");
  static const WalletException networkDoesNotExist =
      WalletException._("network_does_not_exist");

  static const WalletException verificationWalletDataFailed =
      WalletException._("wallet_data_verification_failed");

  static const WalletException storageIsNotAvailable =
      WalletException._("storage_is_not_available");

  static const WalletException invalidWalletTransactionData =
      WalletException._("invalid_wallet_transaction_data");

  static const WalletException invalidSwapInformation =
      WalletException._("invalid_swap_information");

  static const WalletException invalidAccountUtxo =
      WalletException._("invalid_account_utxo");

  static WalletException internalError(String where) {
    return WalletException._("unexpected_error");
  }
}

class AppCryptoExceptionConst {
  static const AppCryptoException invalidCredential =
      AppCryptoException("invalid_credential");
  static const AppCryptoException invalidDerivationKey =
      AppCryptoException("invalid_key_derivation");
  static const AppCryptoException invalidKeyDerivationPath =
      AppCryptoException("invalid_derivation_path");
  static const AppCryptoException invalidMnemonicPassphrase =
      AppCryptoException("invalid_passphrase");
  static const AppCryptoException invalidMnemonic =
      AppCryptoException("invalid_mnemonic");

  static const AppCryptoException invalidPrivateKey =
      AppCryptoException("private_key_invalid");
  static const AppCryptoException invalidExtendedKey =
      AppCryptoException("extended_key_invalid");
  static const AppCryptoException invalidWifKey =
      AppCryptoException("wif_key_invalid");
  static const AppCryptoException invalidBip39MnemonicWords =
      AppCryptoException("invalid_bip39_mnemonic_words");
  static const AppCryptoException invalidCoin =
      AppCryptoException("invalid_coin");
  static const AppCryptoException importedKeyDerivationNotAllowed =
      AppCryptoException("imported_key_derivation_not_allowed");
  static const AppCryptoException multiSigDerivationNotSuported =
      AppCryptoException("not_support_multisig_derivation");
  static const AppCryptoException privateKeyIsNotAvailable =
      AppCryptoException("private_key_is_not_available");
  static const AppCryptoException invalidHexBytes =
      AppCryptoException("invalid_hex_bytes_string");
  static AppCryptoException internalError(String where) {
    return AppCryptoException("unexpected_error");
  }
}

class AppExceptionConst {
  static AppException internalError(String where) {
    return AppException("unexpected_error");
  }

  static const AppException requestCanceled = AppException("request_cancelled");
  static const AppException fileVerificationFiled =
      AppException("file_verification_fail");
  static const AppException invalidPriceFormat =
      AppException("invalid_price_format");
  static const AppException fileDoesNotExists =
      AppException("file_does_not_exist");
}
