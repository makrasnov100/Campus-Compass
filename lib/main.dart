import 'package:flutter/material.dart';

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
    return MaterialApp(
      title: 'Campus Compass',
      theme: ThemeData(
        primarySwatch: Colors.amber
      ),

      home: EntryPage(),//MyHomePage(title: 'Campus Compass'),

    );
  }
}
