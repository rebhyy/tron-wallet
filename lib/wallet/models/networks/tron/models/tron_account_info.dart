import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:on_chain_wallet/app/core.dart';

import 'package:on_chain_wallet/wallet/constant/tags/constant.dart';
import 'package:on_chain/tron/tron.dart';

class _TronAccountCborConst {
  static const List<int> tronAccountResource = [200, 195, 100, 1];
  static const List<int> frozenAssetsNetUsage = [200, 195, 100, 2];
  static const List<int> assetVersion2 = [200, 195, 100, 3];
  static const List<int> assetUnfreezV2 = [200, 195, 100, 4];
  static const List<int> assetFrozenV2 = [200, 195, 100, 5];
  static const List<int> frozenSupply = [200, 195, 100, 6];
  static const List<int> permissionKeys = [200, 195, 100, 7];
  static const List<int> accountPermission = [200, 195, 100, 8];
}

class TronAccountInfo with CborSerializable, Equatable {
  final String? accountName;
  final String address;
  final BigInt balance;
  final BigInt createTime;
  final BigInt? latestOperationTime;
  final List<FrozenSupply> frozenSupply;
  final String? assetIssuedName;
  final int? freeNetUsage;
  final BigInt? latestConsumeFreeTime;
  final int netWindowSize;
  final bool netWindowOptimized;
  final TronAccountResource accountResource;
  final AccountPermission ownerPermission;

  final List<AccountPermission> activePermissions;
  final AccountPermission? witnessPermission;
  final List<FrozenV2> frozenV2;
  final List<UnfrozenV2> unfrozenV2;
  final List<AssetV2> assetV2;
  final String? assetIssuedID;
  final List<FreeAssetNetUsageV2> freeAssetNetUsageV2;
  final bool assetOptimized;

  List<AccountPermission> get permissions => [
        ownerPermission,
        ...activePermissions,
        if (witnessPermission != null) witnessPermission!
      ];

  factory TronAccountInfo.deserialize({List<int>? bytes, CborObject? obj}) {
    final CborListValue cbor = CborSerializable.cborTagValue(
        cborBytes: bytes, object: obj, tags: CborTagsConst.tronAccountInfo);

    final witness = cbor.elementAs<CborTagValue?>(14);
    return TronAccountInfo._(
        accountName: cbor.elementAs(0),
        address: cbor.elementAs(1),
        balance: cbor.elementAs(2),
        createTime: cbor.elementAs(3),
        latestOperationTime: cbor.elementAs(4),
        frozenSupply: cbor
            .elementAsListOf<CborObject>(5)
            .map((e) => FrozenSupply.fromCborBytesOrObject(obj: e))
            .toList(),
        assetIssuedName: cbor.elementAs(6),
        freeNetUsage: cbor.elementAs(7),
        latestConsumeFreeTime: cbor.elementAs(8),
        netWindowSize: cbor.elementAs(9),
        netWindowOptimized: cbor.elementAs(10),
        accountResource: TronAccountResource.fromCborBytesOrObject(
            obj: cbor.elementAsCborTag(11)),
        ownerPermission: AccountPermission.fromCborBytesOrObject(
            obj: cbor.elementAsCborTag(12)),
        activePermissions: cbor
            .elementAsListOf<CborObject>(13)
            .map((e) => AccountPermission.fromCborBytesOrObject(obj: e))
            .toList(),
        witnessPermission: witness == null
            ? null
            : AccountPermission.fromCborBytesOrObject(obj: witness),
        frozenV2: cbor
            .elementAsListOf<CborObject>(15)
            .map((e) => FrozenV2.fromCborBytesOrObject(obj: e))
            .toList(),
        unfrozenV2: cbor
            .elementAsListOf<CborObject>(16)
            .map((e) => UnfrozenV2.fromCborBytesOrObject(obj: e))
            .toList(),
        assetV2: cbor
            .elementAsListOf<CborObject>(17)
            .map((e) => AssetV2.fromCborBytesOrObject(obj: e))
            .toList(),
        assetIssuedID: cbor.elementAs(18),
        freeAssetNetUsageV2: cbor
            .elementAsListOf<CborObject>(19)
            .map((e) => FreeAssetNetUsageV2.fromCborBytesOrObject(obj: e))
            .toList(),
        assetOptimized: cbor.elementAs(20));
  }

