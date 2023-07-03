import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:music_mood_matcher/models/recommendation/recommendation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:music_mood_matcher/models/recommendation/constants.dart';

class RecommendationProvider {
  late Database _db;

  Future open(String path) async {
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(createRecommendationTableRawSQL);
        await db.execute(createSearchTableRawSQL);
      },
      onOpen: (db) async {
        await db.execute(createRecommendationTableRawSQL);
        await db.execute(createSearchTableRawSQL);
      },
    );
  }

  Future insertNewSearched(List<Recommendation> recs) async {
    _db.transaction((txn) async {
      await txn.execute('DROP TABLE IF EXISTS $searchTableName;');
      await txn.execute(createSearchTableRawSQL);
    });

    for (Recommendation rec in recs) {
      await insert(rec);
      await _db.insert(searchTableName, {columnId: rec.id});
    }
  }

  Future<int> insert(Recommendation rec) async {
    return await _db.insert(recommendationTableName, rec.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> delete(String id) async {
    return await _db.delete(recommendationTableName,
        where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> update(Recommendation rec) async {
    return await _db.update(
        recommendationTableName, {columnId: rec.id, columnLiked: rec.liked},
        where: '$columnId == ?',
        whereArgs: [rec.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  void seed() async {
    List<dynamic> seedSQL = await rootBundle.loadStructuredData(
        'assets/data/seed.json', (value) async => await jsonDecode(value));
    for (int i = 0; i < seedSQL.length; i++) {
      _db.insert(recommendationTableName, seedSQL[i],
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  Future<List<Recommendation>> getFavorites() async {
    List<Map<String, Object?>> res = await _db.query(recommendationTableName,
        where: '$columnLiked == ?', whereArgs: [1], orderBy: columnTitle);
    List<Recommendation> recs =
        res.map((e) => Recommendation.fromMap(e)).toList();

    return recs;
  }

  Future<List<Recommendation>> getSearched() async {
    List<Map<String, Object?>> searchQueryRes =
        await _db.query(searchTableName, columns: [columnId]);

    List<String> searchedIds =
        searchQueryRes.map((e) => e[columnId] as String).toList();

    List<List<Map<String, Object?>>> recQueryRes = [];

    for (var id in searchedIds) {
      recQueryRes.add(await _db.query(recommendationTableName,
          where: '$columnId == ?', whereArgs: [id]));
    }

    List<Map<String, Object?>> recMaps = recQueryRes.map((e) => e[0]).toList();

    List<Recommendation> recs =
        recMaps.map((e) => Recommendation.fromMap(e)).toList();

    return recs;
  }

  Future addRandomToSearch() async {
    var result = await _db.query(recommendationTableName,
        columns: [columnId], limit: 20, orderBy: columnTitle);
    var ids = result.map((e) => e[columnId]).toList();
    print(ids);
    ids
        .map((id) async => await _db.insert(searchTableName, {columnId: id},
            conflictAlgorithm: ConflictAlgorithm.replace))
        .toList();
  }
}
