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
import 'package:on_chain_wallet/wallet/web3/networks/bitcoin/permission/models/account.dart';

class Web3BitcoinCashChainAccount extends Web3BitcoinChainAccount {
  // @override
  // final int id;
  // final BitcoinAddressType type;
  // final String addressProgram;
  // final BitcoinCashNetwork baseNetwork;
  // final List<int> publicKey;
  // final String? witnessScript;
  // final String? redeemScript;

  Web3BitcoinCashChainAccount._(
      {required super.keyIndex,
      required super.address,
      required super.defaultAddress,
      required super.identifier,
      required super.id,
      required super.addressProgram,
      required super.type,
      required BitcoinCashNetwork super.baseNetwork,
      required super.witnessScript,
      required super.redeemScript,
      required super.publicKey});

  @override
  Web3BitcoinCashChainAccount clone(
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
    return Web3BitcoinCashChainAccount._(
        keyIndex: keyIndex ?? this.keyIndex,
        address: address ?? this.address,
        defaultAddress: defaultAddress ?? this.defaultAddress,
        id: id ?? this.id,
        baseNetwork: (baseNetwork ?? this.baseNetwork) as BitcoinCashNetwork,
        publicKey: publicKey ?? this.publicKey,
        witnessScript: witnessScript ?? this.witnessScript,
        redeemScript: redeemScript ?? this.redeemScript,
        addressProgram: addressProgram ?? this.addressProgram,
        type: type ?? this.type,
        identifier: identifier ?? this.identifier);
  }

  factory Web3BitcoinCashChainAccount.fromChainAccount(
      {required IBitcoinCashAddress address,
      required bool isDefault,
      required WalletBitcoinCashNetwork network}) {
    return Web3BitcoinCashChainAccount._(
        keyIndex: address.keyIndex,
        address: address.networkAddress,
        id: network.value,
        defaultAddress: isDefault,
        type: address.networkAddress.type,
        addressProgram: address.networkAddress.addressProgram,
        baseNetwork:
            network.coinParam.transacationNetwork as BitcoinCashNetwork,
        publicKey: address.multiSigAccount ? [] : address.publicKey,
        witnessScript: address.witnessScript()?.toHex(),
        redeemScript: address.redeemScript()?.toHex(),
        identifier: address.identifier);
  }

  factory Web3BitcoinCashChainAccount.deserialize(
      {List<int>? bytes, CborObject? object, String? hex}) {
    final CborListValue values = CborSerializable.cborTagValue(
        object: object,
        cborBytes: bytes,
        hex: hex,
        tags: CborTagsConst.web3BitcoinCashAccount);
    final type = BitcoinAddressType.fromValue(values.valueAs(4));
    final String program = values.valueAs(1);
    return Web3BitcoinCashChainAccount._(
        keyIndex: AddressDerivationIndex.deserialize(
            obj: values.indexAs<CborTagValue>(0)),
        addressProgram: program,
        type: type,
        address:
            BitcoinBaseAddress.fromProgram(addressProgram: program, type: type),
        id: values.valueAs(2),
        defaultAddress: values.valueAs(3),
        baseNetwork:
            BasedUtxoNetwork.fromName(values.valueAs(5)) as BitcoinCashNetwork,
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
        CborTagsConst.web3BitcoinCashAccount);
  }

  String get wcStyle {
    return switch (baseNetwork) {
      BitcoinCashNetwork.mainnet ||
      BitcoinCashNetwork.testnet =>
        addressStr.split(":").last,
      _ => addressStr
    };
  }
}

class Web3BitcoinCashChainIdnetifier extends Web3BitcoinChainIdnetifier {
  // final BitcoinCashNetwork network;

  Web3BitcoinCashChainIdnetifier(
      {required BitcoinCashNetwork super.network,
      required super.wsIdentifier,
      required super.caip2,
      required super.id});
  factory Web3BitcoinCashChainIdnetifier.deserialize(
      {List<int>? bytes, CborObject? object, String? hex}) {
    final CborListValue values = CborSerializable.cborTagValue(
        object: object,
        cborBytes: bytes,
        hex: hex,
        tags: CborTagsConst.web3BitcoinCashChainIdentifier);
    return Web3BitcoinCashChainIdnetifier(
        network:
            BasedUtxoNetwork.fromName(values.valueAs(0)) as BitcoinCashNetwork,
        id: values.valueAs(1),
        wsIdentifier: values.valueAs(2),
        caip2: values.valueAs(3));
  }
  @override
  CborTagValue toCbor() {
    return CborTagValue(
      CborSerializable.fromDynamic([network.value, id, wsIdentifier, caip2]),
      CborTagsConst.web3BitcoinCashChainIdentifier,
    );
  }
}

class Web3BitcoinCashChainAuthenticated
    extends Web3ChainAuthenticated<Web3BitcoinCashChainAccount> {
  @override
  final List<Web3BitcoinCashChainIdnetifier> networks;
  @override
  final Web3BitcoinCashChainIdnetifier currentNetwork;
  Web3BitcoinCashChainAuthenticated({
    required super.accounts,
    required this.currentNetwork,
    required List<Web3BitcoinCashChainIdnetifier> networks,
  })  : networks = networks.immutable,
        super(networkType: NetworkType.bitcoinCash);

  factory Web3BitcoinCashChainAuthenticated.deserialize(
      {List<int>? bytes, CborObject? object, String? hex}) {
    final CborListValue values = CborSerializable.cborTagValue(
        object: object,
        cborBytes: bytes,
        hex: hex,
        tags: NetworkType.bitcoinCash.tag);
    return Web3BitcoinCashChainAuthenticated(
        accounts: values
            .elementAsListOf<CborTagValue>(0)
            .map((e) => Web3BitcoinCashChainAccount.deserialize(object: e))
            .toList(),
        networks: values
            .elementAsListOf<CborTagValue>(1)
            .map((e) => Web3BitcoinCashChainIdnetifier.deserialize(object: e))
            .toList(),
        currentNetwork: Web3BitcoinCashChainIdnetifier.deserialize(
            object: values.elementAs<CborTagValue>(2)));
  }

  @override
  NetworkType get networkType => NetworkType.bitcoinCash;
}
