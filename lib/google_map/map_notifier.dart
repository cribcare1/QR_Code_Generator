import 'package:flutter_riverpod/legacy.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'map_state.dart';

class MapNotifier extends StateNotifier<MapState> {
  MapNotifier() : super(MapState());


  GoogleMapController? mapController;


  Future<void> setMapController(GoogleMapController controller) async {
    mapController = controller;
  }


  Future<void> updateLocation(LatLng newPos) async {
    state = state.copyWith(isLoading: true);


    List<Placemark> place = await placemarkFromCoordinates(
      newPos.latitude,
      newPos.longitude,
    );


    final addr = "${place.first.name}, ${place.first.street}, ${place.first.locality}";


    state = state.copyWith(
      selectedLocation: newPos,
      address: addr,
      isLoading: false,
    );
  }
}
final mapProvider = StateNotifierProvider<MapNotifier, MapState>((ref) => MapNotifier());