  @override
  CborTagValue toCbor() {
    return CborTagValue(
        CborSerializable.fromDynamic([
          accountName,
          address,
          balance,
          createTime,
          latestOperationTime,
          CborSerializable.fromDynamic(
              frozenSupply.map((e) => e.toCbor()).toList()),
          assetIssuedName,
          freeNetUsage,
          latestConsumeFreeTime,
          netWindowSize,
          netWindowOptimized,
          accountResource.toCbor(),
          ownerPermission.toCbor(),
          CborSerializable.fromDynamic(
              activePermissions.map((e) => e.toCbor()).toList()),
          witnessPermission?.toCbor(),
          CborSerializable.fromDynamic(
              frozenV2.map((e) => e.toCbor()).toList()),
          CborSerializable.fromDynamic(
              unfrozenV2.map((e) => e.toCbor()).toList()),
          CborSerializable.fromDynamic(assetV2.map((e) => e.toCbor()).toList()),
          assetIssuedID,
          CborSerializable.fromDynamic(
              freeAssetNetUsageV2.map((e) => e.toCbor()).toList()),
          assetOptimized
        ]),
        CborTagsConst.tronAccountInfo);
  }

  const TronAccountInfo._({
    this.accountName,
    required this.address,
    required this.balance,
    required this.createTime,
    required this.latestOperationTime,
    required this.frozenSupply,
    required this.assetIssuedName,
    required this.freeNetUsage,
    required this.latestConsumeFreeTime,
    required this.netWindowSize,
    required this.netWindowOptimized,
    required this.accountResource,
    required this.ownerPermission,
    required this.activePermissions,
    required this.witnessPermission,
    required this.frozenV2,
    required this.unfrozenV2,
    required this.assetV2,
    required this.assetIssuedID,
    required this.freeAssetNetUsageV2,
    required this.assetOptimized,
  });

  factory TronAccountInfo.fromJson(Map<String, dynamic> json) {
    return TronAccountInfo._(
      accountName: json['account_name'],
      address: json['address'],
      balance: BigintUtils.parse(json['balance'] ?? BigInt.zero),
      createTime: BigintUtils.parse(json['create_time']),
      latestOperationTime: BigintUtils.tryParse(json['latest_opration_time']),
      frozenSupply: (json['frozen_supply'] as List?)
              ?.map((supply) => FrozenSupply.fromJson(supply))
              .toList() ??
          <FrozenSupply>[],
      assetIssuedName: json['asset_issued_name'],
      freeNetUsage: json['free_net_usage'],
      latestConsumeFreeTime:
          BigintUtils.tryParse(json['latest_consume_free_time']),
      netWindowSize: json['net_window_size'],
      netWindowOptimized: json['net_window_optimized'],
      accountResource: TronAccountResource.fromJson(json['account_resource']),
      ownerPermission: json['owner_permission'] == null
          ? AccountPermission(
              type: PermissionType.owner,
              permissionName: "owner",
              threshold: BigInt.one,
              keys: [
                  PermissionKeys(
                      address: TronAddress(json['address']), weight: BigInt.one)
                ])
          : AccountPermission.fromJson(json['owner_permission']),
      activePermissions: (json['active_permission'] as List<dynamic>?)
              ?.map((permission) => AccountPermission.fromJson(permission))
              .toList() ??
          [
            AccountPermission(
                type: PermissionType.active,
                permissionName: "active",
                threshold: BigInt.one,
                keys: [
                  PermissionKeys(
                      address: TronAddress(json['address']), weight: BigInt.one)
                ])
          ],
      witnessPermission: json["witness_permission"] == null
          ? null
          : AccountPermission.fromJson(json['witness_permission']),
      frozenV2: (json['frozenV2'] as List<dynamic>)
          .map((frozen) => FrozenV2.fromJson(frozen))
          .toList(),
      unfrozenV2: (json['unfrozenV2'] as List?)
              ?.map((unfrozen) => UnfrozenV2.fromJson(unfrozen))
              .toList() ??
          <UnfrozenV2>[],
      assetV2: (json['assetV2'] as List?)
              ?.map((asset) => AssetV2.fromJson(asset))
              .toList() ??
          <AssetV2>[],
      assetIssuedID: json['asset_issued_ID'],
      freeAssetNetUsageV2: (json['free_asset_net_usageV2'] as List?)
              ?.map((usage) => FreeAssetNetUsageV2.fromJson(usage))
              .toList() ??
          <FreeAssetNetUsageV2>[],
      assetOptimized: json['asset_optimized'],
    );
  }

