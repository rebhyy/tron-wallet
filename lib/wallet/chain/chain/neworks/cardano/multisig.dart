part of 'package:on_chain_wallet/wallet/chain/chain/chain.dart';

mixin CardanoMultiSigBase {
  abstract final CardanoMultiSignatureAddressDetails multiSignatureAddress;
}

class CardanoMultiSigSignerDetails with Equatable, CborSerializable {
  CardanoMultiSigSignerDetails._(
      {required List<int> publicKey, required this.keyIndex})
      : publicKey = publicKey.asImmutableBytes;

  factory CardanoMultiSigSignerDetails(
      {required List<int> publicKey, required Bip32AddressIndex keyIndex}) {
    if (keyIndex.currencyCoin.conf.type != EllipticCurveTypes.ed25519Kholaw) {
      throw WalletExceptionConst.invalidAccountDeta(
          "CardanoMultiSigSignerDetails");
    }
    final key = Ed25519KholawPublicKey.fromBytes(publicKey)
        .compressed
        .sublist(Ed25519KeysConst.pubKeyPrefix.length);

    return CardanoMultiSigSignerDetails._(publicKey: key, keyIndex: keyIndex);
  }
  factory CardanoMultiSigSignerDetails.deserialize(
      {List<int>? bytes, CborObject? obj}) {
    final CborListValue cbor = CborSerializable.cborTagValue(
        cborBytes: bytes,
        object: obj,
        tags: CborTagsConst.cardanoMultiSigSigner);

    final List<int> publicKey = cbor.valueAs(0);
    final keyIndex =
        Bip32AddressIndex.deserialize(obj: cbor.indexAs<CborTagValue>(1));
    return CardanoMultiSigSignerDetails._(
        publicKey: publicKey, keyIndex: keyIndex);
  }
  final List<int> publicKey;

  final Bip32AddressIndex keyIndex;
  String get path => keyIndex.toString();

  @override
  CborTagValue toCbor() {
    return CborTagValue(
        CborSerializable.fromDynamic(
            [CborBytesValue(publicKey), keyIndex.toCbor()]),
        CborTagsConst.cardanoMultiSigSigner);
  }

  late final Ed25519KeyHash keyHash =
      Ed25519KeyHash(QuickCrypto.blake2b224Hash(publicKey));

  @override
  List get variabels => [publicKey, keyIndex];
}

enum CardanoCredentialType {
  publicKey(tags: [0], name: 'public_key'),
  script(tags: [1], name: 'script');

  bool get isPublicKey => this == publicKey;
  bool get isScript => this == script;

  final List<int> tags;
  final String name;
  const CardanoCredentialType({required this.tags, required this.name});
  static CardanoCredentialType fromValue(List<int>? tags) {
    return values.firstWhere((e) => BytesUtils.bytesEqual(tags, e.tags),
        orElse: () => throw AppSerializationException(
            objectName: "CardanoCredentialType"));
  }
}

abstract class BaseCardanoMultiSignatureCredential with CborSerializable {
  final CardanoCredentialType type;
  NativeScript get script;
  List<Bip32AddressIndex> get keyIndexes;
  int get threshold;
  abstract final PolicyID policyId;
  const BaseCardanoMultiSignatureCredential({required this.type});
  Credential get credential;
  factory BaseCardanoMultiSignatureCredential.deserialize(
      {List<int>? bytes, CborObject? obj}) {
    final CborTagValue tag =
        CborSerializable.decode(cborBytes: bytes, object: obj);
    final type = CardanoCredentialType.fromValue(tag.tags);
    return switch (type) {
      CardanoCredentialType.publicKey =>
        CardanoMultiSignatureKey.deserialize(obj: tag),
      CardanoCredentialType.script =>
        CardanoMultiSignatureScript.deserialize(obj: tag),
    };
  }
  T cast<T extends BaseCardanoMultiSignatureCredential>() {
    if (this is! T) {
      throw WalletExceptionConst.internalError(
          "BaseCardanoMultiSignatureCredential");
    }
    return this as T;
  }
}

class CardanoMultiSignatureScript extends BaseCardanoMultiSignatureCredential {
  final List<CardanoMultiSigSignerDetails> signers;
  @override
  final int threshold;
  final List<int> scriptHash;
  @override
  late final CredentialScript credential = CredentialScript(scriptHash);
  @override
  late final NativeScriptScriptNOfK script = NativeScriptScriptNOfK(
      n: threshold,
      nativeScripts:
          signers.map((e) => NativeScriptScriptPubkey(e.keyHash)).toList());

