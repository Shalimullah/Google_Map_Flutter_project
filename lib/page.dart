import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Location _locationController = Location();
  LatLng? _currentP; // ✅ Store current position

  static const LatLng _pGooglePlex = LatLng(37.4223, -122.0848);
  static const LatLng _pApplePark = LatLng(37.3346, -122.0090);

  @override
  void initState() {
    super.initState();
    getLocationUpdates();
  }

  Future<void> getLocationUpdates() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    // ✅ Check if service enabled
    serviceEnabled = await _locationController.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _locationController.requestService();
      if (!serviceEnabled) return;
    }

    // ✅ Check for permission
    permissionGranted = await _locationController.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _locationController.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }

    // ✅ Listen to location changes
    _locationController.onLocationChanged.listen((LocationData currentLocation) {
      if (currentLocation.latitude != null && currentLocation.longitude != null) {
        setState(() {
          _currentP = LatLng(currentLocation.latitude!, currentLocation.longitude!);
        });
        print(_currentP);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Map Example'),
      ),
      body: _currentP == null
          ? const Center(child: Text("Loading...")) // ✅ Show loading until location found
          : GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _currentP ?? _pGooglePlex, // ✅ Start from current location if available
          zoom: 14,
        ),
        markers: {
          Marker(
            markerId: const MarkerId("googlePlex"),
            icon: BitmapDescriptor.defaultMarker,
            position: _pGooglePlex,
          ),
          Marker(
            markerId: const MarkerId("applePark"),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
            position: _pApplePark,
          ),
          if (_currentP != null)
            Marker(
              markerId: const MarkerId("currentLocation"),
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
              position: _currentP!,
            ),
        },
      ),
    );
  }
}
