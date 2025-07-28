import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/downloaded_chapters_cubit.dart';
import '../../components/navigationBar/navigationBar.dart';
import 'package:go_router/go_router.dart';

class DownloadedChaptersView extends StatelessWidget {
  final String bookId;
  final String bookTitle;
  const DownloadedChaptersView({Key? key, required this.bookId, required this.bookTitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BlocProvider.of<DownloadedChaptersCubit>(context)..loadDownloadedChapters(bookId),
      child: Scaffold(
        backgroundColor: const Color(0xFF1E1E1E),
        appBar: AppBar(
          title: Text('Capítulos de "$bookTitle"'),
        ),
        body: BlocBuilder<DownloadedChaptersCubit, DownloadedChaptersState>(
          builder: (context, state) {
            if (state is DownloadedChaptersLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is DownloadedChaptersLoaded) {
              if (state.chapters.isEmpty) {
                return const Center(child: Text('No hay capítulos descargados.'));
              }
              return ListView.builder(
                itemCount: state.chapters.length,
                itemBuilder: (context, index) {
                  final chapter = state.chapters[index];
                  return ListTile(
                    title: Text(chapter.title, style: const TextStyle(color: Colors.white)),
                    trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white70),
                    onTap: () {
                      context.push(
                        '/downloadedChapterReader',
                        extra: {
                          'chapterId': chapter.id,
                          'bookTitle': bookTitle,
                        },
                      );
                    },
                  );
                },
              );
            } else if (state is DownloadedChaptersError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
} 