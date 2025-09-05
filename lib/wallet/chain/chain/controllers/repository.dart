part of 'package:on_chain_wallet/wallet/chain/chain/chain.dart';

mixin ChainRepository<
    ADDRESS extends ChainAccount,
    NETWORK extends WalletNetwork,
    CLIENT extends NetworkClient,
    CONFIG extends DefaultNetworkConfig,
    TOKEN extends TokenCore,
    NFT extends NFTCore,
    TRANSACTION extends ChainTransaction,
    CONTACT extends ContactCore,
    ADDRESSPARAM extends NewAccountParams> {
  Future<CLIENT?> clientOrNull();
  NetworkStorageManager get _storage;
  NETWORK get network;
  ADDRESS _deserializeAddress(List<int> adressBytes);

  Future<List<CONTACT>> _getContacts() async {
    final storagekey = DefaultNetworkStorageId.contacts;
    final data = await _storage.queriesNetworkStorage(storage: storagekey);
    final contacts = data
        .map((e) => ContactCore.deserialize<CONTACT>(network, bytes: e))
        .toList()
        .whereType<CONTACT>()
        .toList();
    appLogger.debug(
        when: () => contacts.isNotEmpty,
        runtime: runtimeType,
        functionName: "_getContacts ${network.networkName}",
        msg: "${contacts.length} contacts founds.");
    assert(
        contacts.length == data.length, "some contact deserialization failed.");
    return contacts;
  }

  Future<void> _saveContact(CONTACT contact) async {
    final storageKey = DefaultNetworkStorageId.contacts;
    await _storage.insertNetworkStorage(
        storage: storageKey, value: contact, keyA: contact.identifier);
  }

  Future<void> _removeContact(CONTACT contact) async {
    final storageKey = DefaultNetworkStorageId.contacts;
    await _storage.removeNetworkStorage(
        storage: storageKey, keyA: contact.identifier);
  }

  Future<List<ADDRESS>> _getAddresses() async {
    final storagekey = DefaultNetworkStorageId.address;
    final data = await _storage.queriesNetworkStorage(storage: storagekey);
    final addresses = data
        .map((e) => _deserializeAddress(e))
        .toList()
        .whereType<ADDRESS>()
        .toList();
    appLogger.debug(
        when: () => addresses.isNotEmpty,
        runtime: runtimeType,
        functionName: "_getAddresses ${network.networkName}",
        msg: "${addresses.length} addresses founds.");
    assert(addresses.length == data.length,
        "some contact deserialization failed.");
    return addresses.toImutableList;
  }

  Future<bool> _saveAddresses(List<ADDRESS> addresses) async {
    return _storage.insertNetworkAddresses(
        addresses: addresses, storage: DefaultNetworkStorageId.address);
  }
}
