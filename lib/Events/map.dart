import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapDetails extends StatefulWidget {
  final double lat;
  final double long;
  final String title;
  final String id;

  const MapDetails(
      {Key? key,
      required this.lat,
      required this.long,
      required this.title,
      required this.id})
      : super(key: key);

  @override
  State<MapDetails> createState() => _MapDetailsState();
}

class _MapDetailsState extends State<MapDetails> {
  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition:
          CameraPosition(target: LatLng(widget.lat, widget.long), zoom: 14),
      // ignore: prefer_collection_literals
      markers: [
        Marker(
            markerId: MarkerId('${widget.id}'),
            infoWindow: InfoWindow(
              title: widget.title,
            ),
            position: LatLng(widget.lat, widget.long))
      ].toSet(),
    );
  }
}
