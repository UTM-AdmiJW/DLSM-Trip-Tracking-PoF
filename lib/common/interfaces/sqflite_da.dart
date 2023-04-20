
import 'package:sqflite/sqflite.dart';

import '../services/sqflite_service.dart';


abstract class SqfliteDA {

  final SqfliteService sqfliteService;

  SqfliteDA(this.sqfliteService) {
    sqfliteService.registerDataAccess(this);
  }

  Future<void> createTable(Database db);
  Future<void> dropTableIfExists(Database db);
}