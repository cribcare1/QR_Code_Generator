import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapState {
  final LatLng? selectedLocation;
  final String? address;
  final bool isLoading;


  MapState({this.selectedLocation, this.address, this.isLoading = false});


  MapState copyWith({LatLng? selectedLocation, String? address, bool? isLoading}) {
    return MapState(
      selectedLocation: selectedLocation ?? this.selectedLocation,
      address: address ?? this.address,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}