
import 'dart:async';
import 'package:logger/logger.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../abstract/riverpod_service.dart';
import '../abstract/sqflite_da.dart';
import '../services/logger_service.dart';

import 'package:dlsm_pof/trip/index.dart';




const version = 1;


final sqfliteServiceProvider = Provider<SqfliteService>((ref) => SqfliteService(ref));




class SqfliteService extends RiverpodService {

  // Register all data access providers here
  static final List<Provider<SqfliteDA>> _dataAccess = [
    ongoingTripPointDAProvider,
    historyTripDAProvider,
    historyTripPointDAProvider,
  ];
  
  Database? _database;

  SqfliteService(ProviderRef ref) : super(ref);

  Logger get _logger => ref.read(loggerServiceProvider);


  Future<Database> get database async {
    if (_database != null) return _database!;
    await _initializeDatabase();
    return _database!;
  }


  Future<void> _initializeDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'dlsm.db'),
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      onConfigure: _onConfigure,
      version: version,
    );
  }

  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }


  Future<void> _onCreate(Database db, int version) async {
    await _createTables(db);
  }


  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    await _dropExistingTables(db);
    await _createTables(db);
  }


  Future<void> _dropExistingTables(Database db) async {
    for (Provider<SqfliteDA> daProvider in _dataAccess) {
      SqfliteDA da = ref.read(daProvider);
      await da.dropTableIfExists(db);
      _logger.i('Dropped table ${da.tableName}');
    }
  }
  

  Future<void> _createTables(Database db) async {
    for (Provider<SqfliteDA> daProvider in _dataAccess) {
      SqfliteDA da = ref.read(daProvider);
      await da.createTable(db);
      _logger.i('Created table ${da.tableName}');
    }
  }
}
