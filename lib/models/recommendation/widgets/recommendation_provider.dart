import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:music_mood_matcher/models/recommendation/recommendation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:music_mood_matcher/models/recommendation/constants.dart';

// TODO: POTENTIAL: create instance methods to convert the insert/update...
// TODO: POTENTIAL:   helpers into raw sql statements and use TXNs

class RecommendationProvider {
  late Database _db;
  Future open(String path) async {
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(createTableRawSQL);
      },
      onOpen: (db) async {
        await db.execute(createTableRawSQL);
      },
    );
  }

  Future<int> insert(Recommendation rec) async {
    return await _db.insert(tableName, rec.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> delete(int id) async {
    return await _db.delete(tableName, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> update(Recommendation rec) async {
    return _db.update(tableName, {columnId: rec.id, columnLiked: rec.liked},
        where: '$columnId == ?',
        whereArgs: [rec.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  void seed() async {
    List<dynamic> seedSQL = await rootBundle.loadStructuredData(
        'assets/data/seed.json', (value) async => await jsonDecode(value));
    for (int i = 0; i < seedSQL.length; i++) {
      _db.insert(tableName, seedSQL[i],
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  Future<List<Recommendation>> getFavorites() async {
    List<Map<String, Object?>> maps = await _db.query(
      tableName,
      where: '$columnLiked == ?',
      whereArgs: ['1'],
    );
    List<Recommendation> recs =
        maps.map((e) => Recommendation.fromMap(e)).toList();
    recs.sort((a, b) => a.title.compareTo(b.title));

    return recs;
  }
}
