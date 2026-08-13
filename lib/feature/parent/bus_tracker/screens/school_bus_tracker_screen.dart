
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flowva_school/app_theme.dart';
import '../cubit/bus_tracker_cubit.dart';
import '../cubit/bus_tracker_state.dart';
import '../widgets/bus_map_view.dart';
import '../widgets/tracker_status_card.dart';

class SchoolBusTrackerScreen extends StatefulWidget {
  const SchoolBusTrackerScreen({super.key});

  @override
  State<SchoolBusTrackerScreen> createState() => _SchoolBusTrackerScreenState();
}

class _SchoolBusTrackerScreenState extends State<SchoolBusTrackerScreen> {
  final MapController _mapController = MapController();
  bool _isAutoTrackEnabled = true; 

  @override
  void initState() {
    super.initState();
    context.read<BusTrackerCubit>().startTracking();
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? AppColors.darkPrimaryTeal : AppColors.primaryTeal;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor, 
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
        title: Text(
          'تتبع باص المدرسة مباشر', 
          style: AppStyles.titleStyle.copyWith(
            fontSize: AppSizes.fontSizeSubtitle, 
            fontWeight: FontWeight.bold, 
            color: Colors.white, 
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocConsumer<BusTrackerCubit, BusTrackerState>(
        listener: (context, state) {
          if (state is BusTrackerSuccess && _isAutoTrackEnabled) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                double currentZoom = 15.0;
                try {
                  currentZoom = _mapController.camera.zoom;
                } catch (_) {}
                _mapController.move(state.busPosition, currentZoom);
              }
            });
          }
        },
        builder: (context, state) {
          if (state is BusTrackerLoading) {
            return Center(child: CircularProgressIndicator(color: primaryColor));
          }

          if (state is BusTrackerFailure) {
            return Center(
              child: TrackerStatusCard(
                message: state.errorMessage,
                icon: Icons.error_outline_rounded,
                iconColor: AppColors.errorRed,
              ),
            );
          }

          if (state is BusTrackerSuccess) {
            return Stack(
              children: [
                BusMapView(
                  busPosition: state.busPosition,
                  busRotation: state.busRotation,
                  mapController: _mapController,
                  onPositionChanged: (camera, hasGesture) {
                    if (hasGesture && _isAutoTrackEnabled) {
                      setState(() {
                        _isAutoTrackEnabled = false;
                      });
                    }
                  },
                ),
                
                Positioned(
                  top: AppSizes.paddingMedium,
                  left: AppSizes.paddingMedium,
                  right: AppSizes.paddingMedium,
                  child: TrackerStatusCard(
                    message: state.statusMessage,
                    icon: Icons.directions_bus_filled_rounded,
                    iconColor: primaryColor,
                  ),
                ),

                if (!_isAutoTrackEnabled)
                  Positioned(
                    bottom: AppSizes.paddingLarge,
                    right: AppSizes.paddingLarge,
                    child: FloatingActionButton.extended(
                      onPressed: () {
                        setState(() {
                          _isAutoTrackEnabled = true;
                        });
                        _mapController.move(state.busPosition, _mapController.camera.zoom);
                      },
                      backgroundColor: primaryColor,
                      icon: const Icon(Icons.gps_fixed_rounded, color: Colors.white),
                      label: const Text(
                        'إعادة مركزة الحافلة',
                        style: TextStyle(color: Colors.white, fontFamily: 'Cairo', fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
