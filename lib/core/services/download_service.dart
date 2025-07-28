import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqlite_api.dart';
import '../../features/book/domain/entities/book_detail_entity.dart';
import '../../features/contentChapter/domain/entities/chapter_entity.dart' as detail_entities;
import '../../features/contentChapter/domain/usecases/chapter_usecases.dart';


abstract class ChapterDetailProvider {
  Future<detail_entities.ChapterDetailEntity> getChapterDetail(String chapterId);
}

class DownloadService {
  static final DownloadService _instance = DownloadService._internal();
  factory DownloadService() => _instance;
  DownloadService._internal();

  Database? _db;
  ChapterDetailProvider? chapterDetailProvider;
  GetChapterDetailUseCase? getChapterDetailUseCase;

  void setChapterDetailProvider(ChapterDetailProvider provider) {
    chapterDetailProvider = provider;
  }

  void setChapterDetailUseCase(GetChapterDetailUseCase useCase) {
    getChapterDetailUseCase = useCase;
  }

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'books_downloads.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE books (
            id TEXT PRIMARY KEY,
            title TEXT,
            description TEXT,
            genres TEXT,
            author TEXT,
            coverImage TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE chapters (
            id TEXT PRIMARY KEY,
            bookId TEXT,
            title TEXT,
            content TEXT,
            FOREIGN KEY(bookId) REFERENCES books(id)
          )
        ''');
      },
    );
  }

  Future<void> saveBook(BookDetailEntity book) async {
    final db = await database;
    // Guardar libro
    await db.insert(
      'books',
      {
        'id': book.id,
        'title': book.title,
        'description': book.description,
        'genres': jsonEncode(book.genres?.map((g) => g.name).toList() ?? []),
        'author': book.author?.username ?? '',
        'coverImage': book.coverImage ?? '',
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    // Guardar capítulos (descargando el detalle de cada uno)
    if (book.chapters != null && chapterDetailProvider != null) {
      for (final chapter in book.chapters!) {
        final detail = await chapterDetailProvider!.getChapterDetail(chapter.id);
        // Concatenar el contenido de los párrafos
        final content = detail.paragraphs.map((p) => p.content).join('\n\n');
        await saveChapter(book.id, chapter, content);
      }
    }
  }

  Future<void> saveChapter(String bookId, ChapterEntity chapter, String content) async {
    final db = await database;
    await db.insert(
      'chapters',
      {
        'id': chapter.id,
        'bookId': bookId,
        'title': chapter.title,
        'content': content,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Para guardar un capítulo individual (por id)
  Future<void> saveChapterById(String bookId, String chapterId) async {
    if (getChapterDetailUseCase == null) return;
    final detail = await getChapterDetailUseCase!(chapterId);
    final content = detail.paragraphs.map((p) => p.content).join('\n\n');
    await saveChapter(
      bookId,
      ChapterEntity(
        id: detail.id,
        title: detail.title,
        published: detail.published,
        createdAt: detail.createdAt,
        isLiked: null,
      ),
      content,
    );
  }

  Future<bool> isBookDownloaded(String bookId) async {
    final db = await database;
    final result = await db.query('books', where: 'id = ?', whereArgs: [bookId]);
    return result.isNotEmpty;
  }

  Future<bool> isChapterDownloaded(String chapterId) async {
    final db = await database;
    final result = await db.query('chapters', where: 'id = ?', whereArgs: [chapterId]);
    return result.isNotEmpty;
  }

  Future<void> deleteBook(String bookId) async {
    final db = await database;
    // Borra los capítulos asociados primero
    await db.delete('chapters', where: 'bookId = ?', whereArgs: [bookId]);
    // Luego borra el libro
    await db.delete('books', where: 'id = ?', whereArgs: [bookId]);
  }

  Future<void> deleteChapter(String chapterId) async {
    final db = await database;
    await db.delete('chapters', where: 'id = ?', whereArgs: [chapterId]);
  }
} 