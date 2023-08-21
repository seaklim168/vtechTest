import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'ui/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  /// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: FutureBuilder(
          /// Initialize FlutterFire
          future: Firebase.initializeApp(),
          builder: (context, snapshot) {
            /// Check for errors
            if (snapshot.hasError) {
              return _error();
            }

            /// Once complete, return to Home
            if (snapshot.connectionState == ConnectionState.done) {
              return const MyHomePage();
            }

            /// Otherwise, show something whilst waiting for initialization to complete
            return _loading();
          },
        ));
  }

  Scaffold _error() {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: Text('Something wen wrong')),
    );
  }

  Scaffold _loading() {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          child: LoadingIndicator(
              indicatorType: Indicator.ballPulse,
              colors: const [Colors.purple],
              strokeWidth: 2,
              backgroundColor: Colors.transparent,
              pathBackgroundColor: Colors.transparent

              /// Optional, the stroke backgroundColor
              )),
    );
  }
}
