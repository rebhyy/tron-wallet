import 'package:on_chain_wallet/app/core.dart';

class RPCURL {
  final String url;
  final ProviderAuthenticated? auth;

  const RPCURL._(this.url, this.auth);
  factory RPCURL({required String url, ProviderAuthenticated? auth}) {
    final Uri? uri = Uri.tryParse(url);
    if (uri == null) {
      throw ApiProviderExceptionConst.invalidRequestUrl;
    }
    return RPCURL._(url, auth);
  }
}
