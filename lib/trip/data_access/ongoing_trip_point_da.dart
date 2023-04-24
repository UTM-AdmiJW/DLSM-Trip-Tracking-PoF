import 'package:sqflite/sqflite.dart';

import '../model/ongoing_trip_point.dart';

import 'package:dlsm_pof/common/index.dart';




const String ongoingTripPointTableName = 'ongoing_trip_points';

final ongoingTripPointDAProvider = Provider<OngoingTripPointDA>((ref)=> OngoingTripPointDA(ref));



class OngoingTripPointDA extends SqfliteDA {

  @override String tableName = ongoingTripPointTableName;
  @override String dropTableQuery = 'DROP TABLE IF EXISTS $ongoingTripPointTableName';
  @override String createTableQuery = '''
    CREATE TABLE $ongoingTripPointTableName (
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

  OngoingTripPointDA(ProviderRef ref) : super(ref);


  @override
  Future<List<OngoingTripPoint>> selectAll() async {
    final Database db = await sqfliteService.database;

    final List<Map<String, dynamic>> maps = await db.query(tableName);

    return List.generate(maps.length, (i) {
      return OngoingTripPoint(
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