  @override
  List get variabels => [
        accountName,
        address,
        balance,
        createTime,
        latestOperationTime,
        frozenSupply,
        assetIssuedName,
        freeNetUsage,
        latestConsumeFreeTime,
        netWindowSize,
        netWindowOptimized,
        accountResource,
        ownerPermission,
        activePermissions,
        witnessPermission,
        frozenV2,
        unfrozenV2,
        assetV2,
        assetIssuedID,
        freeAssetNetUsageV2,
        assetOptimized
      ];
}

class AccountPermission with CborSerializable, Equatable {
  final PermissionType type;
  final int? id;
  final String? permissionName;
  final BigInt threshold;
  final String? operations;
  final List<PermissionKeys> keys;
  bool get isActivePermission => type == PermissionType.active;
  bool get isWitnessPermission => type == PermissionType.witness;
  bool get isOwner => type == PermissionType.owner;
  Permission toPermission() {
    return Permission(
        id: id,
        keys: keys
            .map((e) => TronKey(address: e.address, weight: e.weight))
            .toList(),
        operations: BytesUtils.tryFromHexString(operations),
        type: type,
        permissionName: permissionName,
        threshold: threshold);
  }

  AccountPermission clone() {
    return AccountPermission(
        type: type,
        permissionName: permissionName,
        threshold: threshold,
        id: id,
        operations: operations,
        keys: keys.map((e) => e.clone()).toList());
  }

  @override
  CborTagValue toCbor() {
    return CborTagValue(
        CborSerializable.fromDynamic([
          type.name,
          id,
          permissionName,
          threshold,
          operations,
          CborSerializable.fromDynamic(keys.map((e) => e.toCbor()).toList())
        ]),
        _TronAccountCborConst.accountPermission);
  }

  factory AccountPermission.fromCborBytesOrObject(
      {List<int>? bytes, CborObject? obj}) {
    final CborListValue cbor = CborSerializable.cborTagValue(
        cborBytes: bytes,
        object: obj,
        tags: _TronAccountCborConst.accountPermission);
    final keys = cbor
        .elementAsListOf<CborObject>(5)
        .map((e) => PermissionKeys.fromCborBytesOrObject(obj: e))
        .toList();
    return AccountPermission(
        type: PermissionType.fromName(cbor.elementAs(0),
            defaultPermission: PermissionType.owner),
        id: cbor.elementAs(1),
        permissionName: cbor.elementAs(2),
        threshold: cbor.elementAs(3),
        operations: cbor.elementAs(4),
        keys: keys);
  }

  AccountPermission({
    required this.type,
    this.id,
    required this.permissionName,
    required this.threshold,
    this.operations,
    required this.keys,
  });

