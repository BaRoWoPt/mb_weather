import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationNotifier extends ChangeNotifier {
  LatLng _coords = const LatLng(0, 0);
  LatLng get coords => _coords;

  /// Lấy vị trí hiện tại
  Future<void> getLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      _coords = LatLng(position.latitude, position.longitude);
      notifyListeners();
    } catch (e) {
      return Future.error("Failed to get location: $e");
    }
  }

  /// Yêu cầu quyền truy cập vị trí
  Future<bool> requestPermission() async {
    LocationPermission permission = await Geolocator.requestPermission();
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  /// Trả về vị trí hiện tại (không thay đổi state)
  Future<LatLng?> getCurrentPosition() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      return LatLng(position.latitude, position.longitude);
    } catch (e) {
      print("Lỗi khi lấy vị trí hiện tại: $e");
      return null; // Trả về null nếu không lấy được vị trí
    }
  }
}

final locationProvider = ChangeNotifierProvider<LocationNotifier>((ref) {
  final coords = LocationNotifier();
  coords.getLocation();
  return coords;
});

class PermissionNotifier extends StateNotifier<bool> {
  PermissionNotifier() : super(false);

  Future<bool> getPerms() async {
    bool locationService = await Geolocator.isLocationServiceEnabled();
    LocationPermission permission = await Geolocator.checkPermission();
    if (locationService == true && permission != LocationPermission.denied) {
      return true;
    } else {
      return false;
    }
  }
}

final permissionProvider = StateNotifierProvider<PermissionNotifier, bool>(
  (ref) => PermissionNotifier(),
);
