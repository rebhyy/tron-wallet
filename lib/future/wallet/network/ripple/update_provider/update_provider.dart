import 'package:flutter/material.dart';
import 'package:on_chain_wallet/app/core.dart';
import 'package:on_chain_wallet/future/future.dart';
import 'package:on_chain_wallet/future/state_managment/state_managment.dart';
import 'package:on_chain_wallet/future/wallet/global/pages/update_network_provider.dart';
import 'package:on_chain_wallet/wallet/wallet.dart';
import 'package:xrpl_dart/xrpl_dart.dart';

class UpdateRippleProviderView extends StatelessWidget {
  const UpdateRippleProviderView({super.key});

  @override
  Widget build(BuildContext context) {
    return NetworkAccountControllerView<XRPClient?, IXRPAddress?, XRPChain>(
        addressRequired: false,
        clientRequired: false,
        childBulder: (wallet, account, client, address, onAccountChanged) =>
            _UpdateRippleProvider(account));
  }
}

class _UpdateRippleProvider extends StatefulWidget {
  const _UpdateRippleProvider(this.account);
  final XRPChain account;

  @override
  State<_UpdateRippleProvider> createState() => _UpdateRippleProviderState();
}

class _UpdateRippleProviderState extends State<_UpdateRippleProvider>
    with
        SafeState<_UpdateRippleProvider>,
        UpdateNetworkProviderState<_UpdateRippleProvider, RippleAPIProvider,
            XRPAddress, IXRPAddress, XRPClient, TokenCore, NFTCore, XRPChain> {
  @override
  XRPChain get chain => widget.account;

  @override
  RippleAPIProvider createProvider(
      {required String url,
      required APIProviderServiceInfo service,
      ProviderAuthenticated? auth}) {
    return RippleAPIProvider(
        uri: url, identifier: APIUtils.getProviderIdentifier(), auth: auth);
  }

  @override
  late final List<ServiceProtocol> supportedProtocol;

  void init() {
    supportedProtocol = [ServiceProtocol.http, ServiceProtocol.websocket];
    protocol = supportedProtocol.first;
  }

  @override
  void onInitOnce() {
    MethodUtils.after(() async => init());
    super.onInitOnce();
  }

  @override
  Future<RippleAPIProvider> validate(RippleAPIProvider provider) async {
    final client = APIUtils.buildRippleProvider(
        provider: provider, network: network.toNetwork());
    final init = await client.onInit();
    if (!init) {
      throw AppException("ripple_provider_network_id_validator");
    }
    return provider;
  }
}
