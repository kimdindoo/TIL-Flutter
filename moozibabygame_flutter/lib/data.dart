class Grab {
  static int loadCellLowValue = 0;
  static int loadCellHighValue = 100;

  static double percentage = 0.0;
  static double kg = 0.0;
  static double lb = 0.0;

  static List<double> grabPower = [0.0, 0.0, 0.0];
}

class OnWalk {
  static var count;
}

class Battery {
  static var power;
}

class Gyro {
  static int x = 0;
  static int y = 0;

  static int acc_x = 0;
  static int acc_y = 0;
  static int acc_z = 0;

  static int sumdx = 0;
  static int sumdy = 0;

  static double GRAVITY_EARTH = 9.80665;
  static int BMI2_GYR_RANGE_2000 = 0;

  static List<int> dataXY = [0, 0];
  static List<int> accXYZ = [0, 0, 0];
}
