import 'dart:math' show asin, cos, pi, pow, sin, sqrt;

class DistanceCalculator {
  static double calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const earthRadius = 6371.0; // Earth's radius in kilometers

    // Convert degrees to radians
    final lat1Rad = _toRadians(lat1);
    final lon1Rad = _toRadians(lon1);
    final lat2Rad = _toRadians(lat2);
    final lon2Rad = _toRadians(lon2);

    // Calculate the differences between the latitudes and longitudes
    final deltaLat = lat2Rad - lat1Rad;
    final deltaLon = lon2Rad - lon1Rad;

    // Use the Haversine formula to calculate the distance
    final a = sin(deltaLat / 2) * sin(deltaLat / 2) +
        cos(lat1Rad) * cos(lat2Rad) * sin(deltaLon / 2) * sin(deltaLon / 2);
    final c = 2 * asin(sqrt(a));
    final distance = earthRadius * c * 1000; // Convert to meters

    return distance;
  }

  static double _toRadians(double degrees) {
    return degrees * (pi / 180);
  }

  static String roundDistance(double distance, int decimalPlaces) {
    final scaleFactor = pow(10, decimalPlaces);
    final roundedDistance = (distance / scaleFactor).round() * scaleFactor;
    return "$roundedDistance";
  }
}
