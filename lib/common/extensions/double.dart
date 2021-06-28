import 'dart:math';

extension Precision on double {
  double toPrecision(int fractionDigits) {
    double mod = pow(10, fractionDigits.toDouble()) as double;
    return ((this * mod).round().toDouble() / mod);
  }
}
