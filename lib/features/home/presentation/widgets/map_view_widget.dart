import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/models/map_place.dart';
import '../../../../shared/services/map_service.dart';
import '../../../../shared/widgets/custom_network_image.dart';

class MapViewWidget extends StatefulWidget {
  const MapViewWidget({super.key});

  @override
  State<MapViewWidget> createState() => _MapViewWidgetState();
}

class _MapViewWidgetState extends State<MapViewWidget>
    with AutomaticKeepAliveClientMixin {
  GoogleMapController? _mapController;
  LatLng _currentPosition = const LatLng(
    11.9416,
    79.8083,
  ); // Puducherry default
  final Set<Marker> _markers = {};
  List<MapPlace> _places = [];
  PlaceType _selectedType = PlaceType.artisan;
  bool _isLoading = false;
  String? _error;
  StreamSubscription<Position>? _positionStreamSubscription;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _initializeLocation();
    _startLocationTracking();
    // Load all places from feed data to show on map
    _loadAllPlaces();
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    super.dispose();
  }

  Future<void> _initializeLocation() async {
    print('Initializing location...');
    try {
      // Check and request permissions first
      final hasPermissions = await MapService.checkLocationPermissions();
      if (!hasPermissions) {
        print('Location permissions denied');
        _loadNearbyPlaces(); // Load with default location
        return;
      }

      // Check if location services are enabled
      final isEnabled = await MapService.isLocationServiceEnabled();
      if (!isEnabled) {
        print('Location services are disabled');
        _loadNearbyPlaces(); // Load with default location
        return;
      }

      final position = await MapService.getCurrentLocation();
      print(
        'Got current location: ${position.latitude}, ${position.longitude}',
      );
      setState(() {
        _currentPosition = position;
      });
      _loadNearbyPlaces();
    } catch (e) {
      print('Error initializing location: $e');
      _loadNearbyPlaces(); // Load with default location
    }
  }

  Future<void> _loadNearbyPlaces() async {
    print('Loading nearby places for type: ${_selectedType.label}');
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final places = await MapService.getNearbyPlaces(
        center: _currentPosition,
        type: _selectedType,
        radiusInMeters: 5000,
      );

      print('Loaded ${places.length} places');
      setState(() {
        _places = places;
        _isLoading = false;
      });
      _updateMarkersWithAllPlaces();
    } catch (e) {
      print('Error loading places: $e');
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _loadAllPlaces() async {
    print('Loading all places from feed data');
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final allPlaces = MapService.getAllMockPlaces();
      print('Loaded ${allPlaces.length} total places for map');
      setState(() {
        _places = allPlaces;
        _isLoading = false;
      });
      _updateMarkersWithAllPlaces();
    } catch (e) {
      print('Error loading all places: $e');
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _updateMarkersWithAllPlaces() {
    _markers.clear();
    print('Updating markers with all places for position: $_currentPosition');

    // Add user location marker
    _markers.add(
      Marker(
        markerId: const MarkerId('user_location'),
        position: _currentPosition,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        infoWindow: const InfoWindow(title: 'Your Location'),
      ),
    );
    print('Added user location marker');

    // Add all place markers
    for (final place in _places) {
      _markers.add(
        Marker(
          markerId: MarkerId(place.id),
          position: place.position,
          icon: _getMarkerIcon(place.type),
          infoWindow: InfoWindow(
            title: place.name,
            snippet: place.description,
            onTap: () => _showPlaceDetails(place),
          ),
          onTap: () => _showPlaceDetails(place),
        ),
      );
    }
    print('Added ${_places.length} place markers to map');
  }

  void _filterPlacesByType(PlaceType type) {
    setState(() {
      _selectedType = type;
      _isLoading = true;
    });

    // Filter all places by selected type
    final allPlaces = MapService.getAllMockPlaces();
    final filteredPlaces = allPlaces
        .where((place) => place.type == type)
        .toList();

    setState(() {
      _places = filteredPlaces;
      _isLoading = false;
    });

    _updateMarkersWithAllPlaces();
    print('Filtered to ${filteredPlaces.length} places of type: ${type.label}');
  }

  BitmapDescriptor _getMarkerIcon(PlaceType type) {
    switch (type) {
      case PlaceType.artisan:
        return BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueViolet,
        );
      case PlaceType.touristSpot:
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
      case PlaceType.localFood:
        return BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueYellow,
        );
    }
  }

  /// Start live location tracking
  void _startLocationTracking() {
    try {
      // Check if location services are enabled
      Geolocator.isLocationServiceEnabled().then((isEnabled) {
        if (!isEnabled) {
          print('Location services are disabled');
          return;
        }

        // Start listening to position changes
        const LocationSettings locationSettings = LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10, // Update every 10 meters
        );

        _positionStreamSubscription =
            Geolocator.getPositionStream(
              locationSettings: locationSettings,
            ).listen(
              (Position position) {
                if (mounted) {
                  final newPosition = LatLng(
                    position.latitude,
                    position.longitude,
                  );
                  print(
                    'Location updated: ${position.latitude}, ${position.longitude}',
                  );
                  setState(() {
                    _currentPosition = newPosition;
                  });

                  // Optionally update the camera to follow user
                  // _mapController?.animateCamera(
                  //   CameraUpdate.newLatLng(newPosition),
                  // );
                }
              },
              onError: (error) {
                print('Error in location stream: $error');
              },
            );
      });
    } catch (e) {
      print('Error starting location tracking: $e');
    }
  }

  void _showPlaceDetails(MapPlace place) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildPlaceDetailsSheet(place),
    );
  }

  Widget _buildPlaceDetailsSheet(MapPlace place) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textSubtle.withAlpha((255 * 0.3).round()),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Place image and info
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (place.imageUrl != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CustomNetworkImage(
                    imageUrl: place.imageUrl!,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      place.name,
                      style: AppTextStyles.titleLarge.copyWith(
                        color: AppColors.textLight,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withAlpha((255 * 0.1).round()),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        place.type.label,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    if (place.rating != null) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            '${place.rating}',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textLight,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (place.reviewCount != null)
                            Text(
                              ' (${place.reviewCount} reviews)',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textSubtle,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Description
          Text(
            place.description,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textLight,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 20),

          // Contact info
          if (place.address != null) ...[
            Row(
              children: [
                Icon(Icons.location_on, color: AppColors.textSubtle, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    place.address!,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSubtle,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],

          if (place.phoneNumber != null) ...[
            Row(
              children: [
                Icon(Icons.phone, color: AppColors.textSubtle, size: 20),
                const SizedBox(width: 8),
                Text(
                  place.phoneNumber!,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSubtle,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],

          const Spacer(),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Open directions in maps app
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.directions),
                  label: const Text('Directions'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              if (place.phoneNumber != null) ...[
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Make phone call
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Icon(Icons.call),
                ),
              ],
            ],
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildTypeSelector() {
    return Container(
      height: 50,
      margin: const EdgeInsets.all(16),
      child: Row(
        children: PlaceType.values.map((type) {
          final isSelected = type == _selectedType;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedType = type;
                });
                _filterPlacesByType(type);
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.grey200,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadow,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    type.label,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: isSelected ? Colors.white : AppColors.textLight,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Stack(
      children: [
        // Google Map - Full screen
        GoogleMap(
          onMapCreated: (GoogleMapController controller) {
            _mapController = controller;
            print('Map controller created successfully');
          },
          initialCameraPosition: CameraPosition(
            target: _currentPosition,
            zoom: 14.0,
          ),
          markers: _markers,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          mapToolbarEnabled: false,
          mapType: MapType.normal,
          // Enable ALL gesture controls explicitly
          zoomGesturesEnabled: true,
          scrollGesturesEnabled: true,
          tiltGesturesEnabled: true,
          rotateGesturesEnabled: true,
          // Additional controls
          compassEnabled: true,
          indoorViewEnabled: true,
          trafficEnabled: false,
          // Ensure map consumes touch events
          onTap: (LatLng position) {
            print('Map tapped at: $position');
          },
        ),

        // Type selector - positioned to not interfere with map gestures
        Positioned(
          top: MediaQuery.of(context).padding.top + 10,
          left: 0,
          right: 0,
          child: IgnorePointer(ignoring: false, child: _buildTypeSelector()),
        ),

        // Loading indicator
        if (_isLoading)
          const Positioned.fill(
            child: Center(child: CircularProgressIndicator()),
          ),

        // Error message
        if (_error != null)
          Positioned(
            top: MediaQuery.of(context).padding.top + 80,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Text(
                _error!,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.red.shade700,
                ),
              ),
            ),
          ),

        // My location button - positioned to not interfere with map gestures
        Positioned(
          bottom: 30,
          right: 20,
          child: FloatingActionButton(
            heroTag: "map_location_fab", // Unique hero tag
            onPressed: () async {
              try {
                final position = await MapService.getCurrentLocation();
                if (!mounted) return;
                _mapController?.animateCamera(
                  CameraUpdate.newLatLngZoom(position, 15.0),
                );
                setState(() {
                  _currentPosition = position;
                });
                _loadNearbyPlaces();
              } catch (e) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Unable to get location: $e')),
                );
              }
            },
            backgroundColor: Colors.white,
            foregroundColor: AppColors.primary,
            mini: true,
            child: const Icon(Icons.my_location),
          ),
        ),
      ],
    );
  }
}