  factory AccountPermission.fromJson(Map<String, dynamic> json) {
    return AccountPermission(
      type: PermissionType.fromName(json["type"],
          defaultPermission: PermissionType.owner),
      id: json['id'],
      permissionName: json['permission_name'],
      threshold: BigintUtils.parse(json['threshold']),
      operations: json['operations'],
      keys: (json['keys'] as List?)
              ?.map((e) => PermissionKeys.fromJson(e))
              .toList() ??
          <PermissionKeys>[],
    );
  }

  // CopyWith method for immutable updates
  AccountPermission copyWith({
    PermissionType? type,
    int? id,
    String? permissionName,
    BigInt? threshold,
    String? operations,
    List<PermissionKeys>? keys,
  }) {
    return AccountPermission(
      type: type ?? this.type,
      id: id ?? this.id,
      permissionName: permissionName ?? this.permissionName,
      threshold: threshold ?? this.threshold,
      operations: operations ?? this.operations,
      keys: keys ?? this.keys,
    );
  }

  @override
  List get variabels => [type, id, permissionName, threshold, operations, keys];
}

class PermissionKeys with CborSerializable, Equatable {
  PermissionKeys({required this.address, required this.weight});
  factory PermissionKeys.fromJson(Map<String, dynamic> json) {
    return PermissionKeys(
        address: TronAddress(json["address"]),
        weight: BigintUtils.parse(json["weight"]));
  }
  final TronAddress address;
  final BigInt weight;
  PermissionKeys clone() {
    return PermissionKeys(address: address, weight: weight);
  }

  @override
  CborTagValue toCbor() {
    return CborTagValue(
        CborSerializable.fromDynamic([address.toAddress(), weight]),
        _TronAccountCborConst.permissionKeys);
  }

  factory PermissionKeys.fromCborBytesOrObject(
      {List<int>? bytes, CborObject? obj}) {
    final CborListValue cbor = CborSerializable.cborTagValue(
        cborBytes: bytes,
        object: obj,
        tags: _TronAccountCborConst.permissionKeys);
    return PermissionKeys(
        address: TronAddress(cbor.elementAs(0)), weight: cbor.elementAs(1));
  }

  @override
  List get variabels => [address, weight];
}

class FrozenSupply with CborSerializable, Equatable {
  final BigInt frozenBalance;
  final BigInt expireTime;

  @override
  CborTagValue toCbor() {
    return CborTagValue(
        CborSerializable.fromDynamic([frozenBalance, expireTime]),
        _TronAccountCborConst.frozenSupply);
  }

  factory FrozenSupply.fromCborBytesOrObject(
      {List<int>? bytes, CborObject? obj}) {
    final CborListValue cbor = CborSerializable.cborTagValue(
        cborBytes: bytes,
        object: obj,
        tags: _TronAccountCborConst.frozenSupply);
    return FrozenSupply._(
        frozenBalance: cbor.elementAs(0), expireTime: cbor.elementAs(1));
  }

  FrozenSupply._({
    required this.frozenBalance,
    required this.expireTime,
  });

  factory FrozenSupply.fromJson(Map<String, dynamic> json) {
    return FrozenSupply._(
      frozenBalance: BigInt.from(json['frozen_balance']),
      expireTime: BigInt.from(json['expire_time']),
    );
  }

  @override
  List get variabels => [frozenBalance, expireTime];
}

class FrozenV2 with CborSerializable, Equatable {
  final BigInt amount;
  final ResourceCode type;
  @override
  CborTagValue toCbor() {
    return CborTagValue(CborSerializable.fromDynamic([amount, type.name]),
        _TronAccountCborConst.assetFrozenV2);
  }

  factory FrozenV2.fromCborBytesOrObject({List<int>? bytes, CborObject? obj}) {
    final CborListValue cbor = CborSerializable.cborTagValue(
        cborBytes: bytes,
        object: obj,
        tags: _TronAccountCborConst.assetFrozenV2);
    return FrozenV2._(
        type: ResourceCode.fromName(cbor.elementAs(1))!,
        amount: cbor.elementAs(0));
  }

