import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../location_helper.dart';
import 'map_screen.dart';

class MapHomeScreen extends ConsumerWidget {
  const MapHomeScreen({super.key});


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home Screen")),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            bool allowed = await LocationHelper.checkPermissions();


            if (!allowed) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Please enable location services")),
              );
              Geolocator.openLocationSettings();
              return;
            }


            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MapScreen()),
            );
          },
          child: const Text("Open Map"),
        ),
      ),
    );
  }
}