import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; //force portrait up

//Other Created Pages
import 'entryPage.dart';

void main()
{
  //Create app class
  MyApp app = MyApp();
  runApp(app);
}

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
          SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);

    return MaterialApp(
      title: 'Campus Compass',
      theme: ThemeData(
        primarySwatch: Colors.amber
      ),
      home: EntryPage(),//MyHomePage(title: 'Campus Compass'),
    );
  }
}
