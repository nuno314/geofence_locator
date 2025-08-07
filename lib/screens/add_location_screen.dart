import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import '../l10n/app_localizations.dart';
import '../blocs/location/location_bloc.dart';
import '../blocs/location/location_event.dart';
import '../models/location.dart';

class AddLocationScreen extends StatefulWidget {
  const AddLocationScreen({super.key});

  @override
  State<AddLocationScreen> createState() => _AddLocationScreenState();
}

class _AddLocationScreenState extends State<AddLocationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _addressController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();
  final _radiusController = TextEditingController();

  double _latitude = 0.0;
  double _longitude = 0.0;
  bool _useCurrentLocation = false;
  bool _isLoadingLocation = false;

  @override
  void initState() {
    super.initState();
    _radiusController.text = '100'; // Default radius
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    _radiusController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoadingLocation = true;
    });

    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _latitude = position.latitude;
        _longitude = position.longitude;
        _latitudeController.text = _latitude.toStringAsFixed(6);
        _longitudeController.text = _longitude.toStringAsFixed(6);
        _isLoadingLocation = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingLocation = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${AppLocalizations.of(context)?.errorGettingLocation ?? 'Error getting location'}: $e',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _saveLocation() {
    if (_formKey.currentState!.validate()) {
      final location = Location(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        description: _descriptionController.text,
        latitude: double.parse(_latitudeController.text),
        longitude: double.parse(_longitudeController.text),
        radius: double.parse(_radiusController.text),
        address: _addressController.text,
        createdAt: DateTime.now(),
      );

      context.read<LocationBloc>().add(AddLocation(location));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)?.addCustomLocation ?? 'Add New Location',
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Location Name
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText:
                      AppLocalizations.of(context)?.jobTitle ?? 'Location Name',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.business),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)?.pleaseEnterJobTitle ??
                        'Please enter a location name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Address
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)?.address ?? 'Address',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.location_on),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(
                          context,
                        )?.pleaseEnterDescription ??
                        'Please enter an address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Description
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText:
                      AppLocalizations.of(context)?.description ??
                      'Description',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.description),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(
                          context,
                        )?.pleaseEnterDescription ??
                        'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Current Location Button
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)?.jobLocation ??
                            'Location Coordinates',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _isLoadingLocation
                                  ? null
                                  : _getCurrentLocation,
                              icon: _isLoadingLocation
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Icon(Icons.my_location),
                              label: Text(
                                _isLoadingLocation
                                    ? AppLocalizations.of(context)?.loading ??
                                          'Getting...'
                                    : AppLocalizations.of(
                                            context,
                                          )?.useCurrentLocation ??
                                          'Use Current Location',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Latitude and Longitude
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _latitudeController,
                      decoration: const InputDecoration(
                        labelText: 'Latitude',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.explore),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        final lat = double.tryParse(value);
                        if (lat == null || lat < -90 || lat > 90) {
                          return 'Invalid latitude';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _longitudeController,
                      decoration: const InputDecoration(
                        labelText: 'Longitude',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.explore_outlined),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        final lng = double.tryParse(value);
                        if (lng == null || lng < -180 || lng > 180) {
                          return 'Invalid longitude';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Radius
              TextFormField(
                controller: _radiusController,
                decoration: InputDecoration(
                  labelText:
                      AppLocalizations.of(context)?.geofenceRadius ??
                      'Geofence Radius (meters)',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.radio_button_checked),
                  suffixText: 'm',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)?.pleaseEnterRadius ??
                        'Please enter a radius';
                  }
                  final radius = double.tryParse(value);
                  if (radius == null || radius <= 0) {
                    return AppLocalizations.of(
                          context,
                        )?.pleaseEnterValidRadius ??
                        'Please enter a valid radius';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Create Button
              ElevatedButton(
                onPressed: _saveLocation,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                ),
                child: Text(
                  AppLocalizations.of(context)?.createJob ?? 'Create Location',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
