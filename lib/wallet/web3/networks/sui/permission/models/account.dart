import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:on_chain_wallet/app/serialization/cbor/cbor.dart';
import 'package:on_chain_wallet/crypto/types/networks.dart';
import 'package:on_chain_wallet/wallet/constant/tags/constant.dart';
import 'package:on_chain_wallet/wallet/chain/account.dart';
import 'package:on_chain_wallet/wallet/models/network/params/sui.dart'
    show SuiChainType;
import 'package:on_chain_wallet/wallet/web3/core/permission/types/account.dart';
import 'package:on_chain/sui/src/address/address/address.dart';
import 'package:on_chain_wallet/crypto/keys/access/crypto_keys/crypto_keys.dart';

class Web3SuiChainAccount extends Web3ChainAccount<SuiAddress> {
  @override
  final int id;
  final List<int> publicKey;
  final int signingScheme;
  // final SuiChainType network;
  @override
  Web3SuiChainAccount clone(
      {AddressDerivationIndex? keyIndex,
      SuiAddress? address,
      bool? defaultAddress,
      int? id,
      List<int>? publicKey,
      int? signingScheme,
      String? identifier}) {
    return Web3SuiChainAccount(
        keyIndex: keyIndex ?? this.keyIndex,
        address: address ?? this.address,
        defaultAddress: defaultAddress ?? this.defaultAddress,
        id: id ?? this.id,
        publicKey: publicKey ?? this.publicKey,
        signingScheme: signingScheme ?? this.signingScheme,
        identifier: identifier ?? this.identifier);
  }

  Web3SuiChainAccount(
      {required super.keyIndex,
      required super.address,
      required super.defaultAddress,
      required this.id,
      required this.signingScheme,
      required super.identifier,
      required List<int> publicKey})
      : publicKey = publicKey.asImmutableBytes;
  factory Web3SuiChainAccount.fromChainAccount(
      {required ISuiAddress address,
      required int id,
      required bool isDefault,
      required SuiChainType network}) {
    return Web3SuiChainAccount(
        keyIndex: address.keyIndex,
        address: address.networkAddress,
        id: id,
        defaultAddress: isDefault,
        publicKey: address.toSuiPublicKey().toVariantBcs(),
        signingScheme: address.keyScheme.value,
        identifier: address.identifier);
  }

  factory Web3SuiChainAccount.deserialize(
      {List<int>? bytes, CborObject? object, String? hex}) {
    final CborListValue values = CborSerializable.cborTagValue(
        object: object,
        cborBytes: bytes,
        hex: hex,
        tags: CborTagsConst.web3SuiAccount);
    return Web3SuiChainAccount(
        keyIndex: AddressDerivationIndex.deserialize(
            obj: values.indexAs<CborTagValue>(0)),
        address: SuiAddress(values.valueAs(1)),
        id: values.valueAs(2),
        defaultAddress: values.valueAs(3),
        publicKey: values.valueAs(4),
        signingScheme: values.valueAs(5),
        identifier: values.valueAs(6));
  }

  @override
  CborTagValue toCbor() {
    return CborTagValue(
        CborSerializable.fromDynamic([
          keyIndex.toCbor(),
          address.address,
          id,
          defaultAddress,
          CborBytesValue(publicKey),
          signingScheme,
          identifier
        ]),
        CborTagsConst.web3SuiAccount);
  }

  @override
  String get addressStr => address.address;
}

class Web3SuiChainAuthenticated
    extends Web3ChainAuthenticated<Web3SuiChainAccount> {
  @override
  final List<Web3ChainDefaultIdnetifier> networks;
  @override
  final Web3ChainDefaultIdnetifier currentNetwork;
  Web3SuiChainAuthenticated({
    required super.accounts,
    required this.currentNetwork,
    required List<Web3ChainDefaultIdnetifier> networks,
  })  : networks = networks.immutable,
        super(networkType: NetworkType.sui);

  factory Web3SuiChainAuthenticated.deserialize(
      {List<int>? bytes, CborObject? object, String? hex}) {
    final CborListValue values = CborSerializable.cborTagValue(
        object: object, cborBytes: bytes, hex: hex, tags: NetworkType.sui.tag);
    return Web3SuiChainAuthenticated(
      accounts: values
          .elementAsListOf<CborTagValue>(0)
          .map((e) => Web3SuiChainAccount.deserialize(object: e))
          .toList(),
      networks: values
          .elementAsListOf<CborTagValue>(1)
          .map((e) => Web3ChainDefaultIdnetifier.deserialize(object: e))
          .toList(),
      currentNetwork: Web3ChainDefaultIdnetifier.deserialize(
          object: values.elementAs<CborTagValue>(2)),
    );
  }
}
