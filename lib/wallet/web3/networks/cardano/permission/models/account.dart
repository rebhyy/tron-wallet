import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:on_chain/ada/ada.dart';
import 'package:on_chain_wallet/app/serialization/cbor/cbor.dart';
import 'package:on_chain_wallet/crypto/types/networks.dart';
import 'package:on_chain_wallet/wallet/constant/tags/constant.dart';
import 'package:on_chain_wallet/wallet/chain/account.dart';
import 'package:on_chain_wallet/wallet/web3/constant/constant/exception.dart';
import 'package:on_chain_wallet/wallet/web3/core/permission/types/account.dart';
import 'package:on_chain_wallet/crypto/keys/access/crypto_keys/crypto_keys.dart';

class Web3ADAMultisigChainAccount with CborSerializable {
  List<String> get requirementsKeyHashes => script.nativeScripts
      .cast<NativeScriptScriptPubkey>()
      .map((e) => e.addressKeyHash.toHex())
      .toList();
  final NativeScriptScriptNOfK script;
  Web3ADAMultisigChainAccount({required this.script});

  factory Web3ADAMultisigChainAccount.deserialize(
      {List<int>? bytes, CborObject? object, String? hex}) {
    final CborListValue values = CborSerializable.cborTagValue(
        object: object,
        cborBytes: bytes,
        hex: hex,
        tags: CborTagsConst.web3CardanoMultiSigAccount);
    return Web3ADAMultisigChainAccount(
        script: NativeScriptScriptNOfK.deserialize(
            values.indexAs<CborListValue>(0)));
  }

  @override
  CborTagValue<CborObject> toCbor() {
    return CborTagValue(CborListValue.definite([script.toCbor()]),
        CborTagsConst.web3CardanoMultiSigAccount);
  }
}

class Web3ADAChainAccount extends Web3ChainAccount<ADAAddress> {
  @override
  final int id;
  final List<int>? publicKey;
  final List<TransactionUnspentOutput> utxos;
  final BigInt balance;
  final bool isRewardAddress;
  final Web3ADAMultisigChainAccount? multisig;
  bool get isScript => publicKey == null;
  String get asCborAddress => BytesUtils.toHexString(address.toBytes());
  Web3ADAChainAccount(
      {required super.keyIndex,
      required super.address,
      required super.defaultAddress,
      required this.id,
      required super.identifier,
      required this.balance,
      required this.isRewardAddress,
      required List<TransactionUnspentOutput> utxos,
      this.multisig,
      List<int>? publicKey})
      : utxos = utxos.immutable,
        publicKey = publicKey?.asImmutableBytes;
  @override
  Web3ADAChainAccount clone({
    AddressDerivationIndex? keyIndex,
    ADAAddress? address,
    bool? defaultAddress,
    int? id,
    List<int>? publicKey,
    String? identifier,
    BigInt? balance,
    List<TransactionUnspentOutput>? utxos,
    bool? isRewardAddress,
    Web3ADAMultisigChainAccount? multisig,
  }) {
    return Web3ADAChainAccount(
        keyIndex: keyIndex ?? this.keyIndex,
        address: address ?? this.address,
        defaultAddress: defaultAddress ?? this.defaultAddress,
        id: id ?? this.id,
        publicKey: publicKey ?? this.publicKey,
        identifier: identifier ?? this.identifier,
        utxos: utxos ?? this.utxos,
        balance: balance ?? this.balance,
        isRewardAddress: isRewardAddress ?? this.isRewardAddress,
        multisig: multisig ?? this.multisig);
  }

  factory Web3ADAChainAccount.fromChainAccount(
      {required ICardanoAddress address,
      required int id,
      required bool isDefault,
      required List<TransactionUnspentOutput> utxos,
      required bool isRewardAddress}) {
    if (isRewardAddress) {
      if (!address.isBaseAddress && !address.isBaseAddress) {
        throw Web3RequestExceptionConst.internalError;
      }
    }

    Web3ADAMultisigChainAccount? multisig;
    if (address.multiSigAccount) {
      BaseCardanoMultiSignatureCredential? credential;
      final mAccount = address as ICardanoMultiSigAddress;
      if (isRewardAddress) {
        if (mAccount.isBaseAddress) {
          credential = mAccount.addressInfo.stakeCredential;
        } else {
          credential = mAccount.addressInfo.credential;
        }
      } else {
        credential = mAccount.addressInfo.credential;
      }
      assert(credential != null);
      if (credential != null && credential.type.isScript) {
        final script = credential.cast<CardanoMultiSignatureScript>();

        multisig = Web3ADAMultisigChainAccount(script: script.script);
      }
    }
    return Web3ADAChainAccount(
        keyIndex: isRewardAddress
            ? (address.rewardKeyIndex ?? address.keyIndex)
            : address.keyIndex,
        address: isRewardAddress
            ? address.rewardAddress ?? address.networkAddress
            : address.networkAddress,
        id: id,
        defaultAddress: isDefault,
        publicKey:
            isRewardAddress ? address.rewardPublicKey : address.publicKey,
        identifier: address.identifier,
        balance:
            isRewardAddress ? BigInt.zero : address.address.currencyBalance,
        utxos: utxos,
        isRewardAddress: isRewardAddress,
        multisig: multisig);
  }

