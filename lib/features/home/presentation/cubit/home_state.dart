import 'package:equatable/equatable.dart';
import '../../domain/entities/home_book_entity.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {
  const HomeInitial();
}

class HomeLoading extends HomeState {
  const HomeLoading();
}

class HomeLoaded extends HomeState {
  final List<HomeBookEntity> allBooks;
  final List<HomeBookEntity> newPublications;
  final List<HomeBookEntity> recommended;
  final List<HomeBookEntity> trending;

  const HomeLoaded({
    required this.allBooks,
    required this.newPublications,
    required this.recommended,
    required this.trending,
  });

  @override
  List<Object?> get props => [allBooks, newPublications, recommended, trending];
}

class HomeError extends HomeState {
  final String message;

  const HomeError({required this.message});

  @override
  List<Object?> get props => [message];
}