import 'package:flutter_sqflite/model_card.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class NotesDatabase{
  static  final NotesDatabase _notesDatabase = NotesDatabase._intl();
  static Database? _database;

  NotesDatabase._intl();
  Future<Database?> get database async{
    if(_database != null) return _database;
      _database = await _initDB('notes.db');
      return _database!;
  }
  Future<Database> _initDB(String filepath)async{
    final dbPath = await getDatabasesPath();
    final path = join(dbPath,filepath);
    return await openDatabase(path,version: 1,onCreate: _onCreate);
  }
  Future _onCreate(Database db, int version)async{
    final idType = 'Id Type';
    final textType = 'Text Type';
    final boolType = 'Bool Type';
    final integerType = 'Integer Type';
    await db.execute('''
    REATE TABLE $tableNotes(
    ${NoteFields.id}$idType,
    ${NoteFields.isImportant}$boolType,
    ${NoteFields.number}$integerType,
    ${NoteFields.title}$textType,
    ${NoteFields.description}$textType,
    ${NoteFields.values}$textType,
    ${NoteFields.time}$textType,
    )
    ''');
  }

  Future<Note> create(Note note)async{
    final db = await _notesDatabase.database;
    
    final id = await db!.insert(tableNotes, note.toJson());
  }

  Future close()async{
    final db = await _notesDatabase.database;
    db!.close();
  }
}