  FrozenV2._({
    required this.amount,
    required this.type,
  });

  factory FrozenV2.fromJson(Map<String, dynamic> json) {
    return FrozenV2._(
      amount: BigintUtils.tryParse(json["amount"]) ?? BigInt.zero,
      type:
          ResourceCode.fromName(json['type'], orElse: ResourceCode.bandWidth)!,
    );
  }

  @override
  List get variabels => [amount, type];
}

class UnfrozenV2 with CborSerializable, Equatable {
  final String? type;
  final BigInt unfreezeAmount;
  final BigInt unfreezeExpireTime;

  @override
  CborTagValue toCbor() {
    return CborTagValue(
        CborSerializable.fromDynamic([
          type,
          unfreezeAmount,
          unfreezeExpireTime,
        ]),
        _TronAccountCborConst.assetUnfreezV2);
  }

  factory UnfrozenV2.fromCborBytesOrObject(
      {List<int>? bytes, CborObject? obj}) {
    final CborListValue cbor = CborSerializable.cborTagValue(
        cborBytes: bytes,
        object: obj,
        tags: _TronAccountCborConst.assetUnfreezV2);
    return UnfrozenV2._(
        type: cbor.elementAs(0),
        unfreezeAmount: cbor.elementAs(1),
        unfreezeExpireTime: cbor.elementAs(2));
  }

  UnfrozenV2._({
    required this.type,
    required this.unfreezeAmount,
    required this.unfreezeExpireTime,
  });

  factory UnfrozenV2.fromJson(Map<String, dynamic> json) {
    return UnfrozenV2._(
      type: json['type'],
      unfreezeAmount: BigintUtils.parse(json['unfreeze_amount']),
      unfreezeExpireTime: BigintUtils.parse(json['unfreeze_expire_time']),
    );
  }

  @override
  List get variabels => [type, unfreezeAmount, unfreezeExpireTime];
}

class AssetV2 with CborSerializable, Equatable {
  final String key;
  final BigInt value;

  AssetV2._({required this.key, required this.value});
  @override
  CborTagValue toCbor() {
    return CborTagValue(
        CborSerializable.fromDynamic([
          key,
          value,
        ]),
        _TronAccountCborConst.assetVersion2);
  }

  factory AssetV2.fromCborBytesOrObject({List<int>? bytes, CborObject? obj}) {
    final CborListValue cbor = CborSerializable.cborTagValue(
        cborBytes: bytes,
        object: obj,
        tags: _TronAccountCborConst.assetVersion2);
    return AssetV2._(key: cbor.elementAs(0), value: cbor.elementAs(1));
  }

  factory AssetV2.fromJson(Map<String, dynamic> json) {
    return AssetV2._(key: json['key'], value: BigintUtils.parse(json["value"]));
  }

  @override
  List get variabels => [key, value];
}

class FreeAssetNetUsageV2 with CborSerializable, Equatable {
  final String key;
  final BigInt value;

  FreeAssetNetUsageV2._({required this.key, required this.value});
  @override
  CborTagValue toCbor() {
    return CborTagValue(
        CborSerializable.fromDynamic([
          key,
          value,
        ]),
        _TronAccountCborConst.frozenAssetsNetUsage);
  }

  factory FreeAssetNetUsageV2.fromCborBytesOrObject(
      {List<int>? bytes, CborObject? obj}) {
    final CborListValue cbor = CborSerializable.cborTagValue(
        cborBytes: bytes,
        object: obj,
        tags: _TronAccountCborConst.frozenAssetsNetUsage);
    return FreeAssetNetUsageV2._(
        key: cbor.elementAs(0), value: cbor.elementAs(1));
  }

  factory FreeAssetNetUsageV2.fromJson(Map<String, dynamic> json) {
    return FreeAssetNetUsageV2._(
      key: json['key'],
      value: BigintUtils.parse(json['value']),
    );
  }

