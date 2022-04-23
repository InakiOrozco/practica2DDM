part of 'firebase_bloc.dart';

abstract class FirebaseEvent extends Equatable {
  const FirebaseEvent();

  @override
  List<Object> get props => [];
}

class GetFavouriteMusicEvent extends FirebaseEvent {}

class RemoveFavouriteMusicEvent extends FirebaseEvent {
  final int index;

  RemoveFavouriteMusicEvent({required this.index});
  @override
  List<Object> get props => [this.index];
}

class AddFavouriteMusicEvent extends FirebaseEvent {
  final Map<String, dynamic> favourite;

  AddFavouriteMusicEvent({required this.favourite});
  @override
  List<Object> get props => [this.favourite];
}
