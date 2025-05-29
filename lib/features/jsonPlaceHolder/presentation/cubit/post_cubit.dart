import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/post_repository.dart';
import 'post_state.dart';

class PostCubit extends Cubit<PostState> {
  final PostRepository _postRepository;

  PostCubit(this._postRepository) : super(PostInitial());

  Future<void> loadPosts() async {
    try {
      emit(PostLoading());
      final posts = await _postRepository.getPosts();
      emit(PostLoaded(posts));
    } catch (e) {
      emit(PostError(e.toString()));
    }
  }

  Future<void> refreshPosts() async {
    try {
      final posts = await _postRepository.getPosts();
      emit(PostLoaded(posts));
    } catch (e) {
      emit(PostError(e.toString()));
    }
  }

  void resetState() {
    emit(PostInitial());
  }
}