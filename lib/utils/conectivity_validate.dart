import 'package:connectivity/connectivity.dart';

Future<bool> connectivityValidate() async {
  var conectivity = await Connectivity().checkConnectivity();
  if (conectivity != ConnectivityResult.wifi &&
      conectivity != ConnectivityResult.mobile) {
    return false;
  } else {
    return true;
  }
}
