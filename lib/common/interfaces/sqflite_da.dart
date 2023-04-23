
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';

import './riverpod_service.dart';
import '../services/sqflite_service.dart';



/// All Sqflite data access classes should extend this abstract class to ensure that in the constructor,
/// this data access class is registered with the SqfliteService automatically
/// 
/// Additionally, SqfliteDA classes should implement the createTable and dropTableIfExists methods
/// for the entity they are responsible for
abstract class SqfliteDA extends RiverpodService {

  SqfliteService get sqfliteService => ref.read(sqfliteServiceProvider);

  SqfliteDA(ProviderRef ref) : super(ref) {
    sqfliteService.registerDataAccess(this);
  }

  Future<void> createTable(Database db);
  Future<void> dropTableIfExists(Database db);
}