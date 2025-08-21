import 'package:flutter/material.dart';
import 'package:on_chain_wallet/future/future.dart';
import 'package:on_chain_wallet/future/state_managment/state_managment.dart';
import 'package:on_chain_wallet/wallet/models/access/wallet_access.dart';

import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:on_chain_wallet/app/core.dart';
import 'package:on_chain_wallet/crypto/worker.dart';

class PublicKeyDerivationView extends StatelessWidget {
  const PublicKeyDerivationView(
      {required this.controller, required this.type, super.key});
  final ScrollController controller;
  final EllipticCurveTypes type;
  // final WalletNetwork? network;
  @override
  Widget build(BuildContext context) {
    return PasswordCheckerView(
      controller: controller,
      accsess: WalletAccsessType.unlock,
      title: "generate_public_key".tr,
      onAccsess: (credential, password, network) {
        return _PublicKeyDerivationView(
            type: type, controller: controller, password: password);
      },
    );
  }
}

typedef _OnGenerateDerivation = Future<AddressDerivationIndex?> Function();

class _PublicKeyDerivationView extends StatefulWidget {
  final ScrollController controller;
  final EllipticCurveTypes type;
  final String password;
  const _PublicKeyDerivationView(
      {required this.type, required this.controller, required this.password});

  @override
  State<_PublicKeyDerivationView> createState() =>
      __PublicKeyDerivationView2State();
}

