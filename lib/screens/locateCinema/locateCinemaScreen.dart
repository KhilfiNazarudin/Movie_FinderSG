import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:movie_findersg_khilfi/main.dart';
import 'package:movie_findersg_khilfi/services/httpservice.dart';

class locateCinemas extends StatefulWidget {
  // final LocationData userLocation;
  locateCinemas({
    Key key,
    /* this.userLocation */
  }) : super(key: key);
  @override
  _locateCinemasState createState() => _locateCinemasState();
}

class _locateCinemasState extends State<locateCinemas> {
  Completer<GoogleMapController> _controller = Completer();

  //Custom Matrker Icon
  BitmapDescriptor _locIcon;
  final Set<Marker> listMarkers = {};

  PolylinePoints polylinePoints = PolylinePoints();
  Map<PolylineId, Polyline> polylines = {};
  double distance;
  Marker startMark;
  Marker endMark;
  LatLng startCoords;
  double startLat = 1.37995;
  double startLong = 103.8489483;

  Future<BitmapDescriptor> _setLocCustomeMarker() async {
    BitmapDescriptor bIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), 'images/cinemaIcon.png');
    return bIcon;
  }

  _addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id,
        color: defaultp,
        points: polylineCoordinates,
        width: 8);
    polylines[id] = polyline;
    setState(() {});
  }

  void _getPolyline(LatLng destination) async {
    List<LatLng> polylineCoordinates = [];
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        'AIzaSyChtTJGfaffJCkOgwRaQ-DODGrazqnxmxE',
        PointLatLng(startLat, startLong),
        PointLatLng(destination.latitude, destination.longitude),
        travelMode: TravelMode.walking);
    if (result.points.isNotEmpty) {
      result.points.forEach((element) {
        polylineCoordinates.add(LatLng(element.latitude, element.longitude));
      });
    } else
      print(result.errorMessage);

    _addPolyLine(polylineCoordinates);
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  @override
  void initState() {
    super.initState();
    // _setLocCustomeMarker().then((bm) {
    //   _locIcon = bm;
    //   _locIcon != null
    //       ? setState(() {
    //           listMarkers.add(Marker(
    //               markerId: MarkerId("1"),
    //               position: LatLng(widget.userLocation.latitude,
    //                   widget.userLocation.latitude),
    //               infoWindow: InfoWindow(title: "Current Location"),
    //               icon: _locIcon));
    //         })
    //       : DoNothingAction();
    // });
    // _getPolyline();
    int counter = 0;

    _setLocCustomeMarker().then((bm) {
      _locIcon = bm;
      _locIcon != null
          ? HttpService.getCinemaLocation().then((value) => {
                for (var result in value)
                  {
                    setState(() {
                      listMarkers.add(Marker(
                          markerId: MarkerId(counter.toString()),
                          position: LatLng(double.parse(result.latitude),
                              double.parse(result.longitude)),
                          infoWindow: InfoWindow(title: result.building),
                          icon: _locIcon));
                    }),
                    counter++,
                    print(counter)
                  }
              })
          : DoNothingAction();
    });
  }

  @override
  Widget build(BuildContext context) {
    CameraPosition _currentPos = CameraPosition(
      bearing: 0.0, //compass direction – 90 degree orients east up
      target: LatLng(1.37995, 103.8489483),
      tilt: 0, //title angle – 60 degree looks ahead towards the horizon
      zoom: 11, //zoom level – a middle value of 11 shows city-level
    );
    return Container(
      child: Stack(
        alignment: Alignment.center,
        children: [
          GoogleMap(
            onLongPress: (origin) {
              setState(() {
                startMark = new Marker(
                    markerId: MarkerId(
                      "startMark",
                    ),
                    position: LatLng(origin.latitude, origin.longitude),
                    infoWindow: InfoWindow(title: "Starting location"),
                    );
                listMarkers.add(startMark);

                startLat = origin.latitude;
                startLong = origin.longitude;
                startCoords = origin;
              });
            },
            onTap: (destination) {
              if (startCoords != null) {
                setState(() {
                   endMark = new Marker(
                    markerId: MarkerId(
                      "endMark",
                    ),
                    position: LatLng(destination.latitude, destination.longitude),
                    infoWindow: InfoWindow(title: "Destination"),
                    );
                listMarkers.add(endMark);
                  
                  _getPolyline(destination);
                  distance = calculateDistance(startLat, startLong,
                      destination.latitude, destination.longitude);
                  print(distance);
                });
              } else
                DoNothingAction();
            },
            polylines: Set<Polyline>.of(polylines.values),
            markers: listMarkers,
            myLocationEnabled: true,
            initialCameraPosition: _currentPos,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
          distance == null
              ? SizedBox()
              : Positioned(
                  top: 30,
                  child: Container(
                    alignment: Alignment.center,
                    width: 300,
                    height: 30,
                    child: Text("Distance to location: " +
                        distance.toStringAsPrecision(3) +
                        "km",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: defaulta,
                        boxShadow: [
                          BoxShadow(
                              
                              color: Colors.black38,
                              offset: Offset(0, 2),
                              blurRadius: 6)
                        ]),
                  ))
        ],
      ),
    );
  }
}
