import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';

class CreateCampusPage extends StatefulWidget {
  
  CreateCampusPage({Key key}): super(key: key);

  @override
  _CreateCampusPageState createState() => _CreateCampusPageState();
}


class _CreateCampusPageState extends State<CreateCampusPage> {
  Color bgColor;
  GoogleMapController mapController;
  final placesAPI = new GoogleMapsPlaces(apiKey: "AIzaSyCG1pRyp5gwu-O74mtUWmPyudqWQGGVO-g");

  List<PlacesSearchResult> latestSearchResult;
  final Map<MarkerId, Marker> mapMarkers = <MarkerId, Marker>{};

  // TODO LARGE: replace with current position (GPS)
  final LatLng _center = const LatLng(47.710406, -117.397041);


  _CreateCampusPageState()
  {
    bgColor = Color.fromRGBO(39, 187, 255, 1);
  }

  void _onMapCreated(GoogleMapController controller){
    mapController = controller;
  }

  void _suggestPlaces(String userInput) async{
    PlacesSearchResponse response = await placesAPI.searchByText(userInput, location: Location(_center.latitude, _center.longitude));
    if(response.isOkay)
    {
      latestSearchResult = response.results;
      _showResultsOnMap(0, response.results.length);  //Shows top three results on the map
    }
    else
    {
      //TODO: determine root of responce fail
    }
  }

  void _showResultsOnMap(int startIdx, int count) {

    //Remove Current marker info if any
    mapMarkers.clear();

    int curIdx = startIdx;
    while(curIdx - startIdx < count && curIdx < latestSearchResult.length) // make sure within place bounds
    {
      //add marker of place
      final MarkerId markerId = MarkerId("create_"+mapMarkers.length.toString());
      _addPlaceMarker(latestSearchResult[curIdx], markerId);

      curIdx++;
    }

    //Update map TODO HUGE: make background map and search field a seperate widget
    setState(() { });
  }

  //Reference: https://stackoverflow.com/questions/55000043/flutter-how-to-add-marker-to-google-maps-with-new-marker-api
  void _addPlaceMarker(PlacesSearchResult place, MarkerId markerId)
  {
    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(
        place.geometry.location.lat,
        place.geometry.location.lng,
      ),
      infoWindow: InfoWindow(title: place.name, snippet: place.formattedAddress),
      onTap: () {
        //TODO: Add on marker tap action
      },
    );

    //TODO: add the rest of place details to info window
    mapMarkers[markerId] = marker;
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
                markers: Set<Marker>.of(mapMarkers.values),
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
                    child: TextField(
                      obscureText: false,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Find a location...',
                        //TODO: New Theme Enable
                        //fillColor: Color.fromRGBO(255, 255, 255, 1),
                        //focusColor: Color.fromRGBO(255, 255, 255, 1),
                      ),
                      onSubmitted: _suggestPlaces,
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
