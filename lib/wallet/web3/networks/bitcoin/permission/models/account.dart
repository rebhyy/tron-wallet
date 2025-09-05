import 'package:bitcoin_base/bitcoin_base.dart';
import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:on_chain_wallet/app/core.dart';
import 'package:on_chain_wallet/app/serialization/cbor/cbor.dart';
import 'package:on_chain_wallet/crypto/types/networks.dart';
import 'package:on_chain_wallet/wallet/constant/tags/constant.dart';
import 'package:on_chain_wallet/wallet/chain/account.dart';
import 'package:on_chain_wallet/wallet/models/network/core/network/network.dart';
import 'package:on_chain_wallet/wallet/web3/core/permission/types/account.dart';
import 'package:on_chain_wallet/crypto/keys/access/crypto_keys/crypto_keys.dart';

class Web3BitcoinChainAccount extends Web3ChainAccount<BitcoinBaseAddress> {
  @override
  final int id;
  final BitcoinAddressType type;
  final String addressProgram;
  final BasedUtxoNetwork baseNetwork;
  final List<int> publicKey;
  final String? witnessScript;
  final String? redeemScript;

  Web3BitcoinChainAccount(
      {required super.keyIndex,
      required super.address,
      required super.defaultAddress,
      required super.identifier,
      required this.id,
      required this.addressProgram,
      required this.type,
      required this.baseNetwork,
      required this.witnessScript,
      required this.redeemScript,
      required List<int> publicKey})
      : publicKey = publicKey.asImmutableBytes;

  @override
  Web3BitcoinChainAccount clone(
      {AddressDerivationIndex? keyIndex,
      BitcoinBaseAddress? address,
      bool? defaultAddress,
      int? id,
      int? signingScheme,
      String? witnessScript,
      String? redeemScript,
      BasedUtxoNetwork? baseNetwork,
      String? addressProgram,
      List<int>? publicKey,
      BitcoinAddressType? type,
      String? identifier}) {
    return Web3BitcoinChainAccount(
        keyIndex: keyIndex ?? this.keyIndex,
        address: address ?? this.address,
        defaultAddress: defaultAddress ?? this.defaultAddress,
        id: id ?? this.id,
        baseNetwork: baseNetwork ?? this.baseNetwork,
        publicKey: publicKey ?? this.publicKey,
        witnessScript: witnessScript ?? this.witnessScript,
        redeemScript: redeemScript ?? this.redeemScript,
        addressProgram: addressProgram ?? this.addressProgram,
        type: type ?? this.type,
        identifier: identifier ?? this.identifier);
  }

  factory Web3BitcoinChainAccount.fromChainAccount(
      {required IBitcoinAddress address,
      required bool isDefault,
      required WalletBitcoinNetwork network}) {
    return Web3BitcoinChainAccount(
        keyIndex: address.keyIndex,
        address: address.networkAddress,
        id: network.value,
        defaultAddress: isDefault,
        type: address.networkAddress.type,
        addressProgram: address.networkAddress.addressProgram,
        baseNetwork: network.coinParam.transacationNetwork,
        publicKey: address.multiSigAccount ? [] : address.publicKey,
        witnessScript: address.witnessScript()?.toHex(),
        redeemScript: address.redeemScript()?.toHex(),
        identifier: address.identifier);
  }

  factory Web3BitcoinChainAccount.deserialize(
      {List<int>? bytes, CborObject? object, String? hex}) {
    final CborListValue values = CborSerializable.cborTagValue(
        object: object,
        cborBytes: bytes,
        hex: hex,
        tags: CborTagsConst.web3BitcoinAccount);
    final type = BitcoinAddressType.fromValue(values.valueAs(4));
    final String program = values.valueAs(1);
    return Web3BitcoinChainAccount(
        keyIndex: AddressDerivationIndex.deserialize(
            obj: values.indexAs<CborTagValue>(0)),
        addressProgram: program,
        type: type,
        address:
            BitcoinBaseAddress.fromProgram(addressProgram: program, type: type),
        id: values.valueAs(2),
        defaultAddress: values.valueAs(3),
        baseNetwork: BasedUtxoNetwork.fromName(values.valueAs(5)),
        publicKey: values.valueAs(6),
        witnessScript: values.valueAs(7),
        redeemScript: values.valueAs(8),
        identifier: values.valueAs(9));
  }

  @override
  CborTagValue toCbor() {
    return CborTagValue(
        CborSerializable.fromDynamic([
          keyIndex.toCbor(),
          CborStringValue(address.addressProgram),
          CborIntValue(id),
          CborBoleanValue(defaultAddress),
          CborStringValue(type.value),
          CborStringValue(baseNetwork.value),
          CborBytesValue(publicKey),
          witnessScript,
          redeemScript,
          identifier
        ]),
        CborTagsConst.web3BitcoinAccount);
  }

  @override
  late final String addressStr = address.toAddress(baseNetwork);
}

class Web3BitcoinChainIdnetifier extends Web3ChainIdnetifier {
  final BasedUtxoNetwork network;

  Web3BitcoinChainIdnetifier(
      {required this.network,
      required super.wsIdentifier,
      required super.caip2,
      required super.id});

  factory Web3BitcoinChainIdnetifier.deserialize(
      {List<int>? bytes, CborObject? object, String? hex}) {
    final CborListValue values = CborSerializable.cborTagValue(
        object: object,
        cborBytes: bytes,
        hex: hex,
        tags: CborTagsConst.web3BitcoinChainIdentifier);
    return Web3BitcoinChainIdnetifier(
        network: BasedUtxoNetwork.fromName(values.valueAs(0)),
        id: values.valueAs(1),
        wsIdentifier: values.valueAs(2),
        caip2: values.valueAs(3));
  }
  @override
  CborTagValue toCbor() {
    return CborTagValue(
      CborSerializable.fromDynamic([network.value, id, wsIdentifier, caip2]),
      CborTagsConst.web3BitcoinChainIdentifier,
    );
  }
}

class Web3BitcoinChainAuthenticated
    extends Web3ChainAuthenticated<Web3BitcoinChainAccount> {
  @override
  final List<Web3BitcoinChainIdnetifier> networks;
  @override
  final Web3BitcoinChainIdnetifier currentNetwork;
  Web3BitcoinChainAuthenticated({
    required super.accounts,
    required this.currentNetwork,
    required List<Web3BitcoinChainIdnetifier> networks,
  })  : networks = networks.immutable,
        super(networkType: NetworkType.bitcoinAndForked);

  factory Web3BitcoinChainAuthenticated.deserialize(
      {List<int>? bytes, CborObject? object, String? hex}) {
    final CborListValue values = CborSerializable.cborTagValue(
        object: object,
        cborBytes: bytes,
        hex: hex,
        tags: NetworkType.bitcoinAndForked.tag);
    return Web3BitcoinChainAuthenticated(
        accounts: values
            .elementAsListOf<CborTagValue>(0)
            .map((e) => Web3BitcoinChainAccount.deserialize(object: e))
            .toList(),
        networks: values
            .elementAsListOf<CborTagValue>(1)
            .map((e) => Web3BitcoinChainIdnetifier.deserialize(object: e))
            .toList(),
        currentNetwork: Web3BitcoinChainIdnetifier.deserialize(
            object: values.elementAs<CborTagValue>(2)));
  }

  @override
  NetworkType get networkType => NetworkType.bitcoinAndForked;
}
