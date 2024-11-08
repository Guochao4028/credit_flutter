// ignore: depend_on_referenced_packages
import 'package:logger/logger.dart';

class Log {

  static final Logger _logger = Logger(
    printer: PrefixPrinter(PrettyPrinter()),
  );

  static void v(dynamic message) {
    // var now = DateTime.now();
    // _logger.v("$now $message");
    _logger.v(message);
  }

  static void d(dynamic message) {
    // var now = DateTime.now();
    // _logger.d("$now $message");
    _logger.d(message);
  }

  static void i(dynamic message) {
    // var now = DateTime.now();
    // _logger.i("$now $message");
    _logger.i(message);
  }

  static void w(dynamic message) {
    // var now = DateTime.now();
    // _logger.w("$now $message");
    _logger.w(message);
  }

  static void e(dynamic message) {
    // var now = DateTime.now();
    // _logger.e("$now $message");
    _logger.e(message);
  }

  static void wtf(dynamic message) {
    // var now = DateTime.now();
    // _logger.wtf("$now $message");
    _logger.wtf(message);
  }
}
