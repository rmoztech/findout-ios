import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class CurrentLocation2 extends StatefulWidget {
  @override
  _CurrentLocationState createState() => _CurrentLocationState();
}

class _CurrentLocationState extends State<CurrentLocation2> {
  static LatLng _center = const LatLng(24.774265, 46.738586);
  LatLng _lastMapPostion = _center;
  MapType _currentMapType = MapType.normal;
  final Set<Marker> _markers = {};
  late bool isLocationEnabled;
  late BuildContext _context;

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
    _getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Scaffold(

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
   

  }

  _getCurrentPosition() async {
    final hasPermission = await _handlePermission();
    if (!hasPermission) {
      _openLocationSettings();

      return;
    }

    final position = await _geolocatorPlatform.getCurrentPosition().then((po) async {
      _myLoc=LatLng(po.latitude, po.longitude);
      GetAddressFromLatLong(_myLoc);
   
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(po.latitude, po.longitude), zoom: 15.0),
      ));
    });


  }
  Future<void> GetAddressFromLatLong(LatLng position)async {
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemarks[0];

    setState(()  {
       Address = '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';

    });
  }

  Future<bool> _handlePermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await _geolocatorPlatform.isLocationServiceEnabled();
    if (!serviceEnabled) {
   
      return false;
    }

    permission = await _geolocatorPlatform.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await _geolocatorPlatform.requestPermission();
      if (permission == LocationPermission.denied) {
     

        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
     

      return false;
    }

 
    return true;
  }


  void _onAddMarker(BuildContext context)async {
    await GetAddressFromLatLong(_myLoc);
    Map <String , dynamic > sendData = Map();
    sendData["loc_latLng"] = _myLoc;
    sendData["loc_name"] = Address;
    Navigator.pop(context, sendData);
  }

  _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }


  _onCameraMove(CameraPosition position) {

    _myLoc=LatLng(position.target.latitude, position.target.longitude);
    _lastMapPostion = position.target;
 
       count++;
       if(count.remainder(by)==0){ GetAddressFromLatLong(position.target);}

  }


}