  @override
  List get variabels => [key, value];
}

class TronAccountResource with CborSerializable, Equatable {
  final int energyWindowSize;
  final BigInt? delegatedFrozenV2BalanceForEnergy;
  final bool energyWindowOptimized;

  TronAccountResource._(
      {required this.energyWindowSize,
      required this.delegatedFrozenV2BalanceForEnergy,
      required this.energyWindowOptimized});

  factory TronAccountResource.fromJson(Map<String, dynamic> json) {
    return TronAccountResource._(
      energyWindowSize: json['energy_window_size'],
      delegatedFrozenV2BalanceForEnergy:
          BigintUtils.tryParse(json['delegated_frozenV2_balance_for_energy']),
      energyWindowOptimized: json['energy_window_optimized'],
    );
  }

  @override
  String toString() {
    return '''
      TronAccountResource {
        energyWindowSize: $energyWindowSize,
        delegatedFrozenV2BalanceForEnergy: $delegatedFrozenV2BalanceForEnergy,
        energyWindowOptimized: $energyWindowOptimized
      }
    ''';
  }

  @override
  CborTagValue toCbor() {
    return CborTagValue(
        CborSerializable.fromDynamic([
          energyWindowSize,
          delegatedFrozenV2BalanceForEnergy,
          energyWindowOptimized
        ]),
        _TronAccountCborConst.tronAccountResource);
  }

  factory TronAccountResource.fromCborBytesOrObject(
      {List<int>? bytes, CborObject? obj}) {
    final CborListValue cbor = CborSerializable.cborTagValue(
        cborBytes: bytes,
        object: obj,
        tags: _TronAccountCborConst.tronAccountResource);
    return TronAccountResource._(
        energyWindowSize: cbor.elementAs(0),
        delegatedFrozenV2BalanceForEnergy: cbor.elementAs(1),
        energyWindowOptimized: cbor.elementAs(2));
  }

  @override
  List get variabels => [
        energyWindowSize,
        delegatedFrozenV2BalanceForEnergy,
        energyWindowOptimized
      ];
}

class TronAccountResourceInfo with CborSerializable, Equality {
  @override
  CborTagValue toCbor() {
    return CborTagValue(
        CborSerializable.fromDynamic([
          freeNetUsed,
          freeNetLimit,
          netLimit,
          netUsed,
          energyLimit,
          energyUsed,
          tronPowerLimit,
          tronPowerUsed,
        ]),
        CborTagsConst.tronAccountResource);
  }

  factory TronAccountResourceInfo.deserialize(
      {List<int>? bytes, CborObject? obj}) {
    final CborListValue cbor = CborSerializable.cborTagValue(
        cborBytes: bytes, object: obj, tags: CborTagsConst.tronAccountResource);
    return TronAccountResourceInfo(
      freeNetUsed: cbor.elementAs(0),
      freeNetLimit: cbor.elementAs(1),
      netLimit: cbor.elementAs(2),
      netUsed: cbor.elementAs(3),
      energyLimit: cbor.elementAs(4),
      energyUsed: cbor.elementAs(5),
      tronPowerLimit: cbor.elementAs(6),
      tronPowerUsed: cbor.elementAs(7),
    );
  }

  final BigInt freeNetUsed;
  final BigInt freeNetLimit;
  final BigInt netLimit;
  final BigInt netUsed;
  final BigInt energyLimit;
  final BigInt energyUsed;

  final int tronPowerUsed;
  final int tronPowerLimit;
  late final BigInt totalBandWith;
  late final BigInt howManyEnergy;
  late final BigInt totalBandWithUsed;
  int get howManyVote => tronPowerLimit - tronPowerUsed;
  BigInt get howManyBandwIth => totalBandWith - totalBandWithUsed;

