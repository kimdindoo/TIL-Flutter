import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

final storage = FlutterSecureStorage();

// final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

const DEVICE_ID = 'DEVICE_ID';

const CONFIG_LIST = 'CONFIG_LIST';

const DEVICE_BATTERY = 'DEVICE_BATTERY';

class Grab {
  static int loadCellLowValue = 0;
  static int loadCellHighValue = 100;
}

class OnWalk {
  static var count;
}

class Battery {
  static var power;
}