// ignore_for_file: library_private_types_in_public_api

part of 'package:on_chain_wallet/wallet/provider/wallet_provider.dart';

mixin WalletManager on _WalletController {
  WStatus _status = WStatus.lock;
  Future<List<Web3ApplicationAuthentication>> _getAllWeb3Authenticated();

  final Map<String, WalletCredentialResponseVerify> _credentials = {};
  void _getCachedCredPassword(WalletCredentialResponseVerify id) {
    final cred = _credentials.remove(id.id);
    if (cred == null || !identical(id, cred)) {
      throw WalletExceptionConst.authFailed;
    }
  }

  /// emit unlocking walllet
  void _onUnlock() {}

  /// update wallet status
  void _setDefaultPageStatus() {
    if (_wallet.requiredPassword) {
      _status = WStatus.lock;
    } else {
      _status = WStatus.readOnly;
    }
    _credentials.clear();
  }

  void _logout() {
    _setDefaultPageStatus();
  }

  Future<List<int>> _getMemoryKey({bool newKey = false}) async {
    if (newKey) {
      final key = QuickCrypto.generateRandom();
      await _core._insertMainTableWalletStorage(value: key, key: _wallet.key);
      return key;
    }
    final data = await _core._readMainTableWalletStorage(key: _wallet.key);
    if (data == null) {
      _walletKey = null;
      _setDefaultPageStatus();
      throw WalletExceptionConst.authFailed;
    }
    return data;
  }

  Future<void> _login({String? password, bool? platformCredential}) async {
    if (platformCredential == true && _wallet.platformCredential == null) {
      throw WalletExceptionConst.authFailed;
    }
    if (!hasWalletKey && password == null) {
      throw WalletExceptionConst.authFailed;
    }
    if (password != null) {
      final key = await _getMemoryKey(newKey: !hasWalletKey);
      final request = CryptoRequestGenerateMasterKey.fromStorageWithStringKey(
          storageData: _wallet.data,
          key: password,
          checksum: _wallet.checkSumBytes,
          memoryKey: key);
      final walletKey = await crypto.cryptoIsolateRequest(request);
      if (!hasWalletKey) {
        if (request.version != WalletMasterKeysConst.keyVersion) {
          await _updateWallet(_wallet.updateData(walletKey.storageDataB64()));
        }
        _walletKey = walletKey;
      }
    } else {
      final pCredential = _wallet.platformCredential;
      if (platformCredential != true || pCredential == null) {
        throw WalletExceptionConst.authFailed;
      }
      final auth = await PlatformCryptoMethods.authenticate(
          credential: pCredential, reason: 'reason');
      if (auth != BiometricResult.success) {
        throw WalletExceptionConst.authFailed;
      }
    }
    if (!_status.isUnlock) {
      _status = WStatus.unlock;
      _onUnlock();
    }
  }

  /// dervie new address for chain
  /// - [newAccountParams] New account parameters.
  /// - [chain] chain for derive new address
  Future<NETWORKCHAINACCOUNT<NETWORKADDRESS>> _deriveNewAccount<NETWORKADDRESS>(
      {required NewAccountParams newAccountParams,
      required APPCHAINNETWORK<NETWORKADDRESS> chain}) async {
    final NETWORKCHAINACCOUNT<NETWORKADDRESS> account;
    if (newAccountParams.isMultiSig) {
      account = await chain.addNewAddress(null, newAccountParams);
    } else {
      if (newAccountParams.deriveIndex.isMultiSig) {
        throw AppCryptoExceptionConst.invalidDerivationKey;
      }
      final updateParams = await _callWalletInternal(
        (WalletInMemoryData masterKey, List<int> memoryKey) async {
          return WalletInternalCallResponse(
              result: await crypto.walletArgs(
                  message: WalletRequestDeriveAddress(
                      addressParams: newAccountParams),
                  masterKey: masterKey,
                  memoryKey: memoryKey));
        },
      );
      account = await chain.addNewAddress(
          updateParams.publicKey, updateParams.accountParams);
    }
    return account;
  }

  /// import private key to current wallet
  /// -[newKey]: new private key for import to current wallet.
  Future<void> _importNewKey(ImportedKeyStorage newKey,
      WalletCredentialResponseVerify credential) async {
    _getCachedCredPassword(credential);
    await _callWalletInternal(
        (WalletInMemoryData masterKey, List<int> memoryKey) async {
      final result = await crypto.walletArgs(
          message: WalletRequestImportNewKey(newKey),
          masterKey: masterKey,
          memoryKey: memoryKey);
      return WalletInternalCallResponse(result: null, key: result);
    });
  }

  /// - [removeKey]: private key from current wallet
  Future<void> _removeKey(EncryptedCustomKey removeKey,
      WalletCredentialResponseVerify credential) async {
    _getCachedCredPassword(credential);
    if (!_walletKey!.customKeys.contains(removeKey)) {
      throw WalletExceptionConst.accountDoesNotFound;
    }
    await _cleanUpdateRemovedKeyAccounts(removeKey.id);
    await _callWalletInternal(
      (WalletInMemoryData masterKey, List<int> memoryKey) async {
        final encrypt = await crypto.walletArgs(
            message: WalletRequestRemoveKey(removeKey.id),
            masterKey: masterKey,
            memoryKey: memoryKey);
        return WalletInternalCallResponse(result: null, key: encrypt);
      },
    );
  }

  void _expireCredential(WalletCredentialResponseVerify credential) {
    _credentials.remove(credential.id);
  }

  /// change current wallet password.
  /// - [newPassword]: new wallet password.
  Future<void> _changePassword(
      WalletCredentialResponseVerify credential, String newPassword) async {
    if (!PasswordUtils.canUseAsPassword(newPassword)) {
      throw WalletExceptionConst.passwordTooWeak;
    }
    _getCachedCredPassword(credential);
    await _callWalletInternal(
        (WalletInMemoryData masterKey, List<int> memoryKey) async {
      final encrypt = await crypto.walletArgs(
          message: WalletRequestChangePassword(
              newPassword: newPassword, checksum: _wallet.checkSumBytes),
          masterKey: masterKey,
          memoryKey: memoryKey);
      return WalletInternalCallResponse(result: null, key: encrypt);
    });
  }

  /// generate wallet backup
  /// - [type]: backup type (private keys, mnemonic or fully wallet backup)
  Future<String> _generateWalletKeyBackup(
      {required String data,
      required WalletBackupTypes type,
      required WalletCredentialResponseVerify credential}) async {
    if (type.isWalletBackup) {
      throw WalletExceptionConst.invalidBackupOptions;
    }
    _getCachedCredPassword(credential);
    return _callWalletInternal(
      (masterKey, memoryKey) async {
        final encrypt = await crypto.walletArgs(
            message: WalletRequestBackupKey(
                backup: type.toEncryptionBytes(data), encoding: type.encoding),
            masterKey: masterKey,
            memoryKey: memoryKey);
        if (type == WalletBackupTypes.keystore) {
          return WalletInternalCallResponse(result: encrypt);
        }
        final walletBackup = WalletKeyBackup(key: encrypt, type: type);
        return WalletInternalCallResponse(
            result: walletBackup.toCbor().toCborHex());
      },
    );
  }

  /// generate fully wallet backup
  Future<String> _generateWalletBackup(
      {required WalletCredentialResponseVerify credential,
      required GenerateWalletBackupOptions options}) async {
    _getCachedCredPassword(credential);
    final checksum = QuickCrypto.generateRandom();
    final encrypt = await _callWalletInternal(
      (masterKey, memoryKey) async {
        final result = await crypto.walletArgs(
            memoryKey: memoryKey,
            message: WalletRequestBackupWallet(
              newPassword: options.newPassword,
              passhrase: options.passphrase,
              checksum: checksum,
            ),
            masterKey: masterKey);
        return WalletInternalCallResponse(result: result);
      },
    );
    List<Web3ApplicationAuthentication> dapps = [];
    if (options.backupDapps) {
      dapps = await _getAllWeb3Authenticated();
    }
    final walletBackup = await _appChains.createBackup(
        masterKey: encrypt, options: options, web3Applications: dapps);
    return (await walletBackup.toCbor(checksum)).toCborHex();
  }

  Future<RESPONSE> _accsess<RESPONSE extends WalletCredentialResponse>(
      WalletCredentialRequest<RESPONSE> request,
      {String? password}) async {
    return await _callWalletInternal(
        (WalletInMemoryData masterKey, List<int> memoryKey) async {
      if (request.credential.type == WalletCredentialType.login) {
        return WalletInternalCallResponse(
            result: WalletCredentialResponseLogin.instance as RESPONSE);
      }
      Future<WalletCredentialResponseVerify> getVerifyCred() async {
        final id = await crypto.generateHashString(
            type: CryptoRequestHashingType.generateUuid);
        return WalletCredentialResponseVerify(id);
      }

      final verify = await getVerifyCred();
      WalletCredentialResponse? credential;
      switch (request.credential.type) {
        case WalletCredentialType.requirePassword:
          if (password != null) {
            credential = WalletCredentialResponseRequirePassword(id: verify);
          }
          break;
        case WalletCredentialType.verify:
          credential = verify;
          break;
        case WalletCredentialType.mnemonic:
          if (password != null) {
            final mnemonic = await crypto.walletArgs(
                memoryKey: memoryKey,
                message: WalletRequestReadMnemonic(),
                masterKey: masterKey);
            credential = WalletCredentialResponseMnemonic(
                credential: mnemonic, id: verify);
          }
          break;
        case WalletCredentialType.importedKey:
          if (password != null) {
            final keyRequest =
                request.credential.cast<WalletCredentialImportedKey>();
            final importedKey = await crypto.walletArgs(
                memoryKey: memoryKey,
                message: WalletRequestReadImportedKey(keyRequest.keyId),
                masterKey: masterKey);
            credential = WalletCredentialResponseImportedKey(
                credential: importedKey, id: verify);
          }
          break;
        case WalletCredentialType.accountKey:
          if (password != null) {
            final keyRequest =
                request.credential.cast<WalletCredentialAccountKey>();
            final indexes = keyRequest.account.accessKeysIndexes();
            final accountKeys = await crypto.walletArgs(
                memoryKey: memoryKey,
                message: WalletRequestReadPrivateKeys(
                    AccessCryptoPrivateKeysRequest(indexes
                        .map((e) => AccessCryptoPrivateKeyRequest(index: e))
                        .toList())),
                masterKey: masterKey);
            credential = WalletCredentialResponseAccountKey(
                credentials: accountKeys, id: verify);
          }
          break;
        default:
          throw WalletExceptionConst.authFailed;
      }
      if (credential == null) {
        throw WalletExceptionConst.authFailed;
      }
      _credentials[verify.id] = verify;
      return WalletInternalCallResponse(result: credential as RESPONSE);
    });
  }

  /// get address public key.
  /// does not work for multisig account.
  /// - [account]: account for retrive public key.
  Future<List<PublicKeyDerivationResult>> _getAccountPubKys(
      {required ChainAccount account}) async {
    final indexes = account.accessKeysIndexes();
    final pubKeys = await _callWalletInternal(
      (WalletInMemoryData masterKey, List<int> memoryKey) async {
        final result = await crypto.walletArgs(
            memoryKey: memoryKey,
            message: WalletRequestReadPublicKeys(AccessCryptoPrivateKeysRequest(
                indexes
                    .map((e) => AccessCryptoPrivateKeyRequest(index: e))
                    .toList())),
            masterKey: masterKey);
        return WalletInternalCallResponse(result: result);
      },
    );
    return List.generate(indexes.length, (i) {
      final index = indexes[i];
      final key = pubKeys[i];
      String? walletName = _wallet.name;
      if (index.subId != null) {
        walletName = _wallet.getSubWallet(index.subId!)?.name;
      }
      return PublicKeyDerivationResult(
          key: pubKeys[i],
          index: index,
          walletName: walletName,
          viewKey: key.toViewKey);
    });
  }

  /// get key index public key.
  Future<PublicKeyDerivationResult> _getKeyDerivationPublicKey(
      AddressDerivationIndex index) async {
    final pubKeys = await _callWalletInternal(
        (WalletInMemoryData masterKey, List<int> memoryKey) async {
      final result = await crypto.walletArgs(
          memoryKey: memoryKey,
          message: WalletRequestReadPublicKeys(AccessCryptoPrivateKeysRequest(
              [AccessCryptoPrivateKeyRequest(index: index)])),
          masterKey: masterKey);
      return WalletInternalCallResponse(result: result);
    });
    String? walletName = _wallet.name;
    if (index.subId != null) {
      walletName = _wallet.getSubWallet(index.subId!)?.name;
    }
    return PublicKeyDerivationResult(
        key: pubKeys.first,
        index: index,
        walletName: walletName,
        viewKey: pubKeys.first.toViewKey);
  }

  /// signing request
  /// -[signers]: the key information for read.
  /// -[request]: callback method for provide message for signing
  Future<T> _signTransaction<T>(
      {required WalletCredentialResponseVerify? credential,
      required Set<AddressDerivationIndex> signers,
      required WalletSigningRequest<T> request,
      Duration? timeout}) async {
    if (_wallet.protectWallet) {
      if (credential == null) {
        throw WalletExceptionConst.authFailed;
      }
      _getCachedCredPassword(credential);
    }
    return await _callWalletInternal(
      (WalletInMemoryData masterKey, List<int> memoryKey) async {
        final sign = await request.sign((request) async {
          if (!signers.contains(request.index)) {
            throw WalletExceptionConst.notAuthorizedSigningAccount;
          }
          final result = await crypto.walletArgs(
              memoryKey: memoryKey,
              message: WalletRequestSign(request),
              masterKey: masterKey,
              timeout: timeout);
          return result;
        });
        return WalletInternalCallResponse(result: sign);
      },
    );
  }

  /// find related imported key for coin
  /// -[derivationCoin]: find related imported key for this coin.
  List<EncryptedCustomKey> _getCustomKeysForCoin(CryptoCoins derivationCoin) {
    final List<EncryptedCustomKey> coins = [];
    final customKeys = _walletKey!.customKeys;
    for (final c in customKeys) {
      if (c.canUseFor(derivationCoin)) {
        coins.add(c);
      }
    }
    return coins.toSet().toImutableList;
  }

  /// get imported keys details
  Future<List<EncryptedCustomKey>> _getImportedAccounts() async {
    return List<EncryptedCustomKey>.from(_walletKey!.customKeys);
  }

  /// update wallet settings. like name, unlock time and security options
  /// -[walletInfos]: updated wallet information
  Future<void> _updateWalletInfos(
      {required WalletUpdateInfosData walletInfos,
      required WalletCredentialResponseVerify credential}) async {
    _getCachedCredPassword(credential);
    final requiredPassword = _wallet.requiredPassword;
    final updatedWallet = _wallet.updateSettings(update: walletInfos);
    await _updateWallet(updatedWallet);
    if (!requiredPassword && _wallet.requiredPassword) {
      _setDefaultPageStatus();
    }
  }

  /// internal wallet request
  /// this method get wallet keys and run the wallet request message.
  Future<T> _walletRequest<T, A extends CborMessageResponseArgs>(
      {required WalletArgsCompleter<T, A> message,
      WalletInMemoryData? masterKey}) async {
    if (masterKey != null) throw UnimplementedError();
    return _callWalletInternal<T>(
      (masterKey, memoryKey) async {
        final result = await crypto.walletArgs<T, A>(
            message: message, masterKey: masterKey, memoryKey: memoryKey);
        return WalletInternalCallResponse<T>(result: result);
      },
    );
    // return await crypto.walletArgs(
    //   message: message,
    //   masterKey: masterKey ?? _walletKey!.masterKey,
    // );
  }

  /// update or import new network to wallet
  /// -[network]: new or updated network
  Future<void> _updateImportNetwork(WalletNetwork network) async {
    await _appChains.updateImportNetwork(network);
  }

  /// remove network from wallet
  /// -[chain]: network for remove
  Future<void> _removeChain(Chain chain) async {
    await _appChains.removeChain(chain);
    await _updateWallet(_appChains.wallet);
  }

  /// update address balance
  /// -[account]: related chain
  /// -[address]: address for retrive and update balance
  Future<void> _updateAddressBalance(
      {required Chain account, required ChainAccount address}) async {
    await account.updateAddressBalance(address);
  }

  /// switch current wallet network
  Future<bool> _switchNetwork(Chain network) async {
    final change = await _appChains.switchNetwork(network);
    if (change) {
      await _updateWallet(_appChains.wallet);
    }
    return change;
  }

  /// internal wallet call, to safty get wallet keys and process
  Future<T> _callWalletInternal<T extends Object?>(
      Future<WalletInternalCallResponse<T>> Function(
              WalletInMemoryData masterKey, List<int> memoryKey)
          t,
      {bool updateWalletData = true}) async {
    final masterKey = _walletKey?.masterKey;
    final memoryKey = await _getMemoryKey();
    if (masterKey == null) {
      throw WalletExceptionConst.walletIsLocked;
    }
    final result = await t(masterKey, memoryKey);
    final key = result.key;
    if (key != null) {
      if (updateWalletData) {
        await _updateWallet(_wallet.updateData(key.storageDataB64()));
      }
      _walletKey = key;
    }
    return result.result;
  }

  /// clear account when removing imported key
  /// retrive all addresses create with current key and remove from wallet.
  /// -[removedKey]: imported key
  Future<void> _cleanUpdateRemovedKeyAccounts(String removedKey) async {
    final chains = _appChains.chains();
    for (final chain in chains) {
      final addresses = await chain.getAccountAddresses();
      for (final address in addresses) {
        final keyIndexes = address.signerKeyIndexes();
        if (keyIndexes.any((e) => e.importedKeyId == removedKey)) {
          await chain.removeAccount(address);
        }
      }
    }
  }

  Future<void> _cleanUpdateRemovedSubWalletAccounts(int subWalletId) async {
    final chains = _appChains.chains();
    for (final chain in chains) {
      final addresses = await chain.getAccountAddresses();
      for (final address in addresses) {
        final keyIndexes = address.signerKeyIndexes();
        if (keyIndexes.any((e) => e.subId == subWalletId)) {
          await chain.removeAccount(address);
        }
      }
    }
  }

  ///

  Future<void> _setupSubWallet(WalletImportSubWalletData subWalletData) async {
    await _callWalletInternal(
      (WalletInMemoryData masterKey, List<int> memoryKey) async {
        final result = await crypto.walletArgs(
            message: WalletRequestImportSubWallet(
                mnemonic: subWalletData.mnemonic,
                passphrase: subWalletData.passphrase,
                type: subWalletData.type),
            masterKey: masterKey,
            memoryKey: memoryKey);
        if (subWalletData.mainWalletId != _wallet.id) {
          throw WalletExceptionConst.incorrectWalletData;
        }
        final updatedWallet = _wallet.addNewSubWallet(
            name: subWalletData.name,
            type: subWalletData.type,
            data: result.masterKey.storageDataB64(),
            subWalletId: result.subWalletId);
        await _updateWallet(updatedWallet);
        return WalletInternalCallResponse(result: null, key: result.masterKey);
      },
    );
  }

  Future<void> _removeSubWallet(
      {required WalletCredentialResponseVerify credential,
      required int subWalletId}) async {
    if (!_credentials.containsKey(credential.id)) {
      throw WalletExceptionConst.authFailed;
    }
    MainWallet updatedWallet = _wallet.removeSubWallet(subWalletId);
    await _cleanUpdateRemovedSubWalletAccounts(subWalletId);
    await _updateWallet(updatedWallet);
    await _callWalletInternal(
      (WalletInMemoryData masterKey, List<int> memoryKey) async {
        final result = await crypto.walletArgs(
            message: WalletRequestRemoveSubWallet(id: subWalletId),
            masterKey: masterKey,
            memoryKey: memoryKey);
        return WalletInternalCallResponse(result: null, key: result);
      },
    );
  }

  /// init the wallet
  Future<void> _onInitController() async {
    _setDefaultPageStatus();
    await _appChains.init();
  }

  /// dispose wallet before switching wallet.
  void _dispose() {}
}
