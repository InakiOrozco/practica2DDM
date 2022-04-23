import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practica2/auth/bloc/auth_bloc.dart';
import 'package:practica2/content/bloc/firebase_bloc.dart';
import 'package:practica2/home/bloc/mainpage_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:practica2/home/mainpage.dart';

import 'login/login.dart';

Future main() async {
  await dotenv.load(fileName: ".env");

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (context) => AuthBloc()..add(VerifyAuthEvent())),
      BlocProvider(create: (context) => MainPageBloc()),
      BlocProvider(create: (context) => FirebaseBloc()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'FindTrackApp',
        home: BlocConsumer<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthSuccessState) {
                return MainPage();
              } else if (state is UnAuthState ||
                  state is AuthErrorState ||
                  state is SignOutSuccessState) {
                return LoginPage();
              }
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
            listener: (context, state) {}),
        theme: ThemeData.dark());
  }
}
