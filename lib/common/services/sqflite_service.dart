import 'dart:async';
import 'package:path/path.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';

import './logger_service.dart';
import '../interfaces/sqflite_da.dart';



final sqfliteServiceProvider = Provider<SqfliteService>((ref) {
  Logger log = ref.watch(loggerService);
  return SqfliteService(log);
});




class SqfliteService {
  final Logger _logger;
  Database? _database;

  final List<SqfliteDA> _dataAccess = [];


  SqfliteService(this._logger);

  

  Future<Database> get database async {
    if (_database != null) return _database!;
    await _initializeDatabase();
    return _database!;
  }

  void registerDataAccess(SqfliteDA da) => _dataAccess.add(da);
  void unregisterDataAccess(SqfliteDA da) => _dataAccess.remove(da);



  Future<void> _initializeDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'dlsm.db'),
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      version: 1,
    );
  }


  void _onCreate(Database db, int version) async {
    _logger.i("Sqflite: Running onCreate() - Schema version $version.");
    await _createTables(db);
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) async {
    _logger.i("Sqflite: Running onUpgrade() - Schema version $oldVersion to $newVersion.");
    await _dropExistingTables(db);
    await _createTables(db);
  }

  Future<void> _dropExistingTables(Database db) async {
    for (SqfliteDA da in _dataAccess) {
      await da.dropTableIfExists(db);
    }
  }

  Future<void> _createTables(Database db) async {
    for (SqfliteDA da in _dataAccess) {
      await da.createTable(db);
    }
  }
}


