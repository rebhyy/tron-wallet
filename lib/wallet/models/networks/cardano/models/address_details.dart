import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:on_chain/ada/src/models/models.dart';
import 'package:on_chain/ada/src/provider/blockfrost/models/models/utxo.dart';
import 'package:on_chain_wallet/app/core.dart';

import 'package:on_chain_wallet/wallet/constant/tags/constant.dart';
import 'package:on_chain_wallet/crypto/keys/keys.dart';
import 'package:on_chain/ada/src/address/address.dart';

abstract class BaseCardanoAddressDetails with Equatable, CborSerializable {
  final ADAAddressType addressType;
  abstract final List<int>? publicKey;
  abstract final List<int>? stakePubkey;
  BaseCardanoAddressDetails({required this.addressType});
  ADAAddress toAddress(ADANetwork network);
  late final String? publicKeyHex = BytesUtils.tryToHexString(publicKey);
  bool get isLegacy;
  PolicyID get policyId;
  PolicyID? get stakePolicyId;
}

final class CardanoAddrDetails extends BaseCardanoAddressDetails {
  @override
  final List<int> publicKey;
  @override
  final List<int>? stakePubkey;
  final List<int>? chainCode;
  final List<int>? hdPathKey;

  @override
  late final PolicyID policyId = () {
    final keyHash = Ed25519KeyHash.fromPubkey(publicKey);
    final mintScript = NativeScriptScriptPubkey(keyHash);
    return PolicyID(mintScript.toHash().data);
  }();
  @override
  late final PolicyID? stakePolicyId = () {
    final stakePubkey = this.stakePubkey;
    if (stakePubkey == null) return null;
    final keyHash = Ed25519KeyHash.fromPubkey(stakePubkey);
    final mintScript = NativeScriptScriptPubkey(keyHash);
    return PolicyID(mintScript.toHash().data);
  }();

  @override
  bool get isLegacy => hdPath != null;
  final String? hdPath;
  late final String? hdPathKeyHex = BytesUtils.tryToHexString(hdPathKey);
  factory CardanoAddrDetails.deserialize({List<int>? bytes, CborObject? obj}) {
    final CborListValue cbor = CborSerializable.cborTagValue(
        cborBytes: bytes,
        object: obj,
        tags: CborTagsConst.cardanoAccountDetails);
    return CardanoAddrDetails._(
        publicKey: cbor.elementAs(0),
        addressType: ADAAddressType.fromHeader(cbor.elementAs(1)),
        stakePubkey: cbor.elementAs(2),
        chainCode: cbor.elementAs(3),
        hdPathKey: cbor.elementAs(4),
        hdPath: cbor.elementAs(5));
  }
  CardanoAddrDetails._({
    required List<int> publicKey,
    required super.addressType,
    List<int>? stakePubkey,
    List<int>? chainCode,
    List<int>? hdPathKey,
    this.hdPath,
  })  : publicKey = publicKey.asImmutableBytes,
        stakePubkey = stakePubkey?.asImmutableBytes,
        chainCode = chainCode?.asImmutableBytes,
        hdPathKey = hdPathKey?.asImmutableBytes;
  factory CardanoAddrDetails.shelley(
      {required List<int> publicKey,
      required ADAAddressType addressType,
      required SeedTypes seedGeneration,
      List<int>? stakePubkey}) {
    if (addressType == ADAAddressType.byron ||
        addressType == ADAAddressType.pointer) {
      throw WalletExceptionConst.invalidAccountDeta(
          "CardanoAddrDetails.shelley");
    }
    if (addressType == ADAAddressType.base && stakePubkey == null) {
      throw WalletExceptionConst.invalidAccountDeta(
          "CardanoAddrDetails.shelley");
    }
    if (addressType != ADAAddressType.base && stakePubkey != null) {
      throw WalletExceptionConst.invalidAccountDeta(
          "CardanoAddrDetails.shelley");
    }
    return CardanoAddrDetails._(
        publicKey: publicKey,
        addressType: addressType,
        stakePubkey: stakePubkey);
  }
  factory CardanoAddrDetails.byron(
      {required List<int> publicKey,
      required List<int> chainCode,
      required SeedTypes seedGeneration,
      List<int>? hdPathKey,
      String? hdPath}) {
    if (hdPath != null && hdPathKey == null ||
        hdPath == null && hdPathKey != null) {
      throw WalletExceptionConst.invalidAccountDeta("CardanoAddrDetails.byron");
    }
    return CardanoAddrDetails._(
        publicKey: publicKey,
        addressType: ADAAddressType.byron,
        hdPathKey: hdPathKey,
        chainCode: chainCode,
        hdPath: hdPath);
  }

  @override
  ADAAddress toAddress(ADANetwork network) {
    switch (addressType) {
      case ADAAddressType.base:
        return ADABaseAddress.fromPublicKey(
            basePubkeyBytes: publicKey,
            stakePubkeyBytes: stakePubkey!,
            network: network);
      case ADAAddressType.enterprise:
        return ADAEnterpriseAddress.fromPublicKey(
            pubkeyBytes: publicKey, network: network);
      case ADAAddressType.reward:
        return ADARewardAddress.fromPublicKey(
            pubkeyBytes: publicKey, network: network);
      case ADAAddressType.byron:
        return ADAByronAddress.fromPublicKey(
            publicKey: publicKey,
            chaincode: chainCode!,
            hdPath: hdPath,
            hdPathKey: hdPathKey,
            network: network);
      default:
        throw WalletExceptionConst.invalidAccountDeta(
            "CardanoAddrDetails.toAddress");
    }
  }

