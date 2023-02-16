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

class Gyro {
  static double x = 0.0;
  static double y = 0.0;

  static double acc_x = 0.0;
  static double acc_y = 0.0;
  static double acc_z = 0.0;

  static double GRAVITY_EARTH = 9.80665;
  static int BMI2_GYR_RANGE_2000 = 0;

  static List<double> dataXY = [0.0, 0.0];
  static List<double> accXYZ = [0.0, 0.0, 0.0];
}
