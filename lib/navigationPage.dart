import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flare_flutter/flare_actor.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class NavigationPage extends StatefulWidget {
  
  final String title;

  NavigationPage({Key key, this.title}): super(key: key);

  @override
  _NavigationPageState createState() => _NavigationPageState(title);
}

class _NavigationPageState extends State<NavigationPage> {

  bool alreadyAskingForLocationPermissions = false;

  String positionMsg = "Loading...";
  Position position;

  Color bgColor = Color.fromRGBO(255, 255, 255, 1);
  String arrowType = "Static";
  String title;

  //Color bgColor = Color.fromRGBO(39, 187, 255, 1);
  Timer timer;

  //Used to test warmer colder feateure
  bool tempChanges = true;

  _NavigationPageState(title)
  {
    //Timer Refreshing Background
    timer = new Timer.periodic(new Duration(seconds: 1), (Timer t) => _updateBackground());
    bgColor = Color.fromRGBO(39, 187, 255, 1);
    this.title = title;
  }
  
  void _updateBackground() {
    //Form Background color based on change in distance values
    //distance from -1.0 to 1.0
    if(tempChanges)  //negative (colder)
    {
      title = "Colder";
      if(position != null)
        arrowType = "Cold_Arrow";
      else
        arrowType = "Static";
      setState(() {
        bgColor = Color.fromRGBO(39, 187, 255, 1);
      });
    }
    else             //positive (warmer)
    {
      title = "Warmer";
      if(position != null)
        arrowType = "Hot_Arrow";
      else
        arrowType = "Static";
      setState(() {
        bgColor = Color.fromRGBO(255,107,39, 1);
      });
    }
    tempChanges = !tempChanges;
  }

  void getLocation() async {
    alreadyAskingForLocationPermissions = false;
    
    //Check permissions status for location on device
    GeolocationStatus geolocationStatus  = await Geolocator().checkGeolocationPermissionStatus();
    if(geolocationStatus == GeolocationStatus.granted)
    {
      position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    }
    else if (geolocationStatus == GeolocationStatus.denied) 
    {
      positionMsg = "Please enable location services and grant permissions to this app.";
      if(!alreadyAskingForLocationPermissions)
      {
        alreadyAskingForLocationPermissions = true;
        Map<PermissionGroup, PermissionStatus> permissions = await PermissionHandler().requestPermissions([PermissionGroup.locationWhenInUse]);
        alreadyAskingForLocationPermissions = false;
      }
    }
    else if(geolocationStatus == GeolocationStatus.unknown)
    {
      positionMsg = "Your phone is currently unsupported.";
    }
  }

  String getPositionString()
  {
    if(position == null)
      return positionMsg;
    else
      return position.toString();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width:400,
              height:400,
              child:FlareActor(
              'assets/compass.flr',
              alignment: Alignment.center,
              fit: BoxFit.contain,
              animation: arrowType,
              )
            ),
            Text(
              getPositionString(),
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getLocation,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
      backgroundColor: bgColor,
    );
  }
}
