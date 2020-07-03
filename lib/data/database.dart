import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/show.dart';
import '../models/episode.dart';

class ShowDatabase {
  static final ShowDatabase _showDatabase = new ShowDatabase._internal();

  Database db;

  bool _didInit = false;

  static ShowDatabase get() {
    return _showDatabase;
  }

  ShowDatabase._internal();

  /// Use this method to access the database, because initialization of the database (it has to go through the method channel)
  Future<Database> _getDb() async{
    if(!_didInit) await _init();
    return db;
  }

  Future init() async {
    return await _init();
  }

  Future _init() async {
    db = await openDatabase(join(await getDatabasesPath(), 'kitsu_anime.db'),
        version: 1, onCreate: (Database db, int version) async {
      await db.execute('''
      CREATE TABLE ${Show.tableName}(
        ${Show.dbId} INTEGER PRIMARY KEY, 
        ${Show.dbTitle} TEXT, 
        ${Show.dbSynopsis} TEXT, 
        ${Show.dbThumbnail} TEXT, 
        ${Show.dbSeason} TEXT, 
        ${Show.dbYear} INTEGER, 
        ${Show.dbOngoing} INTEGER, 
        ${Show.dbActive} INTEGER, 
        ${Show.dbFavorite} INTEGER, 
        ${Show.dbWatched} INTEGER
      )''');

      await db.execute('''
      CREATE TABLE ${Episode.tableName}(
        ${Episode.dbId} INTEGER PRIMARY KEY, 
        ${Episode.dbShowId} INTEGER, 
        ${Episode.dbNumber} TEXT, 
        ${Episode.dbType} TEXT, 
        ${Episode.dbReleasedOn} TEXT, 
        ${Episode.dbCreatedAt} TEXT, 
        ${Episode.dbDownloaded} INTEGER, 
        ${Episode.dbWatched} INTEGER
      )''');
    });
    _didInit = true;
  }

  Future<List<Show>> getShows() async {
    var db = await _getDb();
    List<Map> maps = await db
        .query(Show.tableName, orderBy: "title ASC");
    if (maps.length > 0) {
      return maps.map((e) => Show.fromMap(e)).toList();
    }
    return [];
  }

  Future<Show> insertShow(Show obj) async {
    var db = await _getDb();
    obj.id = await db.insert(Show.tableName, obj.toMap());
    return obj;
  }

  Future<Show> getShow(int id) async {
    var db = await _getDb();
    List<Map> maps = await db.query(Show.tableName,
        where: '${Show.dbId} = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return Show.fromMap(maps.first);
    }
    return null;
  }

  Future<int> deleteShow(int id) async {
    var db = await _getDb();
    return await db
        .delete(Show.tableName, where: '${Show.dbId} = ?', whereArgs: [id]);
  }

  Future<int> updateShow(Show obj) async {
    var db = await _getDb();
    return await db.update(Show.tableName, obj.toMap(),
        where: '${Show.dbId} = ?', whereArgs: [obj.id]);
  }

  // EPISODES

  Future<List<Episode>> getEpisodes() async {
    var db = await _getDb();
    List<Map> maps = await db.query(Episode.tableName, orderBy: "show_id ASC, CASE type WHEN 'episode' THEN 1 WHEN 'batch' THEN 2 ELSE 3 END, CAST(number AS INT) DESC, released_on DESC");
    if (maps.length > 0) {
      return maps.map((e) => Episode.fromMap(e)).toList();
    }
    return [];
  }

  Future<Episode> insertEpisode(Episode obj) async {
    var db = await _getDb();
    obj.id = await db.insert(Episode.tableName, obj.toMap());
    return obj;
  }

  Future<Episode> getEpisode(int id) async {
    var db = await _getDb();
    List<Map> maps = await db.query(Episode.tableName,
        //columns: [columnId, columnDone, columnTitle],
        where: '${Episode.dbId} = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return Episode.fromMap(maps.first);
    }
    return null;
  }

  Future<int> deleteEpisode(int id) async {
    var db = await _getDb();
    return await db
        .delete(Episode.tableName, where: '${Episode.dbId} = ?', whereArgs: [id]);
  }

  Future<int> updateEpisode(Episode obj) async {
    var db = await _getDb();
    return await db.update(Episode.tableName, obj.toMap(),
        where: '${Episode.dbId} = ?', whereArgs: [obj.id]);
  }

  Future close() async {
    var db = await _getDb();
    db.close();
  }
}
