import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:monero_dart/monero_dart.dart';
import 'package:on_chain_wallet/app/serialization/cbor/cbor.dart';
import 'package:on_chain_wallet/crypto/types/networks.dart';
import 'package:on_chain_wallet/wallet/constant/tags/constant.dart';
import 'package:on_chain_wallet/wallet/chain/account.dart';
import 'package:on_chain_wallet/wallet/web3/core/permission/types/account.dart';
import 'package:on_chain_wallet/crypto/keys/access/crypto_keys/crypto_keys.dart';

class Web3MoneroChainAccount extends Web3ChainAccount<MoneroAddress> {
  @override
  final int id;
  final List<int>? publicKey;
  Web3MoneroChainAccount(
      {required super.keyIndex,
      required super.address,
      required super.defaultAddress,
      required this.id,
      required super.identifier,
      this.publicKey});
  @override
  Web3MoneroChainAccount clone(
      {AddressDerivationIndex? keyIndex,
      MoneroAddress? address,
      bool? defaultAddress,
      int? id,
      List<int>? publicKey,
      String? identifier}) {
    return Web3MoneroChainAccount(
        keyIndex: keyIndex ?? this.keyIndex,
        address: address ?? this.address,
        defaultAddress: defaultAddress ?? this.defaultAddress,
        id: id ?? this.id,
        publicKey: publicKey ?? this.publicKey,
        identifier: identifier ?? this.identifier);
  }

  factory Web3MoneroChainAccount.fromChainAccount(
      {required IMoneroAddress address,
      required int id,
      required bool isDefault}) {
    return Web3MoneroChainAccount(
        keyIndex: address.keyIndex,
        address: address.networkAddress,
        id: id,
        defaultAddress: isDefault,
        identifier: address.identifier,
        publicKey: address.addrDetails.isPrimary
            ? address.networkAddress.pubSpendKey
            : null);
  }

  factory Web3MoneroChainAccount.deserialize(
      {List<int>? bytes, CborObject? object, String? hex}) {
    final CborListValue values = CborSerializable.cborTagValue(
        object: object,
        cborBytes: bytes,
        hex: hex,
        tags: CborTagsConst.web3MoneroAccount);
    return Web3MoneroChainAccount(
        keyIndex: AddressDerivationIndex.deserialize(
            obj: values.indexAs<CborTagValue>(0)),
        address: MoneroAddress(values.valueAs(1)),
        id: values.valueAs(2),
        defaultAddress: values.valueAs(3),
        publicKey: values.valueAs(4),
        identifier: values.valueAs(5));
  }

  @override
  CborTagValue toCbor() {
    return CborTagValue(
        CborSerializable.fromDynamic([
          keyIndex.toCbor(),
          address.address,
          id,
          defaultAddress,
          publicKey,
          identifier
        ]),
        CborTagsConst.web3MoneroAccount);
  }

  @override
  String get addressStr => address.address;
}

class Web3MoneroChainIdnetifier extends Web3ChainIdnetifier {
  final MoneroNetwork network;

  Web3MoneroChainIdnetifier(
      {required this.network,
      required super.wsIdentifier,
      required super.caip2,
      required super.id});
  factory Web3MoneroChainIdnetifier.deserialize(
      {List<int>? bytes, CborObject? object, String? hex}) {
    final CborListValue values = CborSerializable.cborTagValue(
        object: object,
        cborBytes: bytes,
        hex: hex,
        tags: CborTagsConst.web3MoneroChainIdentifier);
    return Web3MoneroChainIdnetifier(
        network: MoneroNetwork.fromIndex(values.elementAs(0)),
        id: values.elementAs(1),
        wsIdentifier: values.elementAs(2),
        caip2: values.elementAs(3));
  }
  @override
  CborTagValue toCbor() {
    return CborTagValue(
      CborSerializable.fromDynamic([network.index, id, wsIdentifier, caip2]),
      CborTagsConst.web3MoneroChainIdentifier,
    );
  }
}

class Web3MoneroChainAuthenticated
    extends Web3ChainAuthenticated<Web3MoneroChainAccount> {
  @override
  final List<Web3MoneroChainIdnetifier> networks;
  @override
  final Web3MoneroChainIdnetifier currentNetwork;
  Web3MoneroChainAuthenticated({
    required super.accounts,
    required this.currentNetwork,
    required List<Web3MoneroChainIdnetifier> networks,
  })  : networks = networks.immutable,
        super(networkType: NetworkType.monero);

  factory Web3MoneroChainAuthenticated.deserialize(
      {List<int>? bytes, CborObject? object, String? hex}) {
    final CborListValue values = CborSerializable.cborTagValue(
        object: object,
        cborBytes: bytes,
        hex: hex,
        tags: NetworkType.monero.tag);
    return Web3MoneroChainAuthenticated(
      accounts: values
          .elementAsListOf<CborTagValue>(0)
          .map((e) => Web3MoneroChainAccount.deserialize(object: e))
          .toList(),
      networks: values
          .elementAsListOf<CborTagValue>(1)
          .map((e) => Web3MoneroChainIdnetifier.deserialize(object: e))
          .toList(),
      currentNetwork: Web3MoneroChainIdnetifier.deserialize(
          object: values.elementAs<CborTagValue>(2)),
    );
  }
}
