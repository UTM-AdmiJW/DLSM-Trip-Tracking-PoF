import 'package:sqflite/sqflite.dart';

import 'history_trip_da.dart';
import '../model/history_trip_point.dart';

import 'package:dlsm_pof/common/index.dart';



const String historyTripPointTableName = 'history_trip_points';

final historyTripPointDAProvider = Provider<HistoryTripPointDA>((ref)=> HistoryTripPointDA(ref));



class HistoryTripPointDA extends SqfliteDA {

  @override String tableName = historyTripPointTableName;
  @override String dropTableQuery = 'DROP TABLE IF EXISTS $historyTripPointTableName';
  @override String createTableQuery = '''
    CREATE TABLE $historyTripPointTableName (
      id INTEGER PRIMARY KEY,
      tripId INTEGER NOT NULL,
      timestamp TEXT NOT NULL,
      latitude REAL NOT NULL,
      longitude REAL NOT NULL,
      speed REAL NOT NULL,
      isDistracted INTEGER NOT NULL,
      acceleration REAL NOT NULL,
      deceleration REAL NOT NULL,
      cornering REAL NOT NULL,
      totalDistance REAL NOT NULL,
      FOREIGN KEY (tripId) REFERENCES $historyTripTableName (id)
    )
  ''';

  HistoryTripPointDA(ProviderRef ref) : super(ref);


  @override
  Future<List<HistoryTripPoint>> selectAll() async {
    final Database db = await sqfliteService.database;

    final List<Map<String, dynamic>> maps = await db.query(tableName);

    return List.generate(maps.length, (i) {
      return HistoryTripPoint(
        id: maps[i]['id'],
        tripId: maps[i]['tripId'],
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
}