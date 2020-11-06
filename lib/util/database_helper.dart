import 'dart:async';
import 'dart:io';

import 'package:dataBase/model/user.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;

  static Database _db;

  final String tableUser = "userTable";
  final String coulmnId = "id";
  final String userN = "username";
  final String ps = "password";

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  initDb() async {
    Directory doucmentDir = await getApplicationDocumentsDirectory();
    String paths = join(doucmentDir.path, "maindb.db");

    var ourDb = await openDatabase(paths, version: 1, onCreate: _onCreate);
    return ourDb;
  }
  //  FutureOr<void> _onCreate(Database db, int version) {}

  void _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $tableUser($coulmnId INTEGER PRIMARY KEY,$userN TEXT,$ps TEXT)");
  }

  // Future<int> saveUser(User user) async {
  //   var dbClient = await db;
  //   int res = await dbClient.insert("$tableUser", user.toMap());
  //   return res;
  // }

  Future<int> saveUser(User user) async {
    var dbClient = await db;
    int res = await dbClient.insert("$tableUser", user.toMap());
    return res;
  }

  // Future<List> getAllUser() async {
  //   var dbClient = await db;
  //   var res = await dbClient.rawQuery("SELECT * FROM $tableUser");
  //   return res.toList();
  // }

  Future<List> getAllUser() async {
    var dbClient = await db;
    var res = await dbClient.rawQuery("SELECT * FROM $tableUser");
    return res.toList();
  }

  // Future<int> getCount() async {
  //   var dbClient = await db;
  //   return Sqflite.firstIntValue(
  //       await dbClient.rawQuery("SELECT COUNT(*) FROM $tableUser"));
  // }

  Future<int> getCount() async {
    var dbClient = await db;
    return Sqflite.firstIntValue(
        await dbClient.rawQuery("SELECT COUNT(*)FROM $tableUser"));
  }

  // Future<User> getUser(int id) async {
  //   var dbClient = await db;
  //   var result =
  //       await dbClient.rawQuery("SELECT * FROM $tableUser WHERE $coulmnId=$id");
  //   if (result.length == 0) return null;
  //   return new User.fromMap(result.first);
  // }

  Future<User> getUser(int id) async {
    var dbClient = await db;
    var res = await dbClient.rawQuery("SELECT * FROM $tableUser WHERE id=$id");
    if (res.length == 0) return null;
    return new User.fromMap(res.first);
  }

  Future<int> deleteUser(int id) async {
    var dbClient = await db;
    return await dbClient
        .delete(tableUser, where: "$coulmnId=?", whereArgs: [id]);
  }

  Future<int> updataUser(User user) async {
    var dbClient = await db;
    return await dbClient.update(tableUser, user.toMap(),
        where: "$coulmnId=?", whereArgs: [user.id]);
  }

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}
