import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/job.dart';
import '../models/location.dart';
import '../models/geofence_event.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  static const String _jobsKey = 'jobs';
  static const String _locationsKey = 'locations';
  static const String _eventsKey = 'geofence_events';

  // ===== JOBS =====
  // Save jobs to local storage
  Future<void> saveJobs(List<Job> jobs) async {
    final prefs = await SharedPreferences.getInstance();
    final jobsJson = jobs.map((job) => job.toJson()).toList();
    await prefs.setString(_jobsKey, jsonEncode(jobsJson));
  }

  // Load jobs from local storage
  Future<List<Job>> loadJobs() async {
    final prefs = await SharedPreferences.getInstance();
    final jobsString = prefs.getString(_jobsKey);

    if (jobsString == null) {
      return [];
    }

    try {
      final jobsJson = jsonDecode(jobsString) as List;
      return jobsJson.map((json) => Job.fromJson(json)).toList();
    } catch (e) {
      print('Error loading jobs: $e');
      return [];
    }
  }

  // Add a new job
  Future<void> addJob(Job job) async {
    final jobs = await loadJobs();
    jobs.add(job);
    await saveJobs(jobs);
  }

  // Update an existing job
  Future<void> updateJob(Job updatedJob) async {
    final jobs = await loadJobs();
    final index = jobs.indexWhere((job) => job.id == updatedJob.id);

    if (index != -1) {
      jobs[index] = updatedJob;
      await saveJobs(jobs);
    }
  }

  // Delete a job
  Future<void> deleteJob(String jobId) async {
    final jobs = await loadJobs();
    jobs.removeWhere((job) => job.id == jobId);
    await saveJobs(jobs);
  }

  // Get a specific job by ID
  Future<Job?> getJob(String jobId) async {
    final jobs = await loadJobs();
    try {
      return jobs.firstWhere((job) => job.id == jobId);
    } catch (e) {
      return null;
    }
  }

  // Clear all jobs
  Future<void> clearAllJobs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_jobsKey);
  }

  // ===== LOCATIONS =====
  // Save locations to local storage
  Future<void> saveLocations(List<Location> locations) async {
    final prefs = await SharedPreferences.getInstance();
    final locationsJson = locations
        .map((location) => location.toJson())
        .toList();
    await prefs.setString(_locationsKey, jsonEncode(locationsJson));
  }

  // Load locations from local storage
  Future<List<Location>> loadLocations() async {
    final prefs = await SharedPreferences.getInstance();
    final locationsString = prefs.getString(_locationsKey);

    if (locationsString == null) {
      return [];
    }

    try {
      final locationsJson = jsonDecode(locationsString) as List;
      return locationsJson.map((json) => Location.fromJson(json)).toList();
    } catch (e) {
      print('Error loading locations: $e');
      return [];
    }
  }

  // Update location status
  Future<void> updateLocationStatus(String locationId, bool isActive) async {
    final locations = await loadLocations();
    final index = locations.indexWhere((location) => location.id == locationId);

    if (index != -1) {
      final location = locations[index];
      locations[index] = location.copyWith(isActive: isActive);
      await saveLocations(locations);
    }
  }

  // ===== GEOFENCE EVENTS =====
  // Save events to local storage
  Future<void> saveEvents(List<GeofenceEvent> events) async {
    final prefs = await SharedPreferences.getInstance();
    final eventsJson = events.map((event) => event.toJson()).toList();
    await prefs.setString(_eventsKey, jsonEncode(eventsJson));
  }

  // Load events from local storage
  Future<List<GeofenceEvent>> loadEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final eventsString = prefs.getString(_eventsKey);

    if (eventsString == null) {
      return [];
    }

    try {
      final eventsJson = jsonDecode(eventsString) as List;
      return eventsJson.map((json) => GeofenceEvent.fromJson(json)).toList();
    } catch (e) {
      print('Error loading events: $e');
      return [];
    }
  }

  // Add a new event
  Future<void> addEvent(GeofenceEvent event) async {
    final events = await loadEvents();
    events.add(event);
    await saveEvents(events);
  }

  // Get events for a specific location
  Future<List<GeofenceEvent>> getEventsForLocation(String locationId) async {
    final events = await loadEvents();
    return events.where((event) => event.locationId == locationId).toList();
  }

  // Get recent events (last 30 days)
  Future<List<GeofenceEvent>> getRecentEvents() async {
    final events = await loadEvents();
    final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
    return events
        .where((event) => event.timestamp.isAfter(thirtyDaysAgo))
        .toList();
  }

  // Clear all events
  Future<void> clearAllEvents() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_eventsKey);
  }

  // Get events by date range
  Future<List<GeofenceEvent>> getEventsByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    final events = await loadEvents();
    return events
        .where(
          (event) =>
              event.timestamp.isAfter(start) && event.timestamp.isBefore(end),
        )
        .toList();
  }
}
