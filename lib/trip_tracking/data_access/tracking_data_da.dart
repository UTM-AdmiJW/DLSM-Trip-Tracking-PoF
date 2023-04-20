import 'package:sqflite/sqflite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/tracking_data.dart';

import 'package:dlsm_pof/common/index.dart';


final trackingDataDAProvider = Provider<TrackingDataDA>((ref) {
  SqfliteService sqfliteService = ref.watch(sqfliteServiceProvider);
  return TrackingDataDA(sqfliteService);
});




class TrackingDataDA extends SqfliteDA {

  static const String tableName = 'trackingData';
  static const String dropTableQuery = 'DROP TABLE IF EXISTS $tableName';
  static const String createTableQuery = '''
    CREATE TABLE $tableName (
      id INTEGER PRIMARY KEY,
      timestamp TEXT NOT NULL,
      latitude REAL NOT NULL,
      longitude REAL NOT NULL,
      speed REAL NOT NULL,
      activity TEXT NOT NULL
    )
  ''';


  TrackingDataDA(SqfliteService sqfliteService) : super(sqfliteService);


  @override
  Future<void> createTable(Database db) async {
    await db.execute(createTableQuery);
  }

  @override
  Future<void> dropTableIfExists(Database db) async {
    await db.execute(dropTableQuery);
  }



  Future<int> insertTrackingData(TrackingData trackingData) async {
    final Database db = await sqfliteService.database;

    return await db.insert(
      tableName,
      trackingData.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<TrackingData>> getAllTrackingData() async {
    final Database db = await sqfliteService.database;

    final List<Map<String, dynamic>> maps = await db.query(tableName);

    return List.generate(maps.length, (i) {
      return TrackingData(
        id: maps[i]['id'],
        timestamp: DateTime.parse(maps[i]['timestamp']),
        latitude: maps[i]['latitude'],
        longitude: maps[i]['longitude'],
        speed: maps[i]['speed'],
        activity: maps[i]['activity'],
      );
    });
  }


  Future<int> deleteTrackingData(int id) async {
    final Database db = await sqfliteService.database;

    return await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteAllTrackingData() async {
    final Database db = await sqfliteService.database;
    return await db.delete(tableName);
  }


  Future<int> updateTrackingData(TrackingData trackingData) async {
    final Database db = await sqfliteService.database;

    return await db.update(
      tableName,
      trackingData.toMap(),
      where: 'id = ?',
      whereArgs: [trackingData.id],
    );
  }


  Future<int?> getNumberOfRows() async {
    final Database db = await sqfliteService.database;
    return Sqflite.firstIntValue( await db.rawQuery('SELECT COUNT(*) FROM $tableName') );
  }
}