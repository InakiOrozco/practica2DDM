part of 'mainpage_bloc.dart';

abstract class MainPageEvent extends Equatable {
  const MainPageEvent();

  @override
  List<Object> get props => [];
}

class HomerecordUpdateEvent extends MainPageEvent {}