class __PublicKeyDerivationView2State extends State<_PublicKeyDerivationView>
    with SafeState<_PublicKeyDerivationView> {
  final StreamPageProgressController controller =
      StreamPageProgressController(initialStatus: StreamWidgetStatus.progress);
  List<CryptoCoins> coins = [];
  PublicKeyDerivationResult? generatedKey;
  EncryptedCustomKey? selectedCustomKey;
  bool get allowDerivation => !isImportedKey;
  bool get isImportedKey => selectedCustomKey != null;
  late CryptoCoins coin;
  bool useByronLegacyDeriavation = false;
  List<EncryptedCustomKey> importedKeys = [];
  SeedTypes seedType = SeedTypes.bip39;
  List<EncryptedCustomKey> customKeys = [];
  bool get derivationStandard => customKeyIndex == null;
  AddressDerivationIndex? customKeyIndex;
  Map<CryptoCoins, Widget> coinItems = {};
  final generateAddressKey = GlobalKey();
  AddressDerivationIndex derivationkey(CryptoCoins coin) {
    if (selectedCustomKey != null) {
      assert(customKeyIndex == null, "must be null.");
      final keyIndex = switch (coin.proposal) {
        SubstratePropoosal.substrate =>
          SubstrateAddressIndex(currencyCoin: coin as SubstrateCoins),
        _ => Bip32AddressIndex(currencyCoin: coin, seedGeneration: seedType)
      };
      return keyIndex.asImportedKey(selectedCustomKey!.id);
    }
    return customKeyIndex ?? nextDerivation;
  }

  late AddressDerivationIndex nextDerivation;

  void onChangeCustomKey(EncryptedCustomKey? newSelected) {
    if (newSelected == null) {
      selectedCustomKey = null;
    } else {
      bool canUseKey = false;
      if (newSelected.coin.conf.type == coin.conf.type) {
        selectedCustomKey = newSelected;
        canUseKey = true;
      }
      if (canUseKey) {
        customKeyIndex = null;
      } else {
        context.showAlert("unsuported_key".tr);
      }
    }
    updateState();
  }

  void onChangeDerivation(_OnGenerateDerivation onGenerateDerivation) async {
    if (derivationStandard) {
      customKeyIndex = await onGenerateDerivation();
    } else {
      customKeyIndex = null;
    }
    updateState();
  }

  Future<void> onGenerateKey() async {
    controller.progressText("generating_public_key_please_wait".tr);
    final index = derivationkey(coin);
    final publicKey =
        await context.wallet.wallet.getKeyDerivationPublicKey(index);
    if (publicKey.hasError) {
      controller.errorText(publicKey.error!.tr,
          backToIdle: false, showBackButton: true);
      return;
    }
    generatedKey = publicKey.result;
    controller.backToIdle();
  }

  void onSubmit() {
    final key = generatedKey;
    if (key == null) return;
    context.pop(key);
  }

  SeedTypes _findSeedType(CryptoCoins coin) {
    if (coin is SubstrateCoins) {
      return SeedTypes.bip39Entropy;
    }
    if (coin == CustomCoins.byronLegacy ||
        coin == CustomCoins.byronLegacyTestnet) {
      return SeedTypes.byronLegacySeed;
    }
    switch (coin) {
      case Bip44Coins.cardanoByronIcarus:
      case Bip44Coins.cardanoByronIcarusTestnet:
      case Cip1852Coins.cardanoIcarus:
      case Cip1852Coins.cardanoIcarusTestnet:
        return SeedTypes.icarus;
      default:
        return SeedTypes.bip39;
    }
  }

  void onChangeCoin(CryptoCoins? coin) {
    if (coin == null) return;
    this.coin = coin;
    useByronLegacyDeriavation = coin.proposal == CustomProposal.cip0019;
    customKeys = importedKeys.where((e) => e.canUseFor(coin)).toList();
    seedType = _findSeedType(coin);
    appLogger.debug(
        runtime: runtimeType,
        functionName: 'onChangeCoin',
        msg: "$coin: ${seedType.name}");
    if (!customKeys.contains(selectedCustomKey)) {
      selectedCustomKey = null;
    }
    customKeyIndex = null;
    nextDerivation = BipDerivationUtils.generateAccountNextKeyIndex(
        coin: coin, seedGenerationType: seedType);
    updateState();
  }

  Future<void> init() async {
    final importedKeys = await context.wallet.wallet.getImportedAccounts();
    assert(importedKeys.hasResult);
    this.importedKeys = importedKeys.resultOrNull ?? [];
    coins = CustomCoins.fromCurve(widget.type)
        .where((e) => e.conf.chainType.isMainnet)
        .toList();
    coinItems = {
      for (final i in coins)
        i: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          OneLineTextWidget(i.coinName.camelCaseToSpaced),
          Text(i.proposal.specName.camelCase,
              style: context.textTheme.bodySmall)
        ])
    };
    onChangeCoin(coins.first);
    controller.backToIdle();
  }

  void onBackButton() {
    if (generatedKey == null) return;
    generatedKey = null;
    updateState();
  }

  @override
  void onInitOnce() {
    super.onInitOnce();
    MethodUtils.after(init);
  }

  @override
  void safeDispose() {
    super.safeDispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) => onBackButton(),
      child: StreamPageProgress(
          controller: controller,
          builder: (context) {
            return CustomScrollView(
              controller: widget.controller,
              slivers: [
                SliverConstraintsBoxView(
                    padding: WidgetConstant.paddingHorizontal20,
                    sliver: SliverToBoxAdapter(
                      child: APPAnimated(
                        isActive: generatedKey == null,
                        onActive: (context) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppDropDownBottom<CryptoCoins>(
                                items: coinItems,
                                value: coin,
                                isExpanded: true,
                                isDense: false,
                                onChanged: onChangeCoin,
                                hint: "shelley_address_format".tr),
                            WidgetConstant.height20,
                            Text("derivation_path".tr,
                                style: context.textTheme.titleMedium),
                            WidgetConstant.height8,
                            ContainerWithBorder(
                                onRemove: allowDerivation ? () {} : null,
                                enableTap: false,
                                onRemoveWidget: IconButton(
                                    onPressed: () {
                                      onChangeDerivation(
                                        () async {
                                          if (useByronLegacyDeriavation) {
                                            return context.openSliverBottomSheet<
                                                    Bip32AddressIndex>(
                                                "key_derivation".tr,
                                                child:
                                                    ByronLegacyKeyDerivationView(
                                                        coin: coin,
                                                        curve: coin.conf.type));
                                          }
                                          return context
                                              .openMaxExtendSliverBottomSheet<
                                                      AddressDerivationIndex>(
                                                  "key_derivation".tr,
                                                  child: Bip32KeyDerivationView(
                                                      coin: coin,
                                                      defaultPath:
                                                          nextDerivation.hdPath,
                                                      seedGeneration: seedType),
                                                  centerContent: false);
                                        },
                                      );
                                    },
                                    icon: ConditionalWidgets<bool>(
                                        enable: derivationStandard,
                                        widgets: {
                                          true: (e) => Icon(Icons.edit,
                                              color: context
                                                  .colors.onPrimaryContainer),
                                          false: (e) => Icon(
                                              Icons.remove_circle,
                                              color: context
                                                  .colors.onPrimaryContainer)
                                        })),
                                // onRemoveIcon:,
                                child: APPAnimated(
                                    isActive: isImportedKey,
                                    onDeactive: (context) => FullWidthWrapper(
                                          key: ValueKey(
                                              customKeyIndex ?? nextDerivation),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  derivationStandard
                                                      ? "standard_derivation".tr
                                                      : "custom_derivation".tr,
                                                  style: context
                                                      .textTheme.labelLarge),
                                              AddressDrivationInfo(
                                                  customKeyIndex ??
                                                      nextDerivation)
                                            ],
                                          ),
                                        ),
                                    onActive: (context) => Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text("non_derivation".tr,
                                                style: context
                                                    .textTheme.labelLarge),
                                            Text("import_key_derivation_desc2"
                                                .tr),
                                            ErrorTextContainer(
                                                error:
                                                    "key_derivation_disabled_desc"
                                                        .tr,
                                                showErrorIcon: false)
                                          ],
                                        ))),
                            WidgetConstant.height20,
                            Text(
                              "select_creation_type".tr,
                              style: context.textTheme.titleMedium,
                            ),
                            Text("generate_from_hd_wallet".tr),
                            WidgetConstant.height8,
                            RadioGroup<EncryptedCustomKey?>(
                              groupValue: selectedCustomKey,
                              onChanged: onChangeCustomKey,
                              child: Column(
                                children: [
                                  RadioListTile<EncryptedCustomKey?>(
                                      value: null,
                                      title: Text("hd_wallet".tr),
                                      subtitle:
                                          Text("generate_from_hd_wallet".tr)),
                                  ...List.generate(customKeys.length, (index) {
                                    final key = customKeys[index];

                                    return RadioGroup<EncryptedCustomKey?>(
                                      groupValue: selectedCustomKey,
                                      onChanged: onChangeCustomKey,
                                      child: RadioListTile(
                                        value: key,
                                        title: OneLineTextWidget(
                                            key.name ?? key.publicKey),
                                        subtitle: Text("imported_at"
                                            .tr
                                            .replaceOne(
                                                key.created.toString())),
                                      ),
                                    );
                                  })
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FixedElevatedButton(
                                    key: generateAddressKey,
                                    padding: WidgetConstant.paddingVertical40,
                                    onPressed: onGenerateKey,
                                    child: Text("generate_public_key".tr))
                              ],
                            )
                          ],
                        ),
                        onDeactive: (context) => Column(children: [
                          PublicKeysDataView(pubKey: generatedKey!.viewKey),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FixedElevatedButton(
                                  padding: WidgetConstant.paddingVertical40,
                                  onPressed: onSubmit,
                                  child: Text('submit'.tr))
                            ],
                          )
                        ]),
                      ),
                    ))
              ],
            );
          }),
    );
  }
}
