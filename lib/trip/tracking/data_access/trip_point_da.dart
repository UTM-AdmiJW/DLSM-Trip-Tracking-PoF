import 'package:sqflite/sqflite.dart';

import '../model/trip_point.dart';

import 'package:dlsm_pof/common/index.dart';


final tripPointDAProvider = Provider<TripPointDA>((ref)=> TripPointDA(ref));



class TripPointDA extends SqfliteDA {

  static const String tableName = 'trip_points';
  static const String dropTableQuery = 'DROP TABLE IF EXISTS $tableName';
  static const String createTableQuery = '''
    CREATE TABLE $tableName (
      id INTEGER PRIMARY KEY,
      timestamp TEXT NOT NULL,
      latitude REAL NOT NULL,
      longitude REAL NOT NULL,
      speed REAL NOT NULL,
      isDistracted INTEGER NOT NULL,
      acceleration REAL NOT NULL,
      deceleration REAL NOT NULL,
      cornering REAL NOT NULL,
      totalDistance REAL NOT NULL
    )
  ''';

  TripPointDA(ProviderRef ref) : super(ref);

  @override
  Future<void> createTable(Database db) async => await db.execute(createTableQuery);
  @override
  Future<void> dropTableIfExists(Database db) async => db.execute(dropTableQuery);




  Future<int> insert(TripPoint tripPoint) async {
    final Database db = await sqfliteService.database;

    return await db.insert(
      tableName,
      tripPoint.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }


  Future<void> insertAll(List<TripPoint> tripPoints) async {
    final Database db = await sqfliteService.database;

    await db.transaction((txn) async {
      for (TripPoint tripPoint in tripPoints) {
        await txn.insert(
          tableName,
          tripPoint.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    });
  }


  Future<List<TripPoint>> selectAll() async {
    final Database db = await sqfliteService.database;

    final List<Map<String, dynamic>> maps = await db.query(tableName);

    return List.generate(maps.length, (i) {
      return TripPoint(
        id: maps[i]['id'],
        timestamp: DateTime.parse(maps[i]['timestamp']),
        latitude: maps[i]['latitude'],
        longitude: maps[i]['longitude'],
        speed: maps[i]['speed'],
        isDistracted: maps[i]['isDistracted'] == 1,
        acceleration: maps[i]['acceleration'],
        deceleration: maps[i]['deceleration'],
        cornering: maps[i]['cornering'],
        totalDistance: maps[i]['totalDistance'],
      );
    });
  }



  Future<void> deleteAll() async {
    final Database db = await sqfliteService.database;
    await db.delete(tableName);
  }


  Future<void> update(TripPoint trackingData) async {
    if (trackingData.id == null) throw Exception('Cannot update a tracking data without an id');
    
    final Database db = await sqfliteService.database;

    await db.update(
      tableName,
      trackingData.toMap(),
      where: 'id = ?',
      whereArgs: [trackingData.id],
    );
  }


  Future<int> count() async {
    final Database db = await sqfliteService.database;
    return Sqflite.firstIntValue( await db.rawQuery('SELECT COUNT(*) FROM $tableName') )!;
  }
}