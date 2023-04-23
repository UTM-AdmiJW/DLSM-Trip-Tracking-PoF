import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';


// A specific type of Riverpod service that is a implementation of a TaskHandler from the FlutterForegroundTask package
abstract class RiverpodTaskHandlerService extends TaskHandler {
  final ProviderRef ref;

  RiverpodTaskHandlerService(this.ref);
}