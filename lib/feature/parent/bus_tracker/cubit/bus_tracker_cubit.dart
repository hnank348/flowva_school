import 'dart:async';
import 'package:flowva_school/feature/parent/bus_tracker/data/bus_tracker_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'bus_tracker_state.dart';

class BusTrackerCubit extends Cubit<BusTrackerState> {
  final BusTrackerRepository _repository;
  StreamSubscription<Position>? _trackerSubscription;
  
  LatLng _currentPosition = const LatLng(33.5138, 36.2765); 
  double _currentRotation = 0.0;

  BusTrackerCubit(this._repository) : super(BusTrackerInitial());

  void startTracking() async {
    emit(const BusTrackerLoading("جاري الاتصال الآمن بمستشعر الـ GPS..."));
    try {
      final stream = await _repository.startBusTrackingStream();
      
      emit(BusTrackerSuccess(
        busPosition: _currentPosition,
        busRotation: _currentRotation,
        statusMessage: "متصل - جاري مراقبة خط سير الحافلة الآن",
      ));

      _trackerSubscription = stream.listen((Position position) {
        _processNewLocation(LatLng(position.latitude, position.longitude));
      });
    } catch (e) {
      emit(BusTrackerFailure(e.toString()));
    }
  }

  void _processNewLocation(LatLng newLocation) {
    if (_currentPosition.latitude == newLocation.latitude && 
        _currentPosition.longitude == newLocation.longitude) return;

    _currentRotation = Geolocator.bearingBetween(
      _currentPosition.latitude,
      _currentPosition.longitude,
      newLocation.latitude,
      newLocation.longitude,
    );

    _currentPosition = newLocation;

    emit(BusTrackerSuccess(
      busPosition: _currentPosition,
      busRotation: _currentRotation,
      statusMessage: "تم تحديث موقع الحافلة الحي",
    ));
  }

  @override
  Future<void> close() {
    _trackerSubscription?.cancel();
    return super.close();
  }
}
