part of 'package:on_chain_wallet/wallet/models/chain/chain/chain.dart';

base mixin BaseChainController<
        PROVIDER extends APIProvider,
        NETWORKPARAMS extends NetworkCoinParams,
        NETWORKADDRESS,
        TOKEN extends TokenCore,
        NFT extends NFTCore,
        ADDRESS extends ChainAccount,
        NETWORK extends WalletNetwork,
        CLIENT extends NetworkClient,
        CONFIG extends DefaultNetworkConfig,
        TRANSACTION extends ChainTransaction,
        CONTACT extends ContactCore,
        ADDRESSPARAM extends NewAccountParams>
    on
        BaseChain<PROVIDER, NETWORKPARAMS, NETWORKADDRESS, TOKEN, NFT, ADDRESS,
            NETWORK, CLIENT, CONFIG, TRANSACTION, CONTACT, ADDRESSPARAM>,
        ChainRepository<ADDRESS, NETWORK, CLIENT, CONFIG, TOKEN, NFT,
            TRANSACTION, CONTACT, ADDRESSPARAM> {
  StreamSubscription<void>? txSub;
  bool _isOnline = true;
  int _currentWalletChainId = -1;
  bool get _isCurrentWalletChain => _currentWalletChainId == network.value;
  bool get isCurrentWalletChain => _isCurrentWalletChain;
  late final List<String> _services = ChainConst.services(network);
  final CachedObject<void> _onUpdateAccountBalance =
      CachedObject<void>(interval: const Duration(minutes: 10));

  @override
  List<String> get services => _services;
  Future<void> _onWalletPing() async {
    if (!haveAddress) return;

    await _onUpdateAccountBalance.get(onFetch: () async {
      await init(client: false);
      await updateAccountBalance();
      _trackTxes();
    });
  }

  Future<void> _onConnectionStatusChange(bool isOnline) async {
    _isOnline = isOnline;
    if (!isOnline) {
      txSub?.cancel();
      txSub = null;
    }
  }

  Future<void> _onWalletChainChanged(ChainWalletChainChangeEvent evnet) async {
    if (evnet.current.network.value == network.value) {
      _onWalletPing();
    }
  }

  Future<void> _onWalletEvent(ChainWalletEvent event) async {
    switch (event.type) {
      case ChainWalletEventType.ping:
        await _onWalletPing();
        break;
      case ChainWalletEventType.connection:
        _isOnline = event.cast<ChainWalletConnectionEvent>().isOnline;
        await _onConnectionStatusChange(_isOnline);
        break;
      case ChainWalletEventType.chainChanged:
        final changed = event.cast<ChainWalletChainChangeEvent>();
        _currentWalletChainId = changed.current.network.value;
        await _onWalletChainChanged(changed);
        break;
    }
  }

  void _isAccountAddress(ADDRESS address) {
    if (!addresses.contains(address)) {
      throw WalletExceptionConst.accountDoesNotFound;
    }
  }

  Future<T> _callSynchronized<T>({
    required Future<T> Function() t,
    DefaultChainNotify? type,
    _WalletChainStatus? allowStatus = _WalletChainStatus.ready,
    bool saveAccount = false,
    bool notifyProgress = false,
    bool notifyComplete = true,
    bool wait = false,
    int lockId = 0,
  }) async {
    return await _lock.synchronized(() async {
      if (allowStatus != null && allowStatus != _status) {
        throw WalletExceptionConst.invalidChainState;
      }
      if (notifyProgress && type != null) {
        _controller.add(ChainEvent.progress(type));
        if (wait) await Future.delayed(Duration(milliseconds: 600));
      }
      try {
        final r = await t();
        if (saveAccount) await _saveAccount();
        return r;
      } finally {
        if (notifyComplete && type != null) {
          appLogger.debug(
              runtime: runtimeType,
              functionName: "_callSynchronized",
              msg: "notify $type");
          _controller.add(ChainEvent.complete(type));
        }
      }
    }, lockId: LockId.two);
  }

  Future<void> updateConfig(CONFIG status) async {
    await _callSynchronized(
        t: () async {
          _config = status;
        },
        type: DefaultChainNotify.config,
        saveAccount: true);
  }

  AddressDerivationIndex nextDerive(
      CryptoCoins coin, SeedTypes seedGeneration) {
    return BipDerivationUtils.generateAccountNextKeyIndex(
        coin: coin,
        addresses: addresses,
        seedGenerationType: seedGeneration,
        coinType: network.coinParam.bip32CoinType);
  }

  Future<ADDRESS> addNewAddress(
      CryptoPublicKeyData? publicKey, ADDRESSPARAM accountParams) async {
    return _callSynchronized(
        t: () async {
          if (!network.coins.contains(accountParams.coin)) {
            throw WalletExceptionConst.invalidCoin;
          }
          final ADDRESS newAddress =
              accountParams.toAccount(network, publicKey).cast();
          final any = addresses
              .any((element) => element.identifier == newAddress.identifier);
          if (any) {
            throw WalletExceptionConst.addressAlreadyExist;
          }
          _addresses = List.unmodifiable([..._addresses, newAddress]);
          updateAddressBalance(newAddress);
          return newAddress;
        },
        type: DefaultChainNotify.address,
        saveAccount: true,
        notifyProgress: _addresses.isEmpty);
  }

  ADDRESS? getAddress(String address) {
    return _addresses
        .firstWhereOrNull((element) => element.viewAddress == address);
  }

  CONTACT? getContact(String address) {
    return _contacts.firstWhereOrNull((element) {
      return element.address == address;
    });
  }

  ReceiptAddress<NETWORKADDRESS>? getReceiptAddress(String address) {
    final isAccount = getAddress(address);
    final contact = getContact(address);
    if (isAccount != null) {
      return ReceiptAddress<NETWORKADDRESS>(
          account: isAccount as NETWORKCHAINACCOUNT<NETWORKADDRESS>,
          view: isAccount.address.toAddress,
          type: isAccount.type,
          networkAddress: isAccount.networkAddress,
          contact: contact as ContactCore<NETWORKADDRESS>?);
    }

    if (contact != null) {
      return ReceiptAddress<NETWORKADDRESS>(
          contact: contact as ContactCore<NETWORKADDRESS>,
          view: contact.address,
          type: contact.type,
          networkAddress: contact.addressObject);
    }
    return null;
  }

  static BigInt _totalBalance(List<ChainAccount> addresses) {
    final Map<String, BigInt> total = {
      for (final i in addresses) i.baseAddress: i.address.currencyBalance
    };
    return total.values
        .fold(BigInt.zero, (previousValue, element) => previousValue + element);
  }

  void _refreshTotalBalance() {
    final totalBalances = _totalBalance(addresses);
    totalBalance.value._internalUpdateBalance(totalBalances);
  }

  List<TOKEN> tokens() {
    return addresses.map((e) => e.tokens).expand((e) => e).toList().cast();
  }

  Future<CLIENT> client() async {
    final cl = _client;
    if (cl == null) {
      throw WalletException("no_acitve_provider");
    }
    if (_clientStatus.isConnect) return cl;
    final init = await _callSynchronized(
        allowStatus: null,
        notifyProgress: true,
        t: () async {
          if (_clientStatus.isConnect) return true;
          _clientStatus = NodeClientStatus.pending;
          final init = await cl.init();
          if (init) {
            _clientStatus = NodeClientStatus.connect;
          } else {
            _clientStatus = NodeClientStatus.disconnect;
          }
          return init;
        },
        type: DefaultChainNotify.client,
        lockId: 1);
    if (!init) {
      throw WalletException("node_connection_error");
    }
    return cl;
  }

  @override
  Future<CLIENT?> clientOrNull() async {
    try {
      final client = await this.client();
      return client;
    } catch (e) {
      return null;
    }
  }

  Future<T> onClient<T extends Object?>({
    required Future<T> Function(CLIENT client) onConnect,
    Future<T> Function(Object err)? onError,
  }) async {
    try {
      final client = await this.client();
      return await onConnect(client);
    } catch (e, s) {
      appLogger.error(
          runtime: runtimeType, functionName: "onClient", msg: e, trace: s);
      return onError?.call(e) as T;
    }
  }

  Future<void> removeContact(CONTACT contact) async {
    await _callSynchronized(
        t: () async {
          final findContact = getContact(contact.address);
          if (findContact == null) return;
          final newContacts =
              _contacts.where((element) => element != findContact).toList();
          _contacts = List.unmodifiable(newContacts);
          await _removeContact(contact);
        },
        type: DefaultChainNotify.contacts);
  }

  Future<void> switchAccount(ADDRESS address) async {
    _isAccountAddress(address);
    await _callSynchronized(
        t: () async {
          final index = addresses.indexOf(address);
          if (index < 0 || index == _addressIndex) return;
          _addressIndex = index;
          await _initAddress(address);
          updateAddressBalance(address);
        },
        saveAccount: true,
        notifyProgress: true,
        wait: true,
        type: DefaultChainNotify.address);
  }

  Future<bool> removeAccount(ADDRESS address) async {
    _isAccountAddress(address);
    return _callSynchronized(
        notifyProgress: true,
        wait: true,
        t: () async {
          if (!haveAddress || !addresses.contains(address)) {
            return false;
          }
          await _cleanAddressRepositories(address: address);
          final currentAddress = this.address;
          final currentAccounts = List<ADDRESS>.from(_addresses);
          currentAccounts.remove(address);
          _addresses = currentAccounts;
          _addressIndex = _addresses.indexOf(currentAddress);
          if (_addressIndex < 0) {
            _addressIndex = 0;
          }

          _refreshTotalBalance();
          await _initAddress(_addresses.elementAtOrNull(_addressIndex));
          return true;
        },
        type: DefaultChainNotify.address,
        saveAccount: true);
  }

  Future<void> setProvider(ProviderIdentifier service,
      {Duration? requestTimeout}) async {
    if (service.network != network.type) return;
    await _callSynchronized(
        notifyProgress: true,
        t: () async {
          final currentProvider = _client;
          _client = APIUtils.createApiClient<CLIENT>(network,
              identifier: service, requestTimeut: requestTimeout);
          currentProvider?.service.disposeService();
          _clientStatus = NodeClientStatus.disconnect;
          clientOrNull();
        },
        type: DefaultChainNotify.client,
        saveAccount: true);
  }

  CLIENT? getWeb3Provider(
      {ProviderIdentifier? service, Duration? requestTimeout}) {
    final cl = _client;
    if (cl?.service.provider.allowInWeb3 ?? false) return cl;
    return APIUtils.createApiClient<CLIENT>(network,
        identifier: service,
        requestTimeut: requestTimeout,
        allowInWeb3: true,
        isolate: APPIsolate.current);
  }

  Future<void> _saveAccount() async {
    await _storage.saveAccount(this as Chain);
  }

  Future<void> _removeAccount() async {
    await _storage.removeAccount(this as Chain);
  }

  Future<void> removeNFT({required NFT nft, required ADDRESS address}) async {
    _isAccountAddress(address);
    return _callSynchronized(
        t: () async {
          /// before remove the asset must be exsits in asset list
          await _removeNFT(address: address, nft: nft);
          address._removeNFT(nft);
        },
        type: DefaultChainNotify.nft,
        saveAccount: false);
  }

  Future<void> addNewNFT({required NFT nft, required ADDRESS address}) async {
    _isAccountAddress(address);
    return _callSynchronized(
        t: () async {
          /// before save the asset must be exsits in asset list
          address._addNFT(nft);
          await _saveNFT(address: address, nft: nft);
        },
        type: DefaultChainNotify.nft,
        saveAccount: false);
  }

  /// set or update address name.
  /// -[name]: for update or remove if null.
  /// -[address]: address for updating name.
  Future<void> setupAccountName(
      {String? name, required ADDRESS address}) async {
    _isAccountAddress(address);
    return _callSynchronized(
        t: () async {
          if (name == null || !APPConst.accountNameRegExp.hasMatch(name)) {
            return;
          }
          if (!addresses.contains(address)) {
            return;
          }
          address._setAccountName(name);
        },
        type: DefaultChainNotify.address,
        saveAccount: true);
  }

  Future<void> addNewContact(CONTACT newContact) async {
    return _callSynchronized(
        wait: true,
        t: () async {
          if (contacts.contains(newContact) ||
              contacts.any((e) => e.name == newContact.name)) {
            throw WalletExceptionConst.contactExists;
          }
          if (newContact.name.length < 3) {
            throw WalletExceptionConst.invalidContactDetails;
          }

          _contacts = List.unmodifiable([newContact, ..._contacts]);
          await _saveContact(newContact);
        },
        type: DefaultChainNotify.contacts,
        saveAccount: false);
  }

  /// add new token to address
  /// -[address]: address for importing token
  Future<void> addNewToken(
      {required TOKEN token, required ADDRESS address}) async {
    _isAccountAddress(address);

    /// before save the token must be exsits in token list
    return _callSynchronized(
        t: () async {
          final newToken = address._addToken(token);
          await _saveToken(address: address, token: token);
          updateTokenBalance(address: address, tokens: [newToken as TOKEN]);
        },
        type: DefaultChainNotify.token,
        saveAccount: false);
  }

  /// remove token from address
  /// -[token]: token for remove
  /// -[address]: owner address of token
  Future<void> removeToken(
      {required TOKEN token, required ADDRESS address}) async {
    _isAccountAddress(address);

    /// before remove the asset must be exsits in asset list
    return _callSynchronized(
        t: () async {
          await _removeToken(address: address, token: token);
          address._removeToken(token);
        },
        type: DefaultChainNotify.token,
        saveAccount: false);
  }

  /// update address token information like name, decimal and etc ...
  /// -[updatedToken]: updated token
  /// -[token]: token form update
  /// -[address]: owner address of token
  Future<void> updateToken(
      {required TOKEN token,
      required ADDRESS address,
      required Token updatedToken}) async {
    _isAccountAddress(address);
    return _callSynchronized(
        wait: true,
        t: () async {
          /// before save the asset must be exsits in asset list
          final newToken = address._updateToken(updatedToken, token) as TOKEN?;
          if (newToken != null) {
            await _saveToken(address: address, token: newToken);
          }
        },
        type: DefaultChainNotify.token,
        saveAccount: false);
  }

  Future<void> _trackTxes() async {
    await onClient(onConnect: (client) async {
      _callSynchronized(t: () async {
        if (txSub != null) return;
        final List<TrackTransactionRequest<TRANSACTION, ADDRESS>> unCofirmTxes =
            [];
        for (final i in addresses) {
          if (!i._transaction.havePendingTxes) continue;
          final pendingTxes =
              i._transaction.pendingTxes.whereType<TRANSACTION>().toList();
          final txes = TrackTransactionRequest<TRANSACTION, ADDRESS>(
              transactions: pendingTxes, account: i);
          unCofirmTxes.add(txes);
        }
        appLogger.debug(
            when: () => unCofirmTxes.isNotEmpty,
            runtime: runtimeType,
            functionName: "_trackTxes ${network.networkName}",
            msg: "${unCofirmTxes.length} pending txes founds.");
        if (unCofirmTxes.isEmpty) {
          return;
        }
        txSub = client
            .trackMempoolTransaction(
                unCofirmTxes.expand((e) => e.transactions).toList())
            .listen((tx) async {
          final address = unCofirmTxes
              .firstWhere((e) => e.transactions.contains(tx))
              .account;
          await _saveTransaction(address: address, transaction: tx);
          await _callSynchronized(
              type: DefaultChainNotify.transaction,
              t: () async {
                address._addTx(tx);
                updateAddressBalance(address);
              });
        }, onDone: () {
          txSub = null;
        });
      });
    });
  }

  Future<void> saveTransaction(
      {required ADDRESS address, required TRANSACTION transaction}) async {
    await _callSynchronized(
        type: DefaultChainNotify.transaction,
        t: () async {
          await _saveTransaction(address: address, transaction: transaction);
          address._addTx(transaction);
          _trackTxes();
        });
  }

  Future<void> removeTransaction(
      {required ADDRESS address, required TRANSACTION transaction}) async {
    _isAccountAddress(address);
    await _callSynchronized(
      type: DefaultChainNotify.transaction,
      t: () async {
        await _removeTransaction(address: address, transaction: transaction);
        address._removeTx(transaction);
      },
    );
  }

  /// update address balance
  /// -[address]: address for retrive and update balance
  Future<void> updateAddressBalance(ADDRESS address,
      {bool tokens = true}) async {
    _isAccountAddress(address);
    await _updateAddressBalanceInternal(address, tokens: tokens);
    _refreshTotalBalance();
    await _saveAccount();
  }

  Future<void> _updateAddressBalanceInternal(ADDRESS address,
      {bool tokens = true});

  Future<void> updateTokenBalance(
      {required ADDRESS address, required List<TOKEN> tokens});

  Future<void> _updateTokenBalanceInternal(
      {required ADDRESS address,
      required TOKEN token,
      required bool save}) async {
    final addressToken = address.tokens.firstWhereNullable((e) => e == token);
    if (addressToken == null) return;
    if (!identical(token, addressToken)) {
      save = addressToken.streamBalance.value
          ._internalUpdateBalance(token.streamBalance.value.balance);
    }
    if (save) await _saveToken(address: address, token: token);
  }

  Future<void> updateAccountBalance(
      {List<ADDRESS>? addresses, bool tokens = true}) async {
    addresses ??= _addresses;
    if (addresses.isEmpty) return;
    await Future.wait(addresses.map((e) async {
      return updateAddressBalance(e, tokens: tokens);
    }));
    _refreshTotalBalance();
    await _saveAccount();
  }

  Future<void> _initAddress(ADDRESS? address) async {
    if (address == null || !address._status.isInit) return;
    _isAccountAddress(address);
    final tokens = await _getTokens(address);
    final nfts = await _getNfts(address);
    final transactions = await _getTransactions(address);
    await address._init(nfts: nfts, tokens: tokens, transactions: transactions);
  }

  Future<void> _initInternal({bool client = true}) async {
    _contacts = (await _getContacts()).toImutableList;
    await _initAddress(_addresses.elementAtOrNull(_addressIndex));
    _status = _WalletChainStatus.ready;
    if (client) clientOrNull();
  }

  Future<void> init({bool client = true}) async {
    if (!_status.isInit) return;
    try {
      await _callSynchronized(
          allowStatus: _WalletChainStatus.init,
          t: () async {
            await _initInternal(client: client);
          },
          type: DefaultChainNotify.address);
    } catch (e) {
      if (e == WalletExceptionConst.invalidChainState) return;
      rethrow;
    }
  }

  void _disposeInternal() {
    _callSynchronized(
        t: () async {
          _status = _WalletChainStatus.dispose;
          _storage.dispose();
          _controller.close();
          _client?.service.disposeService();
          txSub?.cancel();
          txSub = null;
        },
        allowStatus: null);
  }

  Future<void> dispose() async {
    _client?.service.disposeService();
  }

  @override
  CborTagValue toCbor() {
    return CborTagValue(
        CborSerializable.fromDynamic([
          network.value,
          network.toCbor(),
          id,
          CborSerializable.fromDynamic(
              addresses.map((e) => e.toCbor()).toList()),
          _addressIndex,
          config.toCbor(),
          _client?.serviceIdentifier.toCbor()
        ]),
        CborTagsConst.iAccount);
  }
}
