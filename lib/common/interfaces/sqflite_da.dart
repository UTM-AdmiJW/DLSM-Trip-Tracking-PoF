
import 'package:dlsm_pof/common/index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';

import 'sqflite_model.dart';
import 'riverpod_service.dart';
import '../services/sqflite_service.dart';



/// All Sqflite data access classes should extend this abstract class to ensure that in the constructor,
/// this data access class is registered with the SqfliteService automatically
/// 
abstract class SqfliteDA<T extends SqfliteModel> extends RiverpodService {

  SqfliteService get sqfliteService => ref.read(sqfliteServiceProvider);

  String get tableName;
  String get createTableQuery;
  String get dropTableQuery;


  SqfliteDA(ProviderRef ref) : super(ref);

  Future<void> createTable(Database db) async => await db.execute(createTableQuery);
  Future<void> dropTableIfExists(Database db) async => db.execute(dropTableQuery);


  Future<List<T>> selectAll();

  Future<int> insert(T model) async {
    final Database db = await sqfliteService.database;

    return await db.insert(
      tableName,
      model.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }


  Future<void> insertAll(List<T> models) async {
    final Database db = await sqfliteService.database;

    await db.transaction((txn) async {
      for (T model in models) {
        await txn.insert(
          tableName,
          model.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    });
  }


  Future<int> update(T model) async {
    final Database db = await sqfliteService.database;

    return await db.update(
      tableName,
      model.toMap(),
      where: 'id = ?',
      whereArgs: [model.id],
    );
  }


  Future<void> deleteAll() async {
    final Database db = await sqfliteService.database;
    await db.delete(tableName);
  }

  Future<int> count() async {
    final Database db = await sqfliteService.database;
    return Sqflite.firstIntValue( await db.rawQuery('SELECT COUNT(*) FROM $tableName') )!;
  }
}