import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:api_flutter/models/comments_data.dart';

class DBProvider {
  late Database _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async {
    // If database exists, return database
    if (_database != null) return _database;

    // If database don't exists, create one
    _database = await initDB();

    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'comments_manager.db');

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE Comment('
          'id INTEGER PRIMARY KEY,'
          'postId INTEGER,'
          'email TEXT,'
          'name TEXT,'
          'body TEXT'
          ')');
    });
  }

  createComment(CommentsData comment) async {
    final db = await database;
    final res = await db.insert('Comment', comment.toJson());

    return res;
  }

  Future<List<CommentsData>> getAllComments() async {
    final db = await database;
    final res = await db.rawQuery("SELECT * FROM Comment");

    List<CommentsData> list =
        res.isNotEmpty ? res.map((c) => CommentsData.fromJson(c)).toList() : [];

    return list;
  }
}
