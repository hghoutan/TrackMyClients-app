import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/scheduled_message.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'scheduled_emails.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE scheduled_emails (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            senderName TEXT,
            receiverName TEXT,
            receiverEmail TEXT,
            senderEmail TEXT,
            message TEXT,
            scheduledTime TEXT,
            isSent INTEGER
          )
        ''');
      },
    );
  }

  Future<int> insertScheduledEmail(ScheduledEmail email) async {
    final db = await database;
    return await db.insert('scheduled_emails', email.toMap());
  }

  Future<List<ScheduledEmail>> getPendingEmails() async {
    final db = await database;
    final maps = await db.query(
      'scheduled_emails',
      where: 'isSent = ?',
      whereArgs: [0],
    );
    return List.generate(maps.length, (i) => ScheduledEmail.fromMap(maps[i]));
  }

  Future<void> markEmailAsSent(int id) async {
    final db = await database;
    await db.update(
      'scheduled_emails',
      {'isSent': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
