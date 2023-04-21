import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';


export 'package:logger/logger.dart';


final Logger globalLogger = Logger();


final loggerServiceProvider = Provider<Logger>((ref) {
  return globalLogger;
});