import 'package:blockchain_utils/bip/bip.dart';
import 'package:blockchain_utils/cbor/cbor.dart';
import 'package:blockchain_utils/helper/helper.dart';

import 'package:blockchain_utils/utils/binary/utils.dart';
import 'package:cosmos_sdk/cosmos_sdk.dart';
import 'package:monero_dart/monero_dart.dart';
import 'package:on_chain_wallet/app/error/exception/app_exception.dart';
import 'package:on_chain_wallet/app/error/exception/wallet_ex.dart';
import 'package:on_chain_wallet/app/serialization/serialization.dart';
import 'package:on_chain_wallet/crypto/keys/access/crypto_keys/crypto_keys.dart';
import 'signing_response.dart';

typedef OnSignRequest = Future<GlobalSignResponse> Function(SignRequest);

abstract final class SignRequest with CborSerializable {
  final AddressDerivationIndex index;
  final SigningRequestMode network;
  const SignRequest({required this.index, required this.network});
  factory SignRequest.deserialize(
      {List<int>? bytes, CborObject? object, String? hex}) {
    final CborTagValue tag =
        CborSerializable.decode(cborBytes: bytes, hex: hex, object: object);
    final network = SigningRequestMode.fromTag(tag.tags);
    return switch (network) {
      SigningRequestMode.bitcoin ||
      SigningRequestMode.bitcoinCash =>
        BitcoinSigning.deserialize(object: tag),
      SigningRequestMode.cosmos =>
        CosmosSigningRequest.deserialize(object: tag),
      SigningRequestMode.monero =>
        MoneroSigningRequest.deserialize(object: tag),
      _ => GlobalSignRequest.deserialize(object: tag)
    };
  }
  T cast<T extends SignRequest>() {
    if (this is! T) {
      throw AppCryptoExceptionConst.internalError("SignRequest");
    }
    return this as T;
  }
}

enum SigningRequestMode {
  bitcoin([32, 100]),
  eth([32, 101]),
  ripple([32, 102]),
  cardano([32, 103]),
  ton([32, 104]),
  cosmos([32, 105]),
  solana([32, 106]),
  tron([32, 107]),
  substrate([32, 108]),
  stellar([32, 109]),
  monero([32, 110]),
  bitcoinCash([32, 111]),
  aptos([32, 112]),
  sui([32, 113]),
  moneroSpendKey([32, 114]);

  final List<int> tag;
  const SigningRequestMode(this.tag);
  static SigningRequestMode fromTag(List<int> tag) {
    return values.firstWhere(
        (element) => BytesUtils.bytesEqual(tag, element.tag),
        orElse: () =>
            throw AppSerializationException(objectName: "SigningRequestMode"));
  }
}

final class BitcoinSigning extends GlobalSignRequest {
  final int? sighash;
  final bool useTaproot;
  final bool useBchSchnorr;
  BitcoinSigning(
      {required super.digest,
      this.sighash,
      required this.useTaproot,
      required Bip32AddressIndex super.index,
      required super.network,
      required this.useBchSchnorr})
      : assert(
            network == SigningRequestMode.bitcoin ||
                network == SigningRequestMode.bitcoinCash,
            "invalid bitcoin network."),
        super._();

  factory BitcoinSigning.deserialize({
    List<int>? bytes,
    CborObject? object,
    String? hex,
  }) {
    final CborTagValue tag =
        CborSerializable.decode(cborBytes: bytes, object: object, hex: hex);
    final network = SigningRequestMode.fromTag(tag.tags);
    if (network != SigningRequestMode.bitcoin &&
        network != SigningRequestMode.bitcoinCash) {
      throw AppCryptoExceptionConst.internalError("BitcoinSigning");
    }
    final CborListValue values = tag.valueAs();
    return BitcoinSigning(
        digest: values.elementAs(1),
        sighash: values.elementAs(2),
        useTaproot: values.elementAs(3),
        index: Bip32AddressIndex.deserialize(obj: values.elementAsCborTag(0)),
        network: network,
        useBchSchnorr: values.elementAs(4));
  }
  @override
  CborTagValue toCbor() {
    return CborTagValue(
        CborSerializable.fromDynamic(
            [index.toCbor(), digest, sighash, useTaproot, useBchSchnorr]),
        network.tag);
  }
}

