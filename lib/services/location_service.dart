import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationService {
  static Future<String> getCurrentCity() async {
    try {
      // Request location permission if not already granted
      PermissionStatus permission = await Permission.location.request();

      if (permission.isGranted) {
        Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low);

        // Retrieve placemarks for the given coordinates
        List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

        // Extract city name from the first placemark
        String cityName = placemarks[0].locality ?? 'Unknown City';

        // Return the city name
        return cityName;
      } else if (permission.isDenied) {
        print('Location permission denied');
        return 'Location permission denied';
      } else if (permission.isPermanentlyDenied) {
        print('Location permission permanently denied');
        return 'Location permission permanently denied';
      } else {
        return 'Location permission not granted';
      }
    } on PlatformException catch (e) {
      print('Error fetching location: $e');
      return 'Location error';
    } catch (e) {
      print('General error: $e');
      return 'Not found';
    }
  }

  static List<String> getCitySuggestions(String query) {
    List<String> cities = [
      'Chandigarh', 'Mohali', 'Ambala', 'Panchkula', 'Zirakpur'
      // Add more cities as needed
    ];

    return cities.where((city) => city.toLowerCase().contains(query.toLowerCase())).toList();
  }
}
