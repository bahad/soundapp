import 'dart:async';

import 'package:soundapp/src/data/favorite.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbHelper {
  static Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await initDb();
    return _db!;
  }

  initDb() async {
    var dbFolder = await getDatabasesPath();
    String path = join(dbFolder, "Favorite.db");

    return await openDatabase(path, onCreate: _onCreate, version: 1);
  }

  FutureOr<void> _onCreate(Database db, int version) async {
    return await db.execute(
        "CREATE TABLE Favorite(id TEXT, name TEXT, path TEXT, category TEXT)");
  }

  Future<List<Favorite>> getFavorite() async {
    var dbClient = await db;
    var result = await dbClient.query("Favorite", orderBy: "name");
    return result.map((data) => Favorite.fromMap(data)).toList();
  }

  Future<bool> getFavoriteMatch(String id) async {
    var dbClient = await db;
    var result = await dbClient
        .query("Favorite", where: "id=?", orderBy: "name", whereArgs: [id]);
    if (result.length == 0) {
      return false;
    } else {
      return true;
    }
  }

  Future<int> insertFavorite(Favorite favorite) async {
    var dbClient = await db;
    return await dbClient.insert("Favorite", favorite.toMap(),
        conflictAlgorithm: ConflictAlgorithm.fail);
  }

  Future removeFavorite(String id) async {
    var dbClient = await db;
    return await dbClient.delete("Favorite", where: "id=?", whereArgs: [id]);
  }
}