  CardanoMultiSignatureScript._(
      {required this.signers,
      required this.threshold,
      required List<int> scriptHash})
      : scriptHash = scriptHash.asImmutableBytes,
        super(type: CardanoCredentialType.script);

  factory CardanoMultiSignatureScript(
      {required int threshold,
      required List<CardanoMultiSigSignerDetails> signers}) {
    final sumWeight = signers.length;
    if (threshold > CardanoUtils.maxMultisigThresholdInt || threshold < 1) {
      throw WalletExceptionConst.invalidAccountDeta(
          "CardanoMultiSignatureScript");
    }
    if (sumWeight < threshold) {
      throw WalletExceptionConst.invalidAccountDeta(
          "CardanoMultiSignatureScript");
    }

    final nOfK = NativeScriptScriptNOfK(
        n: threshold,
        nativeScripts:
            signers.map((e) => NativeScriptScriptPubkey(e.keyHash)).toList());
    return CardanoMultiSignatureScript._(
        signers: signers, threshold: threshold, scriptHash: nOfK.toHash().data);
  }

  @override
  CborTagValue toCbor() {
    return CborTagValue(
        CborSerializable.fromDynamic([
          CborSerializable.fromDynamic(signers.map((e) => e.toCbor()).toList()),
          threshold,
          CborBytesValue(scriptHash)
        ]),
        CardanoCredentialType.script.tags);
  }

  factory CardanoMultiSignatureScript.deserialize(
      {List<int>? bytes, CborObject? obj}) {
    final CborListValue values = CborSerializable.cborTagValue(
        cborBytes: bytes, object: obj, tags: CardanoCredentialType.script.tags);

    final List<CardanoMultiSigSignerDetails> signers = values
        .elementAsListOf<CborTagValue>(0)
        .map<CardanoMultiSigSignerDetails>(
            (e) => CardanoMultiSigSignerDetails.deserialize(obj: e))
        .toList();
    final int threshHold = values.elementAs(1);

    return CardanoMultiSignatureScript._(
        signers: signers,
        threshold: threshHold,
        scriptHash: values.elementAs(2));
  }

  List get variabels => [threshold, scriptHash, type];

  @override
  List<Bip32AddressIndex> get keyIndexes =>
      signers.map((e) => e.keyIndex).toList();

  @override
  late final PolicyID policyId = PolicyID(scriptHash);
}

class CardanoMultiSignatureKey extends BaseCardanoMultiSignatureCredential {
  final CardanoMultiSigSignerDetails signer;
  @override
  final int threshold = 1;
  @override
  late final CredentialKey credential = CredentialKey(signer.keyHash.data);

  CardanoMultiSignatureKey._({required this.signer})
      : super(type: CardanoCredentialType.publicKey);

  factory CardanoMultiSignatureKey(
      {required CardanoMultiSigSignerDetails signer}) {
    return CardanoMultiSignatureKey._(signer: signer);
  }

  @override
  CborTagValue toCbor() {
    return CborTagValue(
        CborSerializable.fromDynamic([signer.toCbor()]), type.tags);
  }

  factory CardanoMultiSignatureKey.deserialize(
      {List<int>? bytes, CborObject? obj}) {
    final CborListValue values = CborSerializable.cborTagValue(
        cborBytes: bytes,
        object: obj,
        tags: CardanoCredentialType.publicKey.tags);
    return CardanoMultiSignatureKey._(
        signer: CardanoMultiSigSignerDetails.deserialize(
            obj: values.indexAs<CborTagValue>(0)));
  }

  List get variabels => [signer, type];

  @override
  List<Bip32AddressIndex> get keyIndexes => [signer.keyIndex];

  @override
  NativeScript get script => NativeScriptScriptPubkey(signer.keyHash);

  @override
  late final PolicyID policyId = () {
    final keyScript = NativeScriptScriptPubkey(signer.keyHash);
    return PolicyID(keyScript.toHash().data);
  }();
}

