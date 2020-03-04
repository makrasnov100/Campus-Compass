import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;

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
  final Map<MarkerId, Marker> searchMarkers = <MarkerId, Marker>{};
  final Map<MarkerId, Marker> permanentMarkers = <MarkerId, Marker>{};
  int permenantMarkerCount = 0;
  
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
    searchMarkers.clear();

    int curIdx = startIdx;
    while(curIdx - startIdx < count && curIdx < latestSearchResult.length) // make sure within place bounds
    {
      //add marker of place
      final MarkerId markerId = MarkerId("create_"+searchMarkers.length.toString());
      searchMarkers[markerId] = _createPlaceMarker(latestSearchResult[curIdx], markerId);

      curIdx++;
    }

    //Update map TODO HUGE: make background map and search field a seperate widget
    setState(() { });
  }

  _addWaypoint() async {
    //Search if any of the search markers are currently selected
    
    Marker selectedMarker;
    for (MarkerId id in searchMarkers.keys)
    {
      bool isWindowShown = await mapController.isMarkerInfoWindowShown(id);
      if(isWindowShown)
      {
        selectedMarker = searchMarkers[id];
        break;
      }
    }

    //Add waypoint at marker if one is selected
    if(selectedMarker != null)
    {
      permenantMarkerCount++;
      final MarkerId markerId = MarkerId("permanent_"+permenantMarkerCount.toString());
      permanentMarkers[markerId] = await _createPlaceMarkerScratch(selectedMarker.position, selectedMarker.infoWindow.title, "", markerId, markerIconAsset:"assets/greenMarker.png");
    }
    
    //TODO HUGE: add ability to add markers when no search markers are selected by popup

    setState(() { });
  }

  //Reference: https://stackoverflow.com/questions/55000043/flutter-how-to-add-marker-to-google-maps-with-new-marker-api
  Marker _createPlaceMarker(PlacesSearchResult place, MarkerId markerId)
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
    return marker;
  }

  Future<Marker> _createPlaceMarkerScratch(LatLng location, String name, String description, MarkerId markerId, {String markerIconAsset = "assets/redMarker.png"}) async
  {
    final Uint8List markerIcon = await getBytesFromAsset(markerIconAsset, 30);

    final Marker marker = Marker(
      markerId: markerId,
      position: location,
      infoWindow: InfoWindow(title: name, snippet: description),
      onTap: () {
        //TODO: Add on marker tap action
      },
      icon: BitmapDescriptor.fromBytes(markerIcon)
    );

    //TODO: add the rest of place details to info window
    return marker;
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png)).buffer.asUint8List();
  }

  Set<Marker> getMapMarkers()
  {
    Set<Marker> result = Set<Marker>.of(searchMarkers.values);
    result.addAll(Set<Marker>.of(permanentMarkers.values));

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: 
      Center(
        child: Stack(
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: 15.0,
                ),
                markers: getMapMarkers(),
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
                      _addWaypoint();
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
