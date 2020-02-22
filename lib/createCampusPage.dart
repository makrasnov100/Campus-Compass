import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CreateCampusPage extends StatefulWidget {
  
  CreateCampusPage({Key key}): super(key: key);

  @override
  _CreateCampusPageState createState() => _CreateCampusPageState();
}


class _CreateCampusPageState extends State<CreateCampusPage> {
  Color bgColor;
  GoogleMapController mapController;

  final LatLng _center = const LatLng(45.521563, -122.677433);

  _CreateCampusPageState()
  {
    bgColor = Color.fromRGBO(39, 187, 255, 1);
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: 
      Center(
        child: Stack(
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width,  // or use fixed size like 200
              height: MediaQuery.of(context).size.height,
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: 15.0,
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 60,
                    width: MediaQuery.of(context).size.width,  // or use fixed size like 200
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 20,
                    height: 100,
                    child: TextFormField(
                      obscureText: false,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Find a location...',
                        //TODO: New Theme Enable
                        //fillColor: Color.fromRGBO(255, 255, 255, 1),
                        //focusColor: Color.fromRGBO(255, 255, 255, 1),
                      ),
                    ),
                  ),
                ],
              )
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: SizedBox(
                width: MediaQuery.of(context).size.width/2,
                height: 100,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: FloatingActionButton.extended(
                    heroTag: "AddWaypointBtn",
                    onPressed: () {
                      // Add onPressed code
                    },
                    label: Text('Add Waypoint'),
                    icon: Icon(Icons.add_location),
                    backgroundColor: Color.fromRGBO(0, 255, 0, 1),
                  ),
                ),
              )
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: SizedBox(
                width: MediaQuery.of(context).size.width/2,
                height: 100,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: FloatingActionButton.extended(
                    heroTag: "AddCampusBtn",
                    onPressed: () {
                      Navigator.pop(context); // goes to entry page
                    },
                    label: Text('Done'),
                    icon: Icon(Icons.done),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                ),
              )
            ),
          ],
        ),
      ),
      backgroundColor: bgColor,
    );
  }
}
