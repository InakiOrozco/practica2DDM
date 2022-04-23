import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import 'package:firebase_auth/firebase_auth.dart';

part 'firebase_event.dart';
part 'firebase_state.dart';

class FirebaseBloc extends Bloc<FirebaseEvent, FirebaseState> {
  FirebaseBloc() : super(FirebaseInitial()) {
    on<AddFavouriteMusicEvent>(addFavSong);
    on<RemoveFavouriteMusicEvent>(rmFavSong);
    on<GetFavouriteMusicEvent>(getFavouriteList);
  }

  Future<void> addFavSong(
      AddFavouriteMusicEvent event, Emitter<FirebaseState> emitter) async {
    emit(FirebaseAddFavSongLoading());
    try {
      DocumentReference<Map<String, dynamic>> userCollection =
          getUserCollection();

      Map<String, dynamic>? collection = (await userCollection.get()).data();

      if (collection == null) {
        print("Could not retrieve collection");
        return null;
      }
      List<dynamic> favourites = collection['user-favourites'];
      if (favourites.isEmpty) {
        favourites.add(event.favourite);
        await userCollection.update({'user-favourites': favourites});
        emit(FirebaseAddFavSongSuccess());
      } else {
        for (var i in favourites) {
          if (i['songName'] == event.favourite['songName'] &&
              i['artistName'] == event.favourite['artistName']) {
            emit(FirebaseAddFavSongExists());
            return;
          }
        }
        favourites.add(event.favourite);
        await userCollection.update({'user-favourites': favourites});
        emit(FirebaseAddFavSongSuccess());
      }
    } catch (e) {
      emit(FirebaseAddFavSongError());
    }
  }

  Future<void> rmFavSong(
      RemoveFavouriteMusicEvent event, Emitter<FirebaseState> emitter) async {
    emit(FirebaseRemoveFavSongLoading());
    try {
      DocumentReference<Map<String, dynamic>> userCollection =
          getUserCollection();

      Map<String, dynamic>? collection = (await userCollection.get()).data();

      if (collection == null) {
        return null;
      }
      List<dynamic> favourites = collection['user-favourites'];
      favourites.removeAt(event.index);

      await userCollection.update({'user-favourites': favourites});
      emit(FirebaseRemoveFavSongSuccess());
    } catch (e) {
      emit(FirebaseRemoveFavSongError());
    }
  }

  Future<void> getFavouriteList(event, emit) async {
    emit(FirebaseGetFavMusicLoading());
    try {
      DocumentReference<Map<String, dynamic>> userCollection =
          getUserCollection();

      Map<String, dynamic>? collection = (await userCollection.get()).data();

      if (collection == null) {
        return null;
      }
      List<dynamic> favourites = collection['user-favourites'];
      if (favourites.isEmpty) {
        emit(FirebaseGetFavMusicIsEmpty());
      } else {
        emit(FirebaseGetFavMusicSuccess(favourites: favourites));
      }
    } catch (e) {
      emit(FirebaseGetFavMusicError());
    }
  }

  DocumentReference<Map<String, dynamic>> getUserCollection() {
    final userCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid);
    return userCollection;
  }
}
