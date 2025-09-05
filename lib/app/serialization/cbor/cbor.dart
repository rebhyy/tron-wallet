import 'package:blockchain_utils/cbor/cbor.dart';
import 'package:blockchain_utils/utils/utils.dart';
import 'package:on_chain_wallet/app/core.dart';

mixin CborSerializable {
  CborTagValue toCbor();
  static CborListValue fromDynamic(List<dynamic> objects) {
    return CborListValue.definite(
        objects.map((e) => CborObject.fromDynamic(e)).toList());
  }

  static CborListValue cborTagValue(
      {List<int>? cborBytes,
      CborObject? object,
      String? hex,
      List<int>? tags}) {
    assert(cborBytes != null || object != null || hex != null,
        "cbor bytes or cbor object must not be null");
    if (object == null) {
      cborBytes ??= BytesUtils.tryFromHexString(hex);
      if (cborBytes == null) {
        throw AppSerializationException(
            objectName: "CborSerializable.cborTagValue");
      }
      object = CborObject.fromCbor(cborBytes);
    }

    return validateCbor(object, tags);
  }

  static T validateCbor<T extends CborObject>(
      CborObject cbor, List<int>? tags) {
    if (cbor is! CborTagValue || cbor.value is! T) {
      throw AppSerializationException(
          objectName: "CborSerializable.validateCbor");
    }
    if (tags != null && !BytesUtils.bytesEqual(cbor.tags, tags)) {
      throw AppSerializationException(
          objectName: "CborSerializable.validateCbor");
    }
    return cbor.value as T;
  }

  static T decode<T extends CborObject>(
      {List<int>? cborBytes, CborObject? object, String? hex}) {
    try {
      if (object == null) {
        cborBytes ??= BytesUtils.tryFromHexString(hex);
        if (cborBytes == null) {
          throw AppSerializationException();
        }
        object = CborObject.fromCbor(cborBytes);
      }
      if (object is! T) {
        throw AppSerializationException(objectName: "CborSerializable.decode");
      }
      return object;
    } on AppSerializationException {
      rethrow;
    } catch (_, s) {
      throw AppSerializationException(
          trace: s, objectName: "CborSerializable.decode");
    }
  }
}
typedef OnKeyValue<T> = T Function(CborObject);

extension ExtractCborMap on CborMapValue {
  Map<K, V> generateMap<K, V>(OnKeyValue<K> onKey, OnKeyValue<V> onValue) {
    final entrries = value.entries
        .map((e) => MapEntry<K, V>(onKey(e.key), onValue(e.value)));
    return Map<K, V>.fromEntries(entrries);
  }
}

extension ExtractCborList on CborListValue {
  bool isA<T extends CborObject>(int index) {
    if (index > value.length - 1) {
      if (null is T) return true;
      return false;
    }
    return value[index] is T;
  }

  List<T> elementAsListOf<T extends CborObject>(int index,
      {bool emyptyOnNull = false}) {
    if (emyptyOnNull && !hasIndex(index)) {
      return [];
    }
    try {
      return (value[index] as CborListValue).value.cast<T>();
    } catch (_, s) {
      throw AppSerializationException(
          trace: s, objectName: "ExtractCborList.elementAsListOf");
    }
  }

  Map<K, V> elementAsMap<K extends CborObject, V extends CborObject>(
      int index) {
    try {
      final CborMapValue cborValue = value[index] as CborMapValue;
      return cborValue.value.cast<K, V>();
    } catch (_, s) {
      throw AppSerializationException(
          trace: s, objectName: "ExtractCborList.elementAsMap");
    }
  }

  bool hasIndex(int index) {
    return index < value.length;
  }

  T elementAs<T>(int index) {
    if (index > value.length - 1) {
      if (null is T) return null as T;
      throw AppSerializationException(objectName: "ExtractCborList.elementAs");
    }
    try {
      final CborObject cborValue = value[index];
      if (null is T && cborValue == const CborNullValue()) {
        return null as T;
      }
      if (cborValue.value is T) {
        return cborValue.value as T;
      }
      return cborValue as T;
    } catch (_, s) {
      throw AppSerializationException(
          trace: s, objectName: "ExtractCborList.elementAs");
    }
  }

  T valueAs<T>(int index) {
    if (index > value.length - 1) {
      if (null is T) return null as T;
      throw AppSerializationException(objectName: "ExtractCborList.valueAs");
    }
    try {
      final CborObject cborValue = value[index];
      if (null is T && cborValue == const CborNullValue()) {
        return null as T;
      }
      return cborValue.value as T;
    } catch (_, s) {
      throw AppSerializationException(
          trace: s, objectName: "ExtractCborList.valueAs");
    }
  }

  T indexAs<T extends CborObject?>(int index) {
    if (index > value.length - 1) {
      if (null is T) return null as T;
      throw AppSerializationException(objectName: "ExtractCborList.indexAs");
    }
    try {
      final CborObject cborValue = value[index];
      if (null is T && cborValue == const CborNullValue()) {
        return null as T;
      }
      return cborValue as T;
    } catch (_, s) {
      throw AppSerializationException(
          trace: s, objectName: "ExtractCborList.indexAs");
    }
  }

  E? indexMaybeAs<E, T extends CborObject>(int index, E Function(T e) onValue) {
    if (index > value.length - 1) {
      return null;
    }
    try {
      final CborObject cborValue = value[index];
      if (cborValue == const CborNullValue()) {
        return null;
      }
      if (cborValue is T) {
        return onValue(cborValue);
      }
    } catch (_, s) {
      throw AppSerializationException(
          trace: s, objectName: "ExtractCborList.indexMaybeAs");
    }
    throw AppSerializationException(objectName: "ExtractCborList.indexMaybeAs");
  }

  E? elemetMybeAs<E, T>(int index, E Function(T) onValue) {
    if (index > value.length - 1) {
      return null;
    }
    try {
      final CborObject cborValue = value[index];
      if (cborValue == const CborNullValue()) {
        return null;
      }
      if (cborValue is T) {
        return onValue(cborValue as T);
      }
      return onValue(cborValue.value as T);
    } catch (_, s) {
      throw AppSerializationException(
          trace: s, objectName: "ExtractCborList.elemetMybeAs");
    }
  }

  List<T> castValue<T>() {
    return [for (int i = 0; i < value.length; i++) elementAs<T>(i)];
  }

  CborTagValue? elementAsCborTag(int index) {
    if (index > value.length - 1) return null;
    final cborValue = value[index];
    if (cborValue is CborTagValue) return cborValue;
    return null;
  }
}

extension QuickCborTag on CborTagValue {
  T valueAs<T extends CborObject>() {
    if (value is! T) {
      throw AppSerializationException(objectName: "QuickCborTag.value");
    }
    return value as T;
  }
}
