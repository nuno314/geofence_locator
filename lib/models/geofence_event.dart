enum EventType { enter, exit }

class GeofenceEvent {
  final String id;
  final String locationId;
  final String locationName;
  final EventType eventType;
  final double latitude;
  final double longitude;
  final DateTime timestamp;
  final String? notes;

  GeofenceEvent({
    required this.id,
    required this.locationId,
    required this.locationName,
    required this.eventType,
    required this.latitude,
    required this.longitude,
    required this.timestamp,
    this.notes,
  });

  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'locationId': locationId,
      'locationName': locationName,
      'eventType': eventType.name,
      'latitude': latitude,
      'longitude': longitude,
      'timestamp': timestamp.toIso8601String(),
      'notes': notes,
    };
  }

  // Create from JSON
  factory GeofenceEvent.fromJson(Map<String, dynamic> json) {
    return GeofenceEvent(
      id: json['id'],
      locationId: json['locationId'],
      locationName: json['locationName'],
      eventType: EventType.values.firstWhere(
        (e) => e.name == json['eventType'],
      ),
      latitude: json['latitude'],
      longitude: json['longitude'],
      timestamp: DateTime.parse(json['timestamp']),
      notes: json['notes'],
    );
  }

  // Get display text for event type
  String get eventTypeText {
    switch (eventType) {
      case EventType.enter:
        return 'Entered';
      case EventType.exit:
        return 'Exited';
    }
  }

  // Get icon for event type
  String get eventIcon {
    switch (eventType) {
      case EventType.enter:
        return '🚪';
      case EventType.exit:
        return '🚶';
    }
  }
}
