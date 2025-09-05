import 'package:bitcoin_base/bitcoin_base.dart';
import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:on_chain_wallet/app/error/exception/app_exception.dart';
import 'package:on_chain_wallet/app/error/exception/wallet_ex.dart';
import 'package:on_chain_wallet/app/euqatable/equatable.dart';
import 'package:on_chain_wallet/app/serialization/cbor/cbor.dart';
import 'package:on_chain_wallet/wallet/constant/tags/constant.dart';

enum BitcoinUTXOStatus {
  mempool(0),
  comfirmed(1);

  bool get confirmed => this == comfirmed;

  final int value;
  const BitcoinUTXOStatus(this.value);
  static BitcoinUTXOStatus fromValue(int? value) {
    return values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw AppSerializationException(
          objectName: "BitcoinUTXOStatus.fromValue"),
    );
  }
}

class BitcoinUTXO with CborSerializable, Equatable {
  final String txId;
  final BigInt value;
  final int index;
  final CashToken? token;
  BitcoinUTXOStatus _status;
  BitcoinUTXOStatus get status => _status;
  BitcoinUTXO._(
      {required this.txId,
      required this.value,
      required this.index,
      required this.token,
      BitcoinUTXOStatus staus = BitcoinUTXOStatus.mempool})
      : _status = staus;
  factory BitcoinUTXO(
      {required String txId,
      required BigInt value,
      required int index,
      required CashToken? token,
      BitcoinUTXOStatus status = BitcoinUTXOStatus.mempool}) {
    assert(!value.isNegative);
    assert(!index.isNegative);
    if (value.isNegative || index.isNegative) {
      throw WalletExceptionConst.invalidAccountUtxo;
    }
    return BitcoinUTXO._(
        txId: StringUtils.normalizeHex(txId),
        value: value,
        index: index,
        token: token,
        staus: status);
  }
  factory BitcoinUTXO.deserialize(
      {CborObject? obj, List<int>? bytes, String? hex}) {
    final CborListValue values = CborSerializable.cborTagValue(
        object: obj,
        cborBytes: bytes,
        hex: hex,
        tags: CborTagsConst.bitcoinUtxo);
    return BitcoinUTXO._(
        txId: values.valueAs(0),
        value: values.valueAs(1),
        index: values.valueAs(2),
        token: values.indexMaybeAs<CashToken, CborBytesValue>(
          3,
          (e) {
            final data = CashToken.deserialize(e.value);
            final token = data.item1;
            if (token == null) {
              throw AppSerializationException(
                  objectName: "BitcoinAddressUtxo.deserialize");
            }
            return token;
          },
        ),
        staus: BitcoinUTXOStatus.fromValue(values.valueAs(4)));
  }
  @override
  CborTagValue<CborObject> toCbor() {
    return CborTagValue(
        CborListValue<CborObject>.definite([
          CborStringValue(txId),
          CborBigIntValue(value),
          CborIntValue(index),
          token == null ? CborNullValue() : CborBytesValue(token!.toBytes()),
          CborIntValue(_status.value),
        ]),
        CborTagsConst.bitcoinUtxo);
  }

  @override
  List get variabels => [txId, index];

  @override
  String toString() {
    return "txId: $txId index: $index status:${_status.name}";
  }
}

class BitcoinAddressUtxo with CborSerializable {
  Set<BitcoinUTXO> _utxos;
  Set<BitcoinUTXO> get utxos => _utxos;
  bool updateUtxos(Iterable<BitcoinUTXO> utxos) {
    _utxos = utxos.toImutableSet;
    return true;
  }

  BigInt get totalBalance {
    return _utxos.fold<BigInt>(BigInt.zero, (p, c) => p + c.value);
  }

  BitcoinAddressUtxo({Set<BitcoinUTXO> utxos = const {}})
      : _utxos = utxos.immutable;
  factory BitcoinAddressUtxo.deserialize(
      {CborObject? obj, List<int>? bytes, String? hex}) {
    final CborListValue values = CborSerializable.cborTagValue(
        object: obj,
        cborBytes: bytes,
        hex: hex,
        tags: CborTagsConst.bitcoinAddressUtxo);
    return BitcoinAddressUtxo(
      utxos: values
          .elementAsListOf<CborTagValue>(0)
          .map((e) => BitcoinUTXO.deserialize(obj: e))
          .toSet(),
    );
  }
  @override
  CborTagValue<CborObject> toCbor() {
    return CborTagValue(
        CborListValue.definite([
          CborListValue.definite(_utxos.map((e) => e.toCbor()).toList()),
        ]),
        CborTagsConst.bitcoinAddressUtxo);
  }
}
