part of 'firebase_bloc.dart';

class FirebaseInitial extends FirebaseState {}

abstract class FirebaseState extends Equatable {
  const FirebaseState();

  @override
  List<Object> get props => [];
}

class FirebaseGetFavMusicSuccess extends FirebaseState {
  final List<dynamic> favourites;

  FirebaseGetFavMusicSuccess({required this.favourites});

  @override
  List<Object> get props => [this.favourites];
}

class FirebaseGetFavMusicError extends FirebaseState {}

class FirebaseGetFavMusicIsEmpty extends FirebaseState {}

class FirebaseGetFavMusicLoading extends FirebaseState {}

class FirebaseAddFavSongLoading extends FirebaseState {}

class FirebaseAddFavSongSuccess extends FirebaseState {}

class FirebaseAddFavSongError extends FirebaseState {}

class FirebaseAddFavSongExists extends FirebaseState {}

class FirebaseRemoveFavSongLoading extends FirebaseState {}

class FirebaseRemoveFavSongSuccess extends FirebaseState {}

class FirebaseRemoveFavSongError extends FirebaseState {}
