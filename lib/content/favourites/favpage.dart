import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:practica2/content/bloc/firebase_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class FavPage extends StatefulWidget {
  FavPage({Key? key}) : super(key: key);

  @override
  State<FavPage> createState() => _FavPageState();
}

class _FavPageState extends State<FavPage> {
  void _launchURL(_url) async {
    if (!await launch(_url)) throw 'Could not launch $_url';
  }

  late List<dynamic> _favourites;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Canciones en favoritos',
          style: GoogleFonts.lato(),
        ),
      ),
      body: BlocConsumer<FirebaseBloc, FirebaseState>(
        listener: (context, state) {
          // TODO: implement listener
          if (state is FirebaseGetFavMusicSuccess) {
            _favourites = state.favourites;
          }
          if (state is FirebaseRemoveFavSongSuccess) {
            //success snackbar
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text("Song removed from favourites"),
                duration: Duration(seconds: 2),
              ),
            );
            BlocProvider.of<FirebaseBloc>(context)
                .add(GetFavouriteMusicEvent());
          }
        },
        builder: (context, state) {
          if (state is FirebaseGetFavMusicSuccess) {
            return SingleChildScrollView(
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (var i = 0; i < _favourites.length; i++)
                      cardGen(_favourites, i),
                  ],
                ),
              ),
            );
          } else if (state is FirebaseGetFavMusicLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is FirebaseGetFavMusicIsEmpty) {
            return Center(
              child: Text("Todavía no hay canciones favoritas."),
            );
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }

  Card cardGen(List<dynamic> favourites, var index) {
    return Card(
      elevation: 20,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: Text("Quieres ir a la página de la canción?"),
                    actions: [
                      TextButton(
                        child: Text("Si"),
                        onPressed: () {
                          Navigator.pop(context);
                          _launchURL('${favourites[index]['listenLink']}');
                        },
                      ),
                      TextButton(
                        child: Text("No"),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  );
                },
              );
            },
            child: Image.network('${favourites[index]['albumCover']}'),
          ),
          Positioned(
            top: 10,
            left: 10,
            child: IconButton(
              onPressed: () {
                //alert dialogue for removing favourite
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content:
                          Text("Quieres eliminar la canción de favoritos?"),
                      actions: [
                        TextButton(
                          child: Text("Si"),
                          onPressed: () {
                            Navigator.pop(context);
                            BlocProvider.of<FirebaseBloc>(context)
                                .add(RemoveFavouriteMusicEvent(index: index));
                          },
                        ),
                        TextButton(
                          child: Text("No"),
                          onPressed: () {
                            //dismiss dialog
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              icon: Icon(Icons.favorite),
              color: Colors.deepPurpleAccent,
              iconSize: 30,
            ),
          ),
          Column(
            children: [
              Center(
                child: Text(
                  '${favourites[index]['songName']}',
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontStyle: FontStyle.normal),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Center(
                child: Text(
                  '${favourites[index]['artistName']}',
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
