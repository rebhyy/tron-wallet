import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:on_chain_wallet/app/error/exception/wallet_ex.dart';
import 'package:on_chain_wallet/app/serialization/serialization.dart';
import 'package:on_chain_wallet/crypto/utils/ethereum/utils.dart';
import 'package:on_chain_wallet/wallet/api/provider/core/provider.dart';

import 'package:on_chain_wallet/wallet/models/network/core/params/params.dart';
import 'package:on_chain_wallet/wallet/models/token/token/token.dart';
import 'package:on_chain_wallet/wallet/api/provider/networks/ethereum.dart';
import 'package:on_chain_wallet/wallet/constant/tags/constant.dart';

class EthereumNetworkParams extends NetworkCoinParams<EthereumAPIProvider> {
  final BigInt chainId;
  final bool supportEIP1559;
  final bool defaultNetwork;

  @override
  bool get isTestNet => defaultNetwork && !mainnet;
  EthereumNetworkParams._(
      {required super.transactionExplorer,
      required super.addressExplorer,
      required super.token,
      required super.providers,
      required this.chainId,
      required this.supportEIP1559,
      required super.chainType,
      super.bip32CoinType,
      this.defaultNetwork = true});
  factory EthereumNetworkParams(
      {String? transactionExplorer,
      String? addressExplorer,
      required Token token,
      required List<EthereumAPIProvider> providers,
      required BigInt chainId,
      required bool supportEIP1559,
      required ChainType chainType,
      bool defaultNetwork = true,
      int? bip32CoinType}) {
    if (chainId.isNegative || token.decimal != EthereumUtils.decimal) {
      throw const WalletException.error("invalid_network_information");
    }
    return EthereumNetworkParams._(
        transactionExplorer: transactionExplorer,
        addressExplorer: addressExplorer,
        token: token,
        providers: providers,
        chainId: chainId,
        supportEIP1559: supportEIP1559,
        chainType: chainType,
        bip32CoinType: bip32CoinType,
        defaultNetwork: defaultNetwork);
  }
  EthereumNetworkParams copyWith(
      {String? transactionExplorer,
      String? addressExplorer,
      Token? token,
      List<EthereumAPIProvider>? providers,
      BigInt? chainId,
      bool? supportEIP1559,
      ChainType? chainType,
      bool? defaultNetwork,
      int? bip32CoinType}) {
    return EthereumNetworkParams(
        transactionExplorer: transactionExplorer ?? this.transactionExplorer,
        addressExplorer: addressExplorer ?? this.addressExplorer,
        token: token ?? this.token,
        providers: providers ?? List.from(this.providers),
        chainId: chainId ?? this.chainId,
        supportEIP1559: supportEIP1559 ?? this.supportEIP1559,
        chainType: chainType ?? this.chainType,
        defaultNetwork: defaultNetwork ?? this.defaultNetwork,
        bip32CoinType: bip32CoinType ?? this.bip32CoinType);
  }

  factory EthereumNetworkParams.fromCborBytesOrObject(
      {List<int>? bytes, CborObject? obj}) {
    final CborListValue cbor = CborSerializable.cborTagValue(
        cborBytes: bytes, object: obj, tags: CborTagsConst.evmNetworkParam);
    final bool? defaultNetwork = cbor.elementAs(7);
    return EthereumNetworkParams(
      chainId: cbor.elementAs(0),
      supportEIP1559: cbor.elementAs(1),
      chainType: ChainType.fromValue(cbor.elementAs(2)),
      token: Token.deserialize(obj: cbor.elementAsCborTag(5)),
      providers: cbor
          .elementAsListOf<CborObject>(6)
          .map((e) => EthereumAPIProvider.fromCborBytesOrObject(obj: e))
          .toList(),
      defaultNetwork: defaultNetwork ?? true,
      bip32CoinType: cbor.elementAs(8),
      transactionExplorer: cbor.elementAs(9),
      addressExplorer: cbor.elementAs(10),
    );
  }
  @override
  CborTagValue toCbor() {
    return CborTagValue(
        CborSerializable.fromDynamic([
          chainId,
          supportEIP1559,
          chainType.name,
          const CborNullValue(),
          const CborNullValue(),
          token.toCbor(),
          CborSerializable.fromDynamic(
              providers.map((e) => e.toCbor()).toList()),
          defaultNetwork,
          bip32CoinType,
          transactionExplorer,
          addressExplorer,
        ]),
        CborTagsConst.evmNetworkParam);
  }

  BigInt get identifier => chainId;

  @override
  EthereumNetworkParams updateParams(
      {List<APIProvider>? updateProviders,
      Token? token,
      String? transactionExplorer,
      String? addressExplorer,
      int? bip32CoinType}) {
    return EthereumNetworkParams(
      transactionExplorer: transactionExplorer,
      addressExplorer: addressExplorer,
      token: NetworkCoinParams.validateUpdateParams(
          token: this.token, updateToken: token),
      providers: updateProviders?.cast<EthereumAPIProvider>() ?? providers,
      chainId: chainId,
      supportEIP1559: supportEIP1559,
      chainType: chainType,
      defaultNetwork: defaultNetwork,
      bip32CoinType: bip32CoinType,
    );
  }
}
