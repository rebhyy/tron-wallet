import 'package:blockchain_utils/cbor/cbor.dart';
import 'package:blockchain_utils/helper/helper.dart';
import 'package:on_chain_wallet/app/core.dart';
import 'package:on_chain_wallet/wallet/constant/tags/constant.dart';
import 'package:on_chain_wallet/wallet/web3/core/permission/types/account.dart';
import 'package:on_chain_wallet/crypto/types/networks.dart';

abstract class Web3RequestAuthentication with CborSerializable {
  final String applicationId;
  final APPImage? icon;
  final String? url;
  String get name;

  const Web3RequestAuthentication(
      {required this.applicationId, required this.icon, this.url});
}

class Web3LocalAuthentication extends Web3RequestAuthentication {
  const Web3LocalAuthentication(
      {required super.applicationId, required super.icon, required this.name});
  @override
  final String name;

  @override
  CborTagValue toCbor() {
    throw UnimplementedError();
  }
}

enum Web3APPProtocol {
  injected(0),
  walletConnect(1);

  final int value;
  const Web3APPProtocol(this.value);
  bool get isWalletConnect => this == walletConnect;
  bool get isInjected => this == injected;
  static Web3APPProtocol fromValue(int? tag) {
    return values.firstWhere((e) => e.value == tag,
        orElse: () =>
            throw AppSerializationException(objectName: "Web3APPProtocol"));
  }
}

class Web3APPAuthenticationKey with CborSerializable {
  final List<int> publicKey;
  final List<int> privateKey;
  factory Web3APPAuthenticationKey.fake() {
    return Web3APPAuthenticationKey(publicKey: [], privateKey: []);
  }
  Web3APPAuthenticationKey(
      {required List<int> publicKey, required List<int> privateKey})
      : publicKey = publicKey.asImmutableBytes,
        privateKey = privateKey.asImmutableBytes;
  factory Web3APPAuthenticationKey.deseralize(
      {List<int>? bytes, CborObject? object, String? hex}) {
    final CborListValue values = CborSerializable.cborTagValue(
        cborBytes: bytes,
        hex: hex,
        object: object,
        tags: CborTagsConst.web3AppAuthKey);
    return Web3APPAuthenticationKey(
      privateKey: values.elementAs(0),
      publicKey: values.elementAs(1),
    );
  }

  @override
  CborTagValue toCbor() {
    return CborTagValue(
        CborSerializable.fromDynamic([
          CborBytesValue(privateKey),
          CborBytesValue(publicKey),
        ]),
        CborTagsConst.web3AppAuthKey);
  }
}

class Web3APPData with CborSerializable {
  final bool active;
  final String applicationId;
  final List<NetworkType> networks;
  List<Web3ChainAuthenticated> _chains;
  List<Web3ChainAuthenticated> get chains => _chains;
  bool get hasAnyPermission => _chains.any((e) => e.accounts.isNotEmpty);

  T? getAuth<T extends Web3ChainAuthenticated>(NetworkType networkType) {
    return _chains
        .firstWhereOrNull((e) => e.networkType == networkType)
        ?.cast();
  }

  Web3APPData._({
    required List<NetworkType> networks,
    required this.applicationId,
    this.active = true,
    List<Web3ChainAuthenticated> chains = const [],
  })  : _chains = chains.imutable,
        networks = networks.immutable;

  factory Web3APPData(
      {required Web3APPAuthenticationKey token,
      required List<NetworkType> networks,
      required String applicationId,
      List<Web3ChainAuthenticated> chains = const [],
      bool active = true}) {
    return Web3APPData._(
        active: active,
        // token: token,
        chains: chains,
        networks: networks,
        applicationId: applicationId);
  }
  factory Web3APPData.deserialize(
      {List<int>? bytes, CborObject? object, String? hex}) {
    final CborListValue values = CborSerializable.cborTagValue(
        cborBytes: bytes,
        hex: hex,
        object: object,
        tags: CborTagsConst.web3App);
    return Web3APPData._(
        chains: values
            .elementAsListOf<CborTagValue>(0)
            .map((e) => Web3ChainAuthenticated.deserialize(object: e))
            .toList(),
        active: values.elementAs(1),
        // token:
        //     Web3APPAuthenticationKey.deseralize(object: values.elementAsCborTag(2)),
        networks: values
            .elementAsListOf<CborBytesValue>(2)
            .map((e) => NetworkType.fromTag(e.value))
            .toList(),
        applicationId: values.elementAs(3));
  }
  @override
  CborTagValue toCbor() {
    return CborTagValue(
        CborSerializable.fromDynamic([
          CborSerializable.fromDynamic(_chains.map((e) => e.toCbor()).toList()),
          active,
          // token.toCbor(),
          CborSerializable.fromDynamic(
              networks.map((e) => CborBytesValue(e.tag)).toList()),
          applicationId
        ]),
        CborTagsConst.web3App);
  }
}

