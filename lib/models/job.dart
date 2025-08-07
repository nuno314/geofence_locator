class Job {
  final String id;
  final String title;
  final String description;
  final double latitude;
  final double longitude;
  final double radius; // in meters
  final String workerId;
  final bool isActive;
  final DateTime createdAt;

  Job({
    required this.id,
    required this.title,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.radius,
    required this.workerId,
    this.isActive = true,
    required this.createdAt,
  });

  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'radius': radius,
      'workerId': workerId,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Create from JSON
  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      radius: json['radius'],
      workerId: json['workerId'],
      isActive: json['isActive'] ?? true,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  // Copy with modifications
  Job copyWith({
    String? id,
    String? title,
    String? description,
    double? latitude,
    double? longitude,
    double? radius,
    String? workerId,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return Job(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      radius: radius ?? this.radius,
      workerId: workerId ?? this.workerId,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