  factory Web3ADAChainAccount.deserialize(
      {List<int>? bytes, CborObject? object, String? hex}) {
    final CborListValue values = CborSerializable.cborTagValue(
        object: object,
        cborBytes: bytes,
        hex: hex,
        tags: CborTagsConst.web3CardanoAccount);
    return Web3ADAChainAccount(
        keyIndex: AddressDerivationIndex.deserialize(
            obj: values.indexAs<CborTagValue>(0)),
        address: ADAAddress.fromAddress(values.valueAs(1)),
        id: values.valueAs(2),
        defaultAddress: values.valueAs(3),
        publicKey: values.valueAs(4),
        identifier: values.valueAs(5),
        balance: values.valueAs(6),
        utxos: values
            .elementAsListOf<CborIterableObject>(7)
            .map((e) => TransactionUnspentOutput.deserialize(e))
            .toList(),
        isRewardAddress: values.valueAs(8),
        multisig:
            values.indexMaybeAs<Web3ADAMultisigChainAccount, CborTagValue>(
                9, (e) => Web3ADAMultisigChainAccount.deserialize(object: e)));
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
          identifier,
          balance,
          CborListValue<CborObject>.definite(
              utxos.map((e) => e.toCbor()).toList()),
          isRewardAddress,
          multisig?.toCbor()
        ]),
        CborTagsConst.web3CardanoAccount);
  }

  @override
  String get addressStr => address.address;
}

class Web3ADAChainIdnetifier extends Web3ChainIdnetifier {
  final ADANetwork network;
  Web3ADAChainIdnetifier(
      {required super.wsIdentifier,
      required super.caip2,
      required super.id,
      required this.network});
  factory Web3ADAChainIdnetifier.deserialize(
      {List<int>? bytes, CborObject? object, String? hex}) {
    final CborListValue values = CborSerializable.cborTagValue(
        object: object,
        cborBytes: bytes,
        hex: hex,
        tags: CborTagsConst.web3ADAChainIdentifier);
    return Web3ADAChainIdnetifier(
        id: values.elementAs(0),
        wsIdentifier: values.elementAs(1),
        caip2: values.elementAs(2),
        network: ADANetwork.fromProtocolMagic(values.elementAs(3)));
  }
  @override
  CborTagValue toCbor() {
    return CborTagValue(
        CborSerializable.fromDynamic([
          id,
          wsIdentifier,
          caip2,
          network.protocolMagic,
        ]),
        CborTagsConst.web3ADAChainIdentifier);
  }
}

class Web3ADAChainAuthenticated
    extends Web3ChainAuthenticated<Web3ADAChainAccount> {
  @override
  final List<Web3ADAChainIdnetifier> networks;
  @override
  final Web3ADAChainIdnetifier currentNetwork;
  Web3ADAChainAuthenticated({
    required super.accounts,
    required this.currentNetwork,
    required List<Web3ADAChainIdnetifier> networks,
  })  : networks = networks.immutable,
        super(networkType: NetworkType.cardano);

  factory Web3ADAChainAuthenticated.deserialize(
      {List<int>? bytes, CborObject? object, String? hex}) {
    final CborListValue values = CborSerializable.cborTagValue(
        object: object,
        cborBytes: bytes,
        hex: hex,
        tags: NetworkType.cardano.tag);
    return Web3ADAChainAuthenticated(
      accounts: values
          .elementAsListOf<CborTagValue>(0)
          .map((e) => Web3ADAChainAccount.deserialize(object: e))
          .toList(),
      networks: values
          .elementAsListOf<CborTagValue>(1)
          .map((e) => Web3ADAChainIdnetifier.deserialize(object: e))
          .toList(),
      currentNetwork: Web3ADAChainIdnetifier.deserialize(
          object: values.elementAs<CborTagValue>(2)),
    );
  }
}
