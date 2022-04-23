import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practica2/content/bloc/firebase_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class ResultPage extends StatefulWidget {
  final song;
  ResultPage({Key? key, this.song}) : super(key: key);

  @override
  State<ResultPage> createState() => _ResultPageState();
}

void _launchURL(_url) async {
  if (!await launch(_url)) throw 'No se pudo acceder a: $_url';
}

class _ResultPageState extends State<ResultPage> {
  var _hearth = Icons.favorite_border;

  @override
  Widget build(BuildContext context) {
    //return song page
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              //show favourite confirmation dialog
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Favoritos"),
                    content: Text("¿Quieres agregar esta canción a favoritos?"),
                    actions: [
                      TextButton(
                        child: Text("Si"),
                        onPressed: () {
                          //add song to favourites
                          Map<String, dynamic> favourite = {
                            "artistName": "${widget.song["artistName"]}",
                            "songName": "${widget.song["songName"]}",
                            "albumCover": "${widget.song["albumCover"]}",
                            "listenLink": "${widget.song["listenLink"]}",
                          };
                          Navigator.pop(context);
                          BlocProvider.of<FirebaseBloc>(context).add(
                              AddFavouriteMusicEvent(favourite: favourite));
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
            icon: Icon(_hearth),
          ),
        ],
        title: Text(
          "Here you go",
        ),
      ),
      body: BlocConsumer<FirebaseBloc, FirebaseState>(
        listener: (context, state) {
          print("Firebase Listener has been called");
          if (state is FirebaseAddFavSongSuccess) {
            print("$state");
            setState(() {
              _hearth = Icons.favorite;
            });
            ScaffoldMessenger.of(context)
              ..removeCurrentSnackBar()
              ..showSnackBar(SnackBar(
                content: Text("La canción ha sido añadida a favoritos"),
                backgroundColor: Colors.deepPurpleAccent,
              ));
          } else if (state is FirebaseAddFavSongError) {
            print("$state");
            ScaffoldMessenger.of(context)
              ..removeCurrentSnackBar()
              ..showSnackBar(SnackBar(
                content: Text(
                    "Ha habido un error al agregar la canción a favoritos"),
                backgroundColor: Colors.red,
              ));
          } else if (state is FirebaseAddFavSongExists) {
            print("$state");
            setState(() {
              _hearth = Icons.favorite;
            });
            ScaffoldMessenger.of(context)
              ..removeCurrentSnackBar()
              ..showSnackBar(SnackBar(
                content: Text("La canción ya está en favoritos"),
                backgroundColor: Colors.deepPurple,
              ));
          } else if (state is FirebaseInitial) {
            print("$state");
          }
        },
        builder: (context, state) {
          return Container(
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.network("${widget.song["albumCover"]}"),
                SizedBox(height: 20),
                Text("${widget.song["songName"]}",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center),
                SizedBox(height: 5),
                Text("${widget.song["artistName"]}",
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center),
                SizedBox(height: 5),
                Text(
                  "${widget.song["albumName"]}",
                  style: TextStyle(fontSize: 15),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 5),
                Text(
                  "${widget.song["releaseDate"]}",
                  style: TextStyle(fontSize: 15),
                  textAlign: TextAlign.center,
                ),
                Divider(
                  height: 30,
                  thickness: 1,
                  indent: 20,
                  endIndent: 20,
                  color: Colors.black26,
                ),
                Text("Abrir con:",
                    style: TextStyle(
                      fontSize: 13,
                    )),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      iconSize: 40,
                      onPressed: () {
                        _launchURL("${widget.song["spotifyLink"]}");
                      },
                      icon: Image.asset(
                        'assets/spotify.png',
                        height: 30,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      iconSize: 40,
                      onPressed: () {
                        _launchURL("${widget.song["listenLink"]}");
                      },
                      icon: Icon(Icons.podcasts_rounded),
                    ),
                    IconButton(
                      iconSize: 40,
                      onPressed: () {
                        _launchURL("${widget.song["appleLink"]}");
                      },
                      icon: Icon(Icons.apple),
                      color: Colors.white,
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
