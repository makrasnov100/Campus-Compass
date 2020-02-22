import 'package:flutter/material.dart';

class EntryPage extends StatefulWidget {
  
  EntryPage({Key key}): super(key: key);

  @override
  _EntryPageState createState() => _EntryPageState();
}


class _EntryPageState extends State<EntryPage> {
  Color bgColor;

  _EntryPageState()
  {
    bgColor = Color.fromRGBO(39, 187, 255, 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //NO app bar
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Welcome!",
              style: TextStyle(
                fontSize: 50.0
              ),
            ),
            SizedBox(height: 20),
            Text(
              "To Begin Select an Option...",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30.0,
              ),
            ),
            SizedBox(height: 60),
            ButtonTheme(
              height: 140.0,
              minWidth: MediaQuery.of(context).size.width - 20,
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(40.0),
              ),
              child: RaisedButton(
                color: Theme.of(context).primaryColor,
                child: new Text(
                  "Find a Campus",
                  style: TextStyle(
                    fontSize: 30.0,
                  ),
                ),
                onPressed: () => {},
                splashColor: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 40),
            ButtonTheme(
              height: 140.0,
              minWidth: MediaQuery.of(context).size.width - 20,
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(40.0),
              ),
              child: RaisedButton(
                color: Color.fromRGBO(0, 255, 0, 1),
                child: new Text(
                  "Create a Campus",
                  style: TextStyle(
                    fontSize: 30.0,
                  ),
                ),
                onPressed: () => {},
                splashColor: Colors.blueAccent,
              ),
            ),
          ],
        ),
      ),
      backgroundColor: bgColor,
    );
  }
}
