import 'package:sqflite/sqflite.dart';

import '../model/history_trip.dart';

import 'package:dlsm_pof/common/index.dart';



const String historyTripTableName = 'history_trips';

final historyTripDAProvider = Provider<HistoryTripDA>((ref)=> HistoryTripDA(ref));




class HistoryTripDA extends SqfliteDA {

  @override String tableName = historyTripTableName;
  @override String dropTableQuery = 'DROP TABLE IF EXISTS $historyTripTableName';
  @override String createTableQuery = '''
    CREATE TABLE $historyTripTableName (
      id INTEGER PRIMARY KEY,
      startLat REAL NOT NULL,
      startLong REAL NOT NULL,
      endLat REAL NOT NULL,
      endLong REAL NOT NULL,
      startTime TEXT NOT NULL,
      endTime TEXT NOT NULL,
      durationSeconds REAL NOT NULL,
      totalDistance REAL NOT NULL,
      averageSpeed REAL NOT NULL,
      maxSpeed REAL NOT NULL,
      averageAcceleration REAL NOT NULL,
      maxAcceleration REAL NOT NULL,
      averageDeceleration REAL NOT NULL,
      maxDeceleration REAL NOT NULL
    )
  ''';

  
  HistoryTripDA(ProviderRef ref) : super(ref);


  @override
  Future<List<HistoryTrip>> selectAll() async {
    final Database db = await sqfliteService.database;

    final List<Map<String, dynamic>> maps = await db.query(tableName);

    return List.generate(maps.length, (i) {
      return HistoryTrip(
        id: maps[i]['id'],
        startLat: maps[i]['startLat'],
        startLong: maps[i]['startLong'],
        endLat: maps[i]['endLat'],
        endLong: maps[i]['endLong'],
        startTime: maps[i]['startTime'],
        endTime: maps[i]['endTime'],
        durationSeconds: maps[i]['durationSeconds'],
        totalDistance: maps[i]['totalDistance'],
        averageSpeed: maps[i]['averageSpeed'],
        maxSpeed: maps[i]['maxSpeed'],
        averageAcceleration: maps[i]['averageAcceleration'],
        maxAcceleration: maps[i]['maxAcceleration'],
        averageDeceleration: maps[i]['averageDeceleration'],
        maxDeceleration: maps[i]['maxDeceleration'],
      );
    });
  }
}