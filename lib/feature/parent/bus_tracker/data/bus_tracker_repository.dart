import 'package:geolocator/geolocator.dart';

class BusTrackerRepository {
  Future<Stream<Position>> startBusTrackingStream() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('الرجاء تفعيل خدمات الـ GPS في الهاتف أولاً.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('تم رفض صلاحية الوصول للموقع الجغرافي.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('صلاحيات الموقع مرفوضة دائماً، يرجى تفعيلها من إعدادات النظام.');
    }

    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 5, 
    );

    return Geolocator.getPositionStream(locationSettings: locationSettings);
  }
}

