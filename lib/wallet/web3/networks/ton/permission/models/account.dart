import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:on_chain_wallet/app/core.dart';
import 'package:on_chain_wallet/app/serialization/cbor/cbor.dart';
import 'package:on_chain_wallet/crypto/types/networks.dart';
import 'package:on_chain_wallet/wallet/constant/tags/constant.dart';
import 'package:on_chain_wallet/wallet/chain/account.dart';
import 'package:on_chain_wallet/wallet/models/networks/ton/models/account_context.dart';
import 'package:on_chain_wallet/wallet/web3/core/permission/types/account.dart';
import 'package:ton_dart/ton_dart.dart';
import 'package:on_chain_wallet/crypto/keys/access/crypto_keys/crypto_keys.dart';

class Web3TonChainAccount extends Web3ChainAccount<TonAddress> {
  @override
  final int id;
  final TonAccountContext accountContext;
  final List<int> publicKey;
  final TonChainId network;

  Web3TonChainAccount._(
      {required super.keyIndex,
      required super.address,
      required super.defaultAddress,
      required this.id,
      required List<int> publicKey,
      required this.accountContext,
      required this.network,
      required super.identifier})
      : publicKey = publicKey.asImmutableBytes;
  @override
  Web3TonChainAccount clone(
      {AddressDerivationIndex? keyIndex,
      TonAddress? address,
      bool? defaultAddress,
      int? id,
      List<int>? publicKey,
      TonChainId? network,
      TonAccountContext? accountContext,
      String? identifier}) {
    return Web3TonChainAccount._(
        keyIndex: keyIndex ?? this.keyIndex,
        address: address ?? this.address,
        defaultAddress: defaultAddress ?? this.defaultAddress,
        id: id ?? this.id,
        publicKey: publicKey ?? this.publicKey,
        network: network ?? this.network,
        accountContext: accountContext ?? this.accountContext,
        identifier: identifier ?? this.identifier);
  }

  factory Web3TonChainAccount.fromChainAccount(
      {required ITonAddress address,
      required int id,
      required bool isDefault,
      required TonChainId network}) {
    return Web3TonChainAccount._(
        keyIndex: address.keyIndex,
        address: address.networkAddress,
        id: id,
        defaultAddress: isDefault,
        accountContext: address.context,
        publicKey: address.publicKey,
        network: network,
        identifier: address.identifier);
  }

  factory Web3TonChainAccount.deserialize(
      {List<int>? bytes, CborObject? object, String? hex}) {
    final CborListValue values = CborSerializable.cborTagValue(
        object: object,
        cborBytes: bytes,
        hex: hex,
        tags: CborTagsConst.web3TonAccount);
    return Web3TonChainAccount._(
        keyIndex: AddressDerivationIndex.deserialize(
            obj: values.indexAs<CborTagValue>(0)),
        address: TonAddress(values.valueAs(1)),
        id: values.valueAs(2),
        defaultAddress: values.valueAs(3),
        accountContext: TonAccountContext.deserialize(
            object: values.indexAs<CborTagValue>(4)),
        publicKey: values.valueAs(5),
        network: TonChainId.fromWorkchain(values.valueAs(6)),
        identifier: values.valueAs(7));
  }
  VersionedWalletContract toWalletContract(TonChainId chain) {
    return accountContext.toWalletContract(publicKey: publicKey, chain: chain);
  }

  @override
  CborTagValue toCbor() {
    return CborTagValue(
        CborSerializable.fromDynamic([
          keyIndex.toCbor(),
          address.toFriendlyAddress(),
          id,
          defaultAddress,
          accountContext.toCbor(),
          CborBytesValue(publicKey),
          network.workchain,
          identifier
        ]),
        CborTagsConst.web3TonAccount);
  }

  @override
  String get addressStr => address.toFriendlyAddress();

  List<int> get accountState =>
      toWalletContract(network).state!.initialState().serialize().toBoc();
}

class Web3TonChainAuthenticated
    extends Web3ChainAuthenticated<Web3TonChainAccount> {
  @override
  final List<Web3ChainDefaultIdnetifier> networks;
  @override
  final Web3ChainDefaultIdnetifier currentNetwork;
  Web3TonChainAuthenticated({
    required super.accounts,
    required this.currentNetwork,
    required List<Web3ChainDefaultIdnetifier> networks,
  })  : networks = networks.immutable,
        super(networkType: NetworkType.ton);

  factory Web3TonChainAuthenticated.deserialize(
      {List<int>? bytes, CborObject? object, String? hex}) {
    final CborListValue values = CborSerializable.cborTagValue(
        object: object, cborBytes: bytes, hex: hex, tags: NetworkType.ton.tag);
    return Web3TonChainAuthenticated(
      accounts: values
          .elementAsListOf<CborTagValue>(0)
          .map((e) => Web3TonChainAccount.deserialize(object: e))
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