class CardanoMultiSignatureAddressDetails extends BaseCardanoAddressDetails {
  final BaseCardanoMultiSignatureCredential credential;
  final BaseCardanoMultiSignatureCredential? stakeCredential;
  List<NativeScript> get scripts =>
      [credential.script, if (stakeCredential != null) stakeCredential!.script];
  List<Bip32AddressIndex> get keyIndexes =>
      [...credential.keyIndexes, ...stakeCredential?.keyIndexes ?? []];

  CardanoMultiSignatureAddressDetails._({
    required super.addressType,
    required this.credential,
    required this.stakeCredential,
  });

  factory CardanoMultiSignatureAddressDetails(
      {required ADAAddressType addressType,
      required BaseCardanoMultiSignatureCredential credential,
      required BaseCardanoMultiSignatureCredential? stakeCredential}) {
    if (credential == stakeCredential) {
      throw WalletExceptionConst.invalidAccountDeta(
          "CardanoMultiSignatureAddressDetails");
    }
    switch (addressType) {
      case ADAAddressType.byron:
      case ADAAddressType.pointer:
        throw WalletExceptionConst.invalidAccountDeta(
            "CardanoMultiSignatureAddressDetails");
      case ADAAddressType.base:
        if (stakeCredential == null) {
          throw WalletExceptionConst.invalidAccountDeta(
              "CardanoMultiSignatureAddressDetails");
        }
        break;
      case ADAAddressType.enterprise:
      case ADAAddressType.reward:
        if (stakeCredential != null) {
          throw WalletExceptionConst.invalidAccountDeta(
              "CardanoMultiSignatureAddressDetails");
        }
      default:
        throw WalletExceptionConst.invalidAccountDeta(
            "CardanoMultiSignatureAddressDetails");
    }

    return CardanoMultiSignatureAddressDetails._(
        addressType: addressType,
        credential: credential,
        stakeCredential: stakeCredential);
  }

  @override
  CborTagValue toCbor() {
    return CborTagValue(
        CborSerializable.fromDynamic([
          credential.toCbor(),
          stakeCredential?.toCbor(),
          CborIntValue(addressType.header)
        ]),
        CborTagsConst.cardanoMultiSignaturAddress);
  }

  factory CardanoMultiSignatureAddressDetails.deserialize(
      {List<int>? bytes, CborObject? obj}) {
    final CborListValue values = CborSerializable.cborTagValue(
        cborBytes: bytes,
        object: obj,
        tags: CborTagsConst.cardanoMultiSignaturAddress);

    return CardanoMultiSignatureAddressDetails._(
        credential: BaseCardanoMultiSignatureCredential.deserialize(
            obj: values.indexAs(0)),
        stakeCredential: values
            .indexMaybeAs<BaseCardanoMultiSignatureCredential, CborTagValue>(1,
                (e) => BaseCardanoMultiSignatureCredential.deserialize(obj: e)),
        addressType: ADAAddressType.fromHeader(values.valueAs(2)));
  }

  @override
  ADAAddress toAddress(ADANetwork network) {
    switch (addressType) {
      case ADAAddressType.enterprise:
        return ADAEnterpriseAddress.fromCredential(
            credential: credential.credential, network: network);
      case ADAAddressType.reward:
        return ADARewardAddress.fromCredential(
            credential: credential.credential, network: network);
      case ADAAddressType.base:
        final stake = stakeCredential;
        if (stake == null) {
          throw WalletExceptionConst.invalidAccountDeta(
              "CardanoMultiSignatureAddressDetails");
        }
        return ADABaseAddress.fromCredential(
            baseCredential: credential.credential,
            stakeCredential: stakeCredential!.credential,
            network: network);
      default:
        throw WalletExceptionConst.invalidAccountDeta(
            "CardanoMultiSignatureAddressDetails");
    }
  }

  @override
  bool get isLegacy => false;

  @override
  List<int>? get publicKey => switch (credential.type) {
        CardanoCredentialType.publicKey =>
          credential.cast<CardanoMultiSignatureKey>().signer.publicKey,
        _ => null,
      };

  @override
  List<int>? get stakePubkey => switch (stakeCredential?.type) {
        CardanoCredentialType.publicKey =>
          stakeCredential?.cast<CardanoMultiSignatureKey>().signer.publicKey,
        _ => null,
      };
  @override
  List get variabels => [credential, stakeCredential, addressType];

  @override
  PolicyID get policyId => credential.policyId;

  @override
  PolicyID? get stakePolicyId => stakeCredential?.policyId;
}
