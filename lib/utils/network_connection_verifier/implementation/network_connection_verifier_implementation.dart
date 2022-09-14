import 'package:connectivity_plus/connectivity_plus.dart';

import '../network_connection_verifier.dart';

class NetworkConnectionVerifierImplementation implements NetworkConnectionVerifier {
  final Connectivity connectivity;

  const NetworkConnectionVerifierImplementation(this.connectivity);

  @override
  Future<bool> get hasActiveInternetConnection async {
    final status = await connectivity.checkConnectivity();
    return status != ConnectivityResult.none;
  }
}
