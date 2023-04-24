import 'package:sqflite/sqflite.dart';

import '../model/trip_point.dart';

import 'package:dlsm_pof/common/index.dart';




const String tripPointTableName = 'trip_points';

final tripPointDAProvider = Provider<TripPointDA>((ref)=> TripPointDA(ref));



class TripPointDA extends SqfliteDA {

  @override String tableName = tripPointTableName;
  @override String dropTableQuery = 'DROP TABLE IF EXISTS $tripPointTableName';
  @override String createTableQuery = '''
    CREATE TABLE $tripPointTableName (
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
}