  /// {freeNetLimit: 600, assetNetUsed: [{key: 1001470, value: 0}], assetNetLimit: [{key: 1001470, value: 0}], TotalNetLimit: 43200000000, TotalNetWeight: 84045925899, TotalEnergyLimit: 50000000000000, TotalEnergyWeight: 564732458708}
  /// {freeNetUsed: 265, freeNetLimit: 600, assetNetUsed: [{key: 1001470, value: 0}], assetNetLimit: [{key: 1001470, value: 0}], TotalNetLimit: 43200000000, TotalNetWeight: 84045925899, TotalEnergyLimit: 50000000000000, TotalEnergyWeight: 564732458708}
  TronAccountResourceInfo({
    required this.freeNetUsed,
    required this.freeNetLimit,
    required this.netLimit,
    required this.netUsed,
    required this.energyLimit,
    required this.energyUsed,
    required this.tronPowerLimit,
    required this.tronPowerUsed,
  }) {
    totalBandWith = freeNetLimit + netLimit;
    totalBandWithUsed = netUsed + freeNetUsed;
    howManyEnergy = energyLimit - energyUsed;
    if (howManyEnergy < BigInt.zero) {
      howManyEnergy = BigInt.zero;
    }
  }

  factory TronAccountResourceInfo.empty() => TronAccountResourceInfo(
      freeNetUsed: BigInt.zero,
      freeNetLimit: BigInt.zero,
      netLimit: BigInt.zero,
      netUsed: BigInt.zero,
      energyLimit: BigInt.zero,
      energyUsed: BigInt.zero,
      tronPowerLimit: 0,
      tronPowerUsed: 0);

  factory TronAccountResourceInfo.fromJson(Map<String, dynamic> json) {
    return TronAccountResourceInfo(
      freeNetLimit: BigintUtils.tryParse(json["freeNetLimit"]) ?? BigInt.zero,
      freeNetUsed: BigintUtils.tryParse(json["freeNetUsed"]) ?? BigInt.zero,
      netLimit: BigintUtils.tryParse(json["NetLimit"]) ?? BigInt.zero,
      netUsed: BigintUtils.tryParse(json["NetUsed"]) ?? BigInt.zero,
      energyUsed: BigintUtils.tryParse(json["EnergyUsed"]) ?? BigInt.zero,
      energyLimit: BigintUtils.tryParse(json["EnergyLimit"]) ?? BigInt.zero,
      tronPowerUsed: json["tronPowerUsed"] ?? 0,
      tronPowerLimit: json["tronPowerLimit"] ?? 0,
    );
  }

  @override
  String toString() {
    return '''
      TronAccountResource {
        freeNetUsed: $freeNetUsed,
        freeNetLimit: $freeNetLimit,
        netLimit: $netLimit,
        netUsed: $netUsed,
        energyLimit: $energyLimit,
        energyUsed: $energyUsed,
        totalBandWith: $totalBandWith,
        totalBandWithUsed: $totalBandWithUsed,
        tronPowerUsed: $tronPowerUsed,
        tronPowerLimit: $tronPowerLimit,
        howManyVote: $howManyVote,
        howManyBandwIth: $howManyBandwIth,
        howManyEnergy: $howManyEnergy,
      }
    ''';
  }

  Map<String, dynamic> toJson() {
    return {
      "freeNetLimit": freeNetLimit,
      "freeNetUsed": freeNetUsed,
      "NetLimit": netLimit,
      "NetUsed": netUsed,
      "EnergyUsed": energyUsed,
      "EnergyLimit": energyLimit,
    };
  }

  @override
  List get variabels => [
        freeNetUsed,
        freeNetLimit,
        netLimit,
        netUsed,
        energyLimit,
        energyUsed,
        tronPowerLimit,
        tronPowerUsed
      ];
}

class TronAccountData {
  final TronAccountResourceInfo? resource;
  final TronAccountInfo? accountInfo;
  const TronAccountData({this.resource, this.accountInfo});
  BigInt get balance => accountInfo?.balance ?? BigInt.zero;
}