class Web3ClientInfo with Equatable {
  final APPImage? image;
  final String url;
  final String identifier;
  final String name;
  String get view => url;
  final String? description;
  final Web3APPProtocol protocol;
  const Web3ClientInfo._(
      {required this.image,
      required this.url,
      required this.identifier,
      required this.name,
      required this.protocol,
      this.description});

  static Web3ClientInfo? info(
      {required String? url, String? name, required APPImage? faviIcon}) {
    final applicationId = Web3ApplicationAuthentication.toApplicationId(url);
    if (applicationId == null) return null;
    final Uri uri = Uri.parse(applicationId);
    return Web3ClientInfo._(
        image: faviIcon,
        url: url!,
        identifier: applicationId,
        name: (name?.isEmpty ?? true) ? uri.host : name!,
        protocol: Web3APPProtocol.injected);
  }

  Web3ApplicationAuthentication toAuhenticated({
    required Web3APPAuthenticationKey token,
    required String applicationKey,
  }) {
    return Web3ApplicationAuthentication._(
        name: name,
        applicationId: identifier,
        icon: image,
        token: token,
        url: url,
        protocol: protocol);
  }

  static Web3ClientInfo walletConnect(
      {required String clientId,
      required String url,
      required String name,
      required String description,
      required APPImage? faviIcon}) {
    return Web3ClientInfo._(
        image: faviIcon,
        url: url,
        identifier: clientId,
        name: name,
        protocol: Web3APPProtocol.walletConnect,
        description: description);
  }

  @override
  List get variabels => [identifier, url];
}

class Web3DappInfo {
  final Web3ApplicationAuthentication authentication;
  final Web3APPData dappData;
  final Web3ClientInfo clientInfo;
  const Web3DappInfo(
      {required this.authentication,
      required this.dappData,
      required this.clientInfo});
}

class Web3ApplicationAuthentication extends Web3RequestAuthentication
    with CborSerializable {
  final Web3APPProtocol protocol;

  @override
  final String name;
  final bool active;
  final Web3APPAuthenticationKey token;
  Web3ClientInfo toClient() {
    return Web3ClientInfo._(
        image: icon,
        url: url ?? applicationId,
        identifier: applicationId,
        name: name,
        protocol: protocol);
  }

  static String? toApplicationId(String? url) {
    final Uri? uri = Uri.tryParse(url ?? "");
    if (uri?.host.isEmpty ?? true) {
      return null;
    }
    final appId = Uri(host: uri!.host, scheme: uri.scheme, port: uri.port);
    return appId.normalizePath().toString();
  }

  Web3ApplicationAuthentication copyWith({String? name, bool? active}) {
    return Web3ApplicationAuthentication._(
        name: name ?? this.name,
        applicationId: applicationId,
        icon: icon,
        token: token,
        protocol: protocol,
        active: active ?? this.active,
        url: url);
  }

  Web3ApplicationAuthentication._({
    required this.name,
    required super.applicationId,
    required super.icon,
    required this.token,
    required this.protocol,
    this.active = true,
    super.url,
  });

  Web3ApplicationAuthentication clone() {
    return Web3ApplicationAuthentication._(
        name: name,
        applicationId: applicationId,
        icon: icon,
        token: token,
        active: active,
        protocol: protocol);
  }

  factory Web3ApplicationAuthentication.local() {
    return Web3ApplicationAuthentication._(
        name: "OnChain",
        applicationId: "OnChain",
        icon: null,
        token: Web3APPAuthenticationKey.fake(),
        protocol: Web3APPProtocol.walletConnect);
  }

  factory Web3ApplicationAuthentication.deserialize(
      {List<int>? bytes, CborObject? object, String? hex}) {
    final CborListValue values = CborSerializable.cborTagValue(
        cborBytes: bytes,
        hex: hex,
        object: object,
        tags: CborTagsConst.web3App);
    return Web3ApplicationAuthentication._(
        applicationId: values.valueAs(0),
        name: values.valueAs(1),
        icon: values.elemetMybeAs<APPImage, CborTagValue>(
            2, (e) => APPImage.deserialize(obj: e)),
        active: values.valueAs(3),
        token: Web3APPAuthenticationKey.deseralize(
            object: values.indexAs<CborTagValue>(4)),
        protocol: Web3APPProtocol.fromValue(values.valueAs(5)),
        url: values.valueAs(6));
  }
  @override
  CborTagValue toCbor() {
    return CborTagValue(
        CborSerializable.fromDynamic([
          applicationId,
          name,
          icon?.toCbor(),
          active,
          token.toCbor(),
          protocol.value,
          url
        ]),
        CborTagsConst.web3App);
  }
}
