import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:practica2/content/song/resultpage.dart';
import 'package:practica2/home/bloc/mainpage_bloc.dart';
import '../auth/bloc/auth_bloc.dart';
import '../content/bloc/firebase_bloc.dart';
import '../content/favourites/favpage.dart';

class MainPage extends StatefulWidget {
  MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String _listenStatus = "Presiona para escuchar";
  bool _animation = false;
  var _iconColor = Colors.white;
  bool pressed = false;
  var _song, _artist, _album, _date, _apple, _spotify, _cover, _link;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      body: Container(
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: BlocConsumer<MainPageBloc, MainPageState>(
            listener: (context, state) {
          print("Listener has been called");
          if (state is MainPageSuccessState) {
            _song = state.song;
            _artist = state.artist;
            _album = state.album;
            _date = state.date;
            _apple = state.apple;
            _spotify = state.spotify;
            _cover = state.image;
            _link = state.link;

            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ResultPage(song: {
                "songName": _song,
                "artistName": _artist,
                "albumName": _album,
                "releaseDate": _date,
                "appleLink": _apple,
                "spotifyLink": _spotify,
                "albumCover": _cover,
                "listenLink": _link,
              }),
            ));
            _animation = false;
            _listenStatus = "";
            _iconColor = Colors.white;
          } else if (state is MainPageErrorState) {
            print("$state");
            _animation = false;
            _listenStatus = "Presiona para escuchar";
            _iconColor = Colors.white;
            ScaffoldMessenger.of(context)
              ..removeCurrentSnackBar()
              ..showSnackBar(SnackBar(
                content: Text(
                    "No se ha podido reconocer la canción, intente de nuevo por favor."),
                backgroundColor: Colors.red,
              ));
          } else if (state is MainPageFinishedState) {
            _animation = true;
            _iconColor = Colors.deepPurpleAccent;
            _listenStatus = "Detecting song...";
            print("$state");
          } else if (state is MainPageListeningState) {
            print("$state");
            _animation = true;
            _iconColor = Colors.deepPurpleAccent;

            _listenStatus = "Escuchando...";
          } else if (state is MainPageInitial) {
            print("$state");
          } else if (state is MainPageMissingValuesState) {
            print("$state");
            _animation = false;
            _listenStatus = "Presione para escuchar";
            _iconColor = Colors.white;
            ScaffoldMessenger.of(context)
              ..removeCurrentSnackBar()
              ..showSnackBar(SnackBar(
                content: Text("No se encontró la canción."),
                backgroundColor: Colors.red,
              ));
          }
        }, builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 100),
              Text(
                _listenStatus,
                style: GoogleFonts.lato(
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              AvatarGlow(
                animate: _animation,
                glowColor: Colors.deepPurpleAccent,
                endRadius: 200.0,
                child: GestureDetector(
                  onTap: () {
                    pressed = true;
                    BlocProvider.of<MainPageBloc>(context)
                        .add(HomerecordUpdateEvent());
                  },
                  child: Material(
                    elevation: 8.0,
                    shape: CircleBorder(),
                    child: CircleAvatar(
                        backgroundColor: _iconColor,
                        radius: 100.0,
                        child: Image.asset(
                          'assets/buttonicon.png',
                          height: 170,
                        )),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                        icon: Icon(
                          Icons.favorite,
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FavPage()));
                          BlocProvider.of<FirebaseBloc>(context)
                              .add(GetFavouriteMusicEvent());
                        }),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      icon: Icon(Icons.power_settings_new),
                      onPressed: () {
                        BlocProvider.of<AuthBloc>(context).add(SignOutEvent());
                      },
                    ),
                  ),
                ],
              ),
            ],
          );
        }),
      ),
    );
  }
}
