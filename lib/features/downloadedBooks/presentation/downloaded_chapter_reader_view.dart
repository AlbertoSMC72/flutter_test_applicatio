import 'package:flutter/material.dart';
import '../domain/entities/downloaded_chapter_entity.dart';
import '../../components/navigationBar/navigationBar.dart';
import '../data/repositories/downloaded_chapters_repository_impl.dart';
import '../../../core/services/download_service.dart';

class DownloadedChapterReaderView extends StatelessWidget {
  final String chapterId;
  final String bookTitle;
  const DownloadedChapterReaderView({Key? key, required this.chapterId, required this.bookTitle}) : super(key: key);

  Future<DownloadedChapterEntity?> _loadChapter() async {
    final repo = DownloadedChaptersRepositoryImpl(DownloadService());
    return await repo.getDownloadedChapterById(chapterId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        title: Text(bookTitle),
      ),
      body: FutureBuilder<DownloadedChapterEntity?>(
        future: _loadChapter(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return SizedBox.expand(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline_rounded, color: Colors.red, size: 48),
                  const SizedBox(height: 24),
                  Text(
                    'Capítulo no encontrado.',
                    style: TextStyle(color: Colors.white70, fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }
          final chapter = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  chapter.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: SingleChildScrollView(
                    child: Text(
                      chapter.content,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        height: 1.6,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: const CustomNavigationBar(currentRoute: '/downloaded'),
    );
  }
} 