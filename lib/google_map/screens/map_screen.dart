import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/model/place_details.dart' hide Location;

import '../map_notifier.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});


  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}
class _MapScreenState extends ConsumerState<MapScreen> {
  LatLng? initialPosition;


  @override
  void initState() {
    super.initState();
    _loadCurrentLocation();
  }


  Future<void> _loadCurrentLocation() async {
    Position pos = await Geolocator.getCurrentPosition();


    setState(() {
      initialPosition = LatLng(pos.latitude, pos.longitude);
    });


    ref.read(mapProvider.notifier).updateLocation(initialPosition!);
  }
  @override
  Widget build(BuildContext context) {
    final mapState = ref.watch(mapProvider);


    return Scaffold(
      appBar: AppBar(
        title: const Text("Pick Location"),
      ),
      body: initialPosition == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
        children: [
      GoogleMap(
      initialCameraPosition: CameraPosition(
      target: initialPosition!,
        zoom: 14,
      ),onCameraIdle: () {
      if (ref.read(mapProvider.notifier).mapController != null) {
        ref.read(mapProvider.notifier).mapController!
            .getLatLng(ScreenCoordinate(x: 200, y: 400))
            .then((pos) {
          ref.read(mapProvider.notifier).updateLocation(pos);
        });
      }
    },
      onMapCreated: (controller) {
        ref.read(mapProvider.notifier).setMapController(controller);
      },
      myLocationEnabled: true,
    ),
    //------------------------------------
// SEARCH FIELD
//------------------------------------
    Positioned(
    top: 10,
    left: 10,
    right: 10,
    child: TextField(
    decoration: InputDecoration(
    hintText: "Search address",
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    ),
    ),
    onSubmitted: (value) async {
    List<Location> locations = await locationFromAddress(value);
    LatLng pos = LatLng(locations.first.latitude, locations.first.longitude);


    ref.read(mapProvider.notifier).updateLocation(pos);
    ref.read(mapProvider.notifier).mapController?.animateCamera(
    CameraUpdate.newLatLng(pos),
    );
    },
    ),
    ),
    //------------------------------------
// BOTTOM ADDRESS + SUBMIT BUTTON
//------------------------------------
    Positioned(
    bottom: 0,
    left: 0,
    right: 0,
    child: Container(
    padding: const EdgeInsets.all(16),
    decoration: const BoxDecoration(
    color: Colors.white,
    boxShadow: [
    BoxShadow(color: Colors.black26, blurRadius: 8),
    ],
    ),
    child: Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Text(
    mapState.address ?? "Fetching address...",
    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
    ),
    const SizedBox(height: 10),
    ElevatedButton(
    onPressed: () {
    Navigator.push(
    context,
    MaterialPageRoute(
    builder: (_) => NextScreen(
    address: mapState.address ?? "",
    lat: mapState.selectedLocation?.latitude ?? 0.0,
    lng: mapState.selectedLocation?.longitude ?? 0.0,
    ),
    ),
    );
    },
    child: const Text("Submit"),
    )
    ],
    ),
    ),
    )
        ],
      ),
    );
  }
}
//----------------------------------------------
// NEXT SCREEN
//----------------------------------------------
class NextScreen extends StatelessWidget {
  final String address;
  final double lat;
  final double lng;


  const NextScreen({super.key, required this.address, required this.lat, required this.lng});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Next Screen")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Address: $address"),
            Text("Lat: $lat"),
            Text("Lng: $lng"),
          ],
        ),
      ),
    );
  }
}