import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SelectCampusPage extends StatefulWidget {
  
  SelectCampusPage({Key key}): super(key: key);

  @override
  _SelectCampusPageState createState() => _SelectCampusPageState();
}


class _SelectCampusPageState extends State<SelectCampusPage> {
  Color bgColor;
  GoogleMapController mapController;

  final LatLng _center = const LatLng(45.521563, -122.677433);

  _SelectCampusPageState()
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
                        labelText: 'Find a campus...',
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
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  FloatingActionButton.extended(
                    onPressed: () {
                      // Add your onPressed code here!
                    },
                    label: Text('Go Back'),
                    icon: Icon(Icons.done),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  SizedBox(
                    height:20,
                    width: MediaQuery.of(context).size.width,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      backgroundColor: bgColor,
    );
  }
}
