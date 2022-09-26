import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:google_geocoding/google_geocoding.dart';

class CurrentLocation2 extends StatefulWidget {
  @override
  _CurrentLocationState createState() => _CurrentLocationState();
}

class _CurrentLocationState extends State<CurrentLocation2> {
  static LatLng _center = const LatLng(24.774265, 46.738586);
  LatLng _lastMapPostion = _center;
  MapType _currentMapType = MapType.normal;
  final Set<Marker> _markers = {};
  // final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  late bool isLocationEnabled;
  late BuildContext _context;
  // late Position _currentPosition;
  // late  Position _geoPosition;
  late String _currentAddress="";
  late LatLng _myLoc=LatLng(24.774265, 46.738586);
int count=0;
  int by=20;

  Completer<GoogleMapController> _controller = Completer();
  double zoomVal = 0.5;
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  String Address= "EnterAddress".tr();
  @override
  void initState() {
    super.initState();
    // checkGPS('ACTION_LOCATION_SOURCE_SETTINGS');
    _getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Scaffold(
//      appBar: AppBar(
//        title: Text("Current Location"),
//        centerTitle: true,
//      ),
      body: Stack(
        children: <Widget>[
          Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: GoogleMap(
                mapType: _currentMapType,
                initialCameraPosition: CameraPosition(
                    target: _myLoc != null ? _myLoc : _center, zoom: 8.0),
                onMapCreated: _onMapCreated,
                markers: _markers,
                onCameraMove: _onCameraMove,
                myLocationEnabled: true,

              )),
          new Align(
            alignment: Alignment.center,
            child: new Icon(FontAwesomeIcons.mapPin, size: 40.0),
          ),
          Container(
            width: (MediaQuery.of(context).size.width / 3) * 2,
            alignment: Alignment.bottomCenter,
            margin: EdgeInsets.all(16.0),
            child: ElevatedButton(
                // color: Theme.of(context).accentColor,
                onPressed: () {
                  _onAddMarker(context);
                },
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 20,
                    ),
                    Text(  "حفظ الموقع",
                        style: TextStyle(fontSize: 20.0, color: Colors.white),
                        textAlign: TextAlign.center),
                    SizedBox(
                      width: 20,
                    ),
                    Icon(Icons.save, color: Colors.white),
                    SizedBox(
                      width: 20,
                    ),
                  ],
                )),
          ),

        ],
      ),
    );
  }


  void _openLocationSettings() async {
    final opened = await _geolocatorPlatform.openLocationSettings();
    Future.delayed(const Duration(milliseconds: 2500), () {
      _getCurrentPosition();
    });
    // String displayValue;
    // print("mmm$opened////");
    //
    // if (opened) {
    //   displayValue = 'Opened Location Settings';
    //
    // } else {
    //   displayValue = 'Error opening Location Settings';
    // }

  }

  _getCurrentPosition() async {
    print("sss");
    final hasPermission = await _handlePermission();
    print("sss1");
    if (!hasPermission) {
      print("sss2");
      _openLocationSettings();

      return;
    }

    final position = await _geolocatorPlatform.getCurrentPosition().then((po) async {
      print("sss3${po.latitude}");
      _myLoc=LatLng(po.latitude, po.longitude);
      GetAddressFromLatLong(_myLoc);
      //////////////
      //  final coordinates = new Coordinates(1.10, 45.50);
      // var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
      //  var first = addresses.first;
      //  print("${first.featureName} : ${first.addressLine}");
      /////////////
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(po.latitude, po.longitude), zoom: 15.0),
      ));
    });

    // _updatePositionList(
    //   _PositionItemType.position,
    //   position.toString(),
    // );
  }
  Future<void> GetAddressFromLatLong(LatLng position)async {
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    print(placemarks);
    Placemark place = placemarks[0];

    setState(()  {
       Address = '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
      //Address = '${place.street}';

      print("nnn"+Address);
    });
  }

  Future<bool> _handlePermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await _geolocatorPlatform.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      // _updatePositionList(
      //   _PositionItemType.log,
      //   _kLocationServicesDisabledMessage,
      // );

      return false;
    }

    permission = await _geolocatorPlatform.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await _geolocatorPlatform.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        // _updatePositionList(
        //   _PositionItemType.log,
        //   _kPermissionDeniedMessage,
        // );

        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      // _updatePositionList(
      //   _PositionItemType.log,
      //   _kPermissionDeniedForeverMessage,
      // );

      return false;
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    // _updatePositionList(
    //   _PositionItemType.log,
    //   _kPermissionGrantedMessage,
    // );
    return true;
  }


  void _onAddMarker(BuildContext context)async {
   // if (_myLoc != null) _myLoc = _lastMapPostion;
    await GetAddressFromLatLong(_myLoc);
    print("\n\n\n\n\n\n\n"+_myLoc.longitude.toString()+"lll"+"\n\n\n\n\n\n");
    //add _currentAddress to args
    Map <String , dynamic > sendData = Map();
    sendData["loc_latLng"] = _myLoc;
    sendData["loc_name"] = Address;
    Navigator.pop(context, sendData);
  }

  _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }


  _onCameraMove(CameraPosition position) {

    print("vvv${position.target.latitude}");
    _myLoc=LatLng(position.target.latitude, position.target.longitude);
    _lastMapPostion = position.target;
     // Future.delayed(const Duration(seconds: 1), (){
       count++;
       if(count.remainder(by)==0){ GetAddressFromLatLong(position.target);}
     // });

  }


}
