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
    return List.generate(maps.length, (i)=> fromMap(maps[i]));
  }


  Future<List<HistoryTripPoint>> selectByTripId(int tripId) async {
    final Database db = await sqfliteService.database;
    final List<Map<String, dynamic>> maps = await db.query(tableName, where: 'tripId = ?', whereArgs: [tripId], orderBy: 'timestamp ASC');
    return List.generate(maps.length, (i)=> fromMap(maps[i]));
  }



  HistoryTripPoint fromMap(Map<String, dynamic> map) {
    return HistoryTripPoint(
      id: map['id'],
      tripId: map['tripId'],
      timestamp: DateTime.parse(map['timestamp']),
      latitude: map['latitude'],
      longitude: map['longitude'],
      speed: map['speed'],
      isDistracted: map['isDistracted'] == 1,
      acceleration: map['acceleration'],
      deceleration: map['deceleration'],
      cornering: map['cornering'],
      totalDistance: map['totalDistance'],
    );
  }
}