  @override
  CborTagValue toCbor() {
    return CborTagValue(
        CborSerializable.fromDynamic([
          CborBytesValue(publicKey),
          CborIntValue(addressType.header),
          stakePubkey == null
              ? const CborNullValue()
              : CborBytesValue(stakePubkey!),
          chainCode == null
              ? const CborNullValue()
              : CborBytesValue(chainCode!),
          hdPathKey == null
              ? const CborNullValue()
              : CborBytesValue(hdPathKey!),
          hdPath == null ? const CborNullValue() : CborStringValue(hdPath!),
        ]),
        CborTagsConst.cardanoAccountDetails);
  }

  @override
  List get variabels =>
      [publicKey, hdPath, hdPathKeyHex, chainCode, addressType];
}

class ADAAddressUtxo with CborSerializable, Equality {
  final TransactionInput input;
  final TransactionOutput output;
  MultiAsset get asset => output.amount.multiAsset ?? MultiAsset.empty;
  final BigInt lovelace;
  const ADAAddressUtxo(
      {required this.input, required this.lovelace, required this.output});
  factory ADAAddressUtxo.fromUtxo(
      ADAAccountUTXOResponse utxo, TransactionOutput output) {
    return ADAAddressUtxo(
        input: utxo.toInput, lovelace: utxo.sumOflovelace, output: output);
  }

  factory ADAAddressUtxo.deserialize({List<int>? bytes, CborObject? obj}) {
    final CborListValue values = CborSerializable.cborTagValue(
        cborBytes: bytes, object: obj, tags: CborTagsConst.cardanoAddressUtxo);
    return ADAAddressUtxo(
      input: TransactionInput.deserialize(values.indexAs(0)),
      lovelace: values.valueAs(1),
      output: TransactionOutput.deserialize(values.indexAs(2)),
    );
  }

  @override
  CborTagValue<CborObject> toCbor() {
    return CborTagValue(
        CborListValue<CborObject>.definite(
            [input.toCbor(), CborBigIntValue(lovelace), output.toCbor()]),
        CborTagsConst.cardanoAddressUtxo);
  }

  @override
  List get variabels => [input];

  TransactionUnspentOutput get transactionUnspentOutput =>
      TransactionUnspentOutput(output: output, input: input);
}

class ADAAddressUtxos with CborSerializable {
  Set<ADAAddressUtxo> _utxos = {};
  Set<ADAAddressUtxo> get utxos => _utxos;
  BigInt _totalLovelace = BigInt.zero;
  MultiAsset _totalAssets = MultiAsset.empty;
  BigInt get totalLovelace => _totalLovelace;
  MultiAsset get totalAssets => _totalAssets;

  List<TransactionInput> get utxosInputs => _utxos.map((e) => e.input).toList();

  List<TransactionUnspentOutput> get transactionUnspentOutputs =>
      _utxos.map((e) => e.transactionUnspentOutput).toList();
  ADAAddressUtxos._({List<ADAAddressUtxo> utxos = const []})
      : _utxos = utxos.toImutableSet,
        _totalLovelace =
            utxos.fold<BigInt>(BigInt.zero, (p, c) => p + c.lovelace),
        _totalAssets =
            utxos.fold<MultiAsset>(MultiAsset.empty, (p, c) => p + c.asset);
  factory ADAAddressUtxos({List<ADAAddressUtxo> utxos = const []}) {
    final sort = utxos.clone()
      ..sort((a, b) => "${a.input.txIdHex}_${a.input.index}"
          .compareTo("${b.input.txIdHex}_${b.input.index}"));
    return ADAAddressUtxos._(utxos: sort);
  }

  void _updateTotal() {
    _totalLovelace = _utxos.fold<BigInt>(BigInt.zero, (p, c) => p + c.lovelace);
    _totalAssets =
        _utxos.fold<MultiAsset>(MultiAsset.empty, (p, c) => p + c.asset);
  }

  bool updateUtxos(Iterable<ADAAddressUtxo> utxos) {
    final sort = utxos.toList()
      ..sort((a, b) => "${a.input.txIdHex}_${a.input.index}"
          .compareTo("${b.input.txIdHex}_${b.input.index}"));
    if (CompareUtils.iterableIsEqual(sort, _utxos)) {
      return false;
    }
    _utxos = sort.toImutableSet;
    _updateTotal();
    return true;
  }

  factory ADAAddressUtxos.deserialize({List<int>? bytes, CborObject? obj}) {
    final CborListValue values = CborSerializable.cborTagValue(
        cborBytes: bytes, object: obj, tags: CborTagsConst.cardanoAddressUtxos);
    return ADAAddressUtxos(
        utxos: values
            .elementAsListOf<CborTagValue>(0)
            .map((e) => ADAAddressUtxo.deserialize(obj: e))
            .toList());
  }

  @override
  CborTagValue<CborObject> toCbor() {
    return CborTagValue(
        CborListValue<CborObject>.definite(
            [CborListValue.definite(_utxos.map((e) => e.toCbor()).toList())]),
        CborTagsConst.cardanoAddressUtxos);
  }
}

class ADAAddressUtxoWithOutput {
  final ADAAccountUTXOResponse utxo;
  final TransactionOutput output;
  const ADAAddressUtxoWithOutput({required this.utxo, required this.output});
}