final class GlobalSignRequest extends SignRequest {
  final List<int> digest;
  GlobalSignRequest._({
    required List<int> digest,
    required super.network,
    required super.index,
  }) : digest = digest.asImmutableBytes;

  factory GlobalSignRequest.deserialize({
    List<int>? bytes,
    CborObject? object,
    String? hex,
  }) {
    final CborTagValue tag =
        CborSerializable.decode(cborBytes: bytes, hex: hex, object: object);
    final CborListValue values = tag.valueAs();
    final index =
        AddressDerivationIndex.deserialize(obj: values.elementAsCborTag(0));
    final List<int> digest = values.elementAs(1);
    final network = SigningRequestMode.fromTag(tag.tags);
    return GlobalSignRequest._(digest: digest, network: network, index: index);
  }

  factory GlobalSignRequest.eth({
    required List<int> digest,
    required Bip32AddressIndex index,
  }) {
    return GlobalSignRequest._(
        digest: digest, network: SigningRequestMode.eth, index: index);
  }
  factory GlobalSignRequest.ripple({
    required List<int> digest,
    required Bip32AddressIndex index,
  }) {
    return GlobalSignRequest._(
        digest: digest, network: SigningRequestMode.ripple, index: index);
  }
  factory GlobalSignRequest.tron({
    required List<int> digest,
    required Bip32AddressIndex index,
  }) {
    return GlobalSignRequest._(
        digest: digest, network: SigningRequestMode.tron, index: index);
  }
  factory GlobalSignRequest.solana({
    required List<int> digest,
    required Bip32AddressIndex index,
  }) {
    return GlobalSignRequest._(
        digest: digest, network: SigningRequestMode.solana, index: index);
  }
  factory GlobalSignRequest.aptos(
      {required List<int> digest, required Bip32AddressIndex index}) {
    return GlobalSignRequest._(
        digest: digest, network: SigningRequestMode.aptos, index: index);
  }
  factory GlobalSignRequest.sui({
    required List<int> digest,
    required Bip32AddressIndex index,
  }) {
    return GlobalSignRequest._(
        digest: digest, network: SigningRequestMode.sui, index: index);
  }
  factory GlobalSignRequest.stellar(
      {required List<int> digest, required Bip32AddressIndex index}) {
    return GlobalSignRequest._(
        digest: digest, network: SigningRequestMode.stellar, index: index);
  }
  factory GlobalSignRequest.moneroSpendKey(
      {required List<int> digest, required Bip32AddressIndex index}) {
    return GlobalSignRequest._(
        digest: digest,
        network: SigningRequestMode.moneroSpendKey,
        index: index);
  }
  factory GlobalSignRequest.ton({
    required List<int> digest,
    required Bip32AddressIndex index,
  }) {
    return GlobalSignRequest._(
        digest: digest, network: SigningRequestMode.ton, index: index);
  }
  factory GlobalSignRequest.cardano({
    required List<int> digest,
    required Bip32AddressIndex index,
  }) {
    return GlobalSignRequest._(
        digest: digest, network: SigningRequestMode.cardano, index: index);
  }
  factory GlobalSignRequest.substrate(
      {required List<int> digest, required AddressDerivationIndex index}) {
    if (index.isMultiSig) {
      throw AppCryptoExceptionConst.multiSigDerivationNotSuported;
    }
    return GlobalSignRequest._(
        digest: digest, network: SigningRequestMode.substrate, index: index);
  }

  @override
  CborTagValue toCbor() {
    return CborTagValue(
        CborSerializable.fromDynamic([index.toCbor(), digest]), network.tag);
  }
}

