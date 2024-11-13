import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;

/// Checks if the device is connected to a network and has internet access.
Future<bool> hasInternetConnection() async {
  final List<ConnectivityResult> connectivityResult =
      await (Connectivity().checkConnectivity());

  if (connectivityResult.contains(ConnectivityResult.none)) {
    return false;
  }

  //  Perform a real internet connectivity check.
  try {
    // Attempt to ping a reliable server.
    final response = await http
        .get(
          Uri.parse('https://www.google.com'),
        )
        .timeout(const Duration(seconds: 3));

    if (response.statusCode == 200) {
      return true;
    }
  } catch (_) {
    // Any error will be treated as no internet connection
  }

  return false; // No internet connection
}
