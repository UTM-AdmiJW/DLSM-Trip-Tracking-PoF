import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';


export 'package:logger/logger.dart';


final loggerService = Provider<Logger>((ref) {
  return Logger();
});