final class CosmosSigningRequest extends SignRequest {
  final List<int> digest;
  final CosmosKeysAlgs alg;
  CosmosSigningRequest._({
    required List<int> digest,
    required super.network,
    required super.index,
    required this.alg,
  }) : digest = digest.asImmutableBytes;
  factory CosmosSigningRequest({
    required List<int> digest,
    required AddressDerivationIndex index,
    required CosmosKeysAlgs alg,
  }) {
    if (!CosmosKeysAlgs.supportedAlgs.contains(alg)) {
      throw AppCryptoExceptionConst.internalError("CosmosSigningRequest");
    }
    if (alg.coin(ChainType.mainnet).conf.type != index.currencyCoin.conf.type) {
      throw AppCryptoExceptionConst.internalError("CosmosSigningRequest");
    }
    return CosmosSigningRequest._(
        digest: digest,
        network: SigningRequestMode.cosmos,
        index: index,
        alg: alg);
  }
  factory CosmosSigningRequest.deserialize(
      {List<int>? bytes, CborObject? object, String? hex}) {
    final CborListValue values = CborSerializable.cborTagValue(
        cborBytes: bytes,
        hex: hex,
        object: object,
        tags: SigningRequestMode.cosmos.tag);
    final index =
        AddressDerivationIndex.deserialize(obj: values.elementAsCborTag(0));
    final List<int> digest = values.elementAs(1);
    final CosmosKeysAlgs alg = CosmosKeysAlgs.fromName(values.elementAs(2));
    return CosmosSigningRequest(digest: digest, index: index, alg: alg);
  }

  @override
  CborTagValue toCbor() {
    return CborTagValue(
        CborSerializable.fromDynamic([index.toCbor(), digest, alg.name]),
        network.tag);
  }
}

final class MoneroSigningRequest extends SignRequest {
  final List<MoneroTxDestination> destinations;
  final BigInt fee;
  final MoneroTxDestination? change;
  final List<SpendablePayment<MoneroLockedPayment>> utxos;
  final bool withProof;

  MoneroSigningRequest(
      {required List<MoneroTxDestination> destinations,
      required this.fee,
      this.change,
      required List<SpendablePayment<MoneroLockedPayment>> utxos,
      required super.index,
      this.withProof = false})
      : destinations = destinations.immutable,
        utxos = utxos.immutable,
        super(network: SigningRequestMode.monero);
  factory MoneroSigningRequest.deserialize(
      {List<int>? bytes, CborObject? object, String? hex}) {
    final CborListValue values = CborSerializable.cborTagValue(
        cborBytes: bytes,
        object: object,
        hex: hex,
        tags: SigningRequestMode.monero.tag);

    return MoneroSigningRequest(
        index: Bip32AddressIndex.deserialize(obj: values.elementAsCborTag(0)),
        destinations: values
            .elementAsListOf<CborBytesValue>(1)
            .map((e) => MoneroTxDestination.deserialize(e.value))
            .toList(),
        fee: values.elementAs(2),
        change: values.elemetMybeAs<MoneroTxDestination, CborBytesValue>(
            3, (e) => MoneroTxDestination.deserialize(e.value)),
        utxos: values
            .elementAsListOf<CborBytesValue>(4)
            .map((e) =>
                SpendablePayment<MoneroLockedPayment>.deserialize(e.value))
            .toList()
            .cast(),
        withProof: values.elementAs(5));
  }

  List<MoneroAccountIndex> getAccountsIndexes() {
    return utxos.map((e) => e.payment.output.accountIndex).toSet().toList();
  }

  @override
  CborTagValue toCbor() {
    return CborTagValue(
        CborSerializable.fromDynamic([
          index.toCbor(),
          CborSerializable.fromDynamic(
              destinations.map((e) => CborBytesValue(e.serialize())).toList()),
          fee,
          change == null
              ? const CborNullValue()
              : CborBytesValue(change!.serialize()),
          CborSerializable.fromDynamic(
              utxos.map((e) => CborBytesValue(e.serialize())).toList()),
          withProof
        ]),
        network.tag);
  }
}
