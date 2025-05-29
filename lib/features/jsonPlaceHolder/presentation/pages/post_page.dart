import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/post_repository.dart';
import '../cubit/post_cubit.dart';
import '../cubit/post_state.dart';
import '../widgets/post_card.dart';

class PostsPage extends StatelessWidget {
  const PostsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PostCubit(PostRepository())..loadPosts(),
      child: const PostsView(),
    );
  }
}

class PostsView extends StatelessWidget {
  const PostsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts JSONPlaceholder'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<PostCubit>().refreshPosts(),
          ),
        ],
      ),
      body: BlocBuilder<PostCubit, PostState>(
        builder: (context, state) {
          if (state is PostInitial) {
            return const Center(
              child: Text('Presiona el botón para cargar los posts'),
            );
          } else if (state is PostLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Cargando posts...'),
                ],
              ),
            );
          } else if (state is PostLoaded) {
            if (state.posts.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.inbox, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text('No hay posts disponibles'),
                  ],
                ),
              );
            }
            
            return RefreshIndicator(
              onRefresh: () => context.read<PostCubit>().refreshPosts(),
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: state.posts.length,
                itemBuilder: (context, index) {
                  final post = state.posts[index];
                  return PostCard(
                    post: post,
                    onTap: () {
                      _showPostDetail(context, post);
                    },
                  );
                },
              ),
            );
          } else if (state is PostError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${state.message}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<PostCubit>().loadPosts(),
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }
          
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: BlocBuilder<PostCubit, PostState>(
        builder: (context, state) {
          if (state is! PostLoading) {
            return FloatingActionButton(
              onPressed: () => context.read<PostCubit>().loadPosts(),
              child: const Icon(Icons.refresh),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _showPostDetail(BuildContext context, post) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Post ${post.id}'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Usuario: ${post.userId}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  post.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  post.body,
                  style: const TextStyle(fontSize: 16, height: 1.5),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }
}