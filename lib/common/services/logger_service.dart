
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';



// This is a global logger instance that can be used anywhere in the app
final Logger globalLogger = Logger();

// This is a Riverpod provider that can be used to inject the global logger instance
final loggerServiceProvider = Provider<Logger>((ref)=> globalLogger);