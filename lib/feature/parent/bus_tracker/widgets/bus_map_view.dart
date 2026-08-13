
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flowva_school/app_theme.dart';

class BusMapView extends StatelessWidget {
  final LatLng busPosition;
  final double busRotation;
  final MapController mapController;
  final Function(MapPosition, bool) onPositionChanged;

  const BusMapView({
    super.key,
    required this.busPosition,
    required this.busRotation,
    required this.mapController,
    required this.onPositionChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? AppColors.darkPrimaryTeal : AppColors.primaryTeal;

    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        initialCenter: busPosition,
        initialZoom: 15.0,
        maxZoom: 18.0,
        minZoom: 6.0,
        onPositionChanged: onPositionChanged,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.school.bus_tracker_app',
        ),
        
        TweenAnimationBuilder<LatLng>(
          tween: Tween<LatLng>(begin: busPosition, end: busPosition),
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          builder: (context, animatedPosition, child) {
            return MarkerLayer(
              markers: [
                Marker(
                  point: animatedPosition,
                  width: 65,
                  height: 65,
                  child: TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: busRotation, end: busRotation),
                    duration: const Duration(milliseconds: 300),
                    builder: (context, animatedRotation, child) {
                      return Transform.rotate(
                        angle: animatedRotation * (3.141592653589793 / 180),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.2),
                            shape: BoxShape.circle,
                            border: Border.all(color: primaryColor, width: 2),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.darkSurface : Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                )
                              ],
                            ),
                            child: Icon(
                              Icons.directions_bus_rounded,
                              color: primaryColor,
                              size: 32,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
