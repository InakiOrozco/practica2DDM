part of 'mainpage_bloc.dart';

abstract class MainPageState extends Equatable {
  const MainPageState();

  @override
  List<Object> get props => [];
}

class MainPageInitial extends MainPageState {}

class MainPageListeningState extends MainPageState {}

class MainPageFinishedState extends MainPageState {}

class MainPageMissingValuesState extends MainPageState {}

class MainPageSuccessState extends MainPageState {
  String song, artist, album, date, apple, spotify, image, link;

  MainPageSuccessState({
    required this.song,
    required this.artist,
    required this.album,
    required this.date,
    required this.apple,
    required this.spotify,
    required this.image,
    required this.link,
  });
}

class MainPageErrorState extends MainPageState {}
