
import 'package:dlsm_pof/common/index.dart';
import 'package:sqflite/sqflite.dart';




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


  Future<List<int>> insertAll(List<T> models) async {
    final Database db = await sqfliteService.database;

    return await db.transaction((txn) async {  
      return Future.wait(
        models.map((e) => txn.insert(
          tableName,
          e.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        )).toList()
      );
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


  Future<int> deleteAll() async {
    final Database db = await sqfliteService.database;
    return await db.delete(tableName);
  }

  Future<int> count() async {
    final Database db = await sqfliteService.database;
    return Sqflite.firstIntValue( await db.rawQuery('SELECT COUNT(*) FROM $tableName') )!;
  }
}