import 'package:latlong2/latlong.dart';

abstract class BusTrackerState {
  const BusTrackerState();
}

class BusTrackerInitial extends BusTrackerState {}

class BusTrackerLoading extends BusTrackerState {
  final String message;
  const BusTrackerLoading(this.message);
}

class BusTrackerSuccess extends BusTrackerState {
  final LatLng busPosition;
  final double busRotation;
  final String statusMessage;

  const BusTrackerSuccess({
    required this.busPosition,
    required this.busRotation,
    required this.statusMessage,
  });
}

class BusTrackerFailure extends BusTrackerState {
  final String errorMessage;
  const BusTrackerFailure(this.errorMessage);
}
