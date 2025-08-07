import '../models/location.dart';

class MockApiService {
  static final MockApiService _instance = MockApiService._internal();
  factory MockApiService() => _instance;

  // Mock data storage
  List<Location> _mockLocations = [];

  MockApiService._internal() {
    _initializeMockData();
  }

  void _initializeMockData() {
    _mockLocations = [
      // Vietnam Locations
      Location(
        id: '1',
        name: 'Ho Chi Minh City Office',
        address: '123 Nguyen Hue Street, District 1, Ho Chi Minh City, Vietnam',
        latitude: 10.7769,
        longitude: 106.7009,
        radius: 3000,
        description: 'Main office in Ho Chi Minh City',
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
      ),
      Location(
        id: '2',
        name: 'Hanoi Branch',
        address: '456 Ba Dinh Square, Ba Dinh District, Hanoi, Vietnam',
        latitude: 21.0285,
        longitude: 105.8542,
        radius: 150,
        description: 'Northern branch office in Hanoi',
        createdAt: DateTime.now().subtract(const Duration(days: 25)),
      ),
      Location(
        id: '3',
        name: 'Da Nang Factory',
        address: '789 Hai Phong Street, Hai Chau District, Da Nang, Vietnam',
        latitude: 16.0544,
        longitude: 108.2022,
        radius: 200,
        description: 'Manufacturing facility in Da Nang',
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
      ),

      // Thailand Locations
      Location(
        id: '4',
        name: 'Bangkok Headquarters',
        address: '321 Silom Road, Bang Rak, Bangkok 10500, Thailand',
        latitude: 13.7563,
        longitude: 100.5018,
        radius: 120,
        description: 'Main headquarters in Bangkok',
        createdAt: DateTime.now().subtract(const Duration(days: 28)),
      ),
      Location(
        id: '5',
        name: 'Chiang Mai Branch',
        address: '654 Nimman Road, Suthep, Chiang Mai 50200, Thailand',
        latitude: 18.7883,
        longitude: 98.9853,
        radius: 100,
        description: 'Northern Thailand branch office',
        createdAt: DateTime.now().subtract(const Duration(days: 22)),
      ),
      Location(
        id: '6',
        name: 'Phuket Resort',
        address: '987 Patong Beach Road, Patong, Phuket 83150, Thailand',
        latitude: 7.8804,
        longitude: 98.3923,
        radius: 80,
        description: 'Tourism and hospitality center',
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
      ),
      Location(
        id: '7',
        name: 'Pattaya Office',
        address: '147 Walking Street, Pattaya, Chonburi 20150, Thailand',
        latitude: 12.9236,
        longitude: 100.8824,
        radius: 90,
        description: 'Eastern Thailand regional office',
        createdAt: DateTime.now().subtract(const Duration(days: 18)),
      ),

      // Malaysia Locations
      Location(
        id: '8',
        name: 'Kuala Lumpur Main Office',
        address: '258 Jalan Tun Razak, Kuala Lumpur 50400, Malaysia',
        latitude: 3.1390,
        longitude: 101.6869,
        radius: 110,
        description: 'Primary office in Kuala Lumpur',
        createdAt: DateTime.now().subtract(const Duration(days: 35)),
      ),
      Location(
        id: '9',
        name: 'Penang Branch',
        address: '369 George Town, Penang 10000, Malaysia',
        latitude: 5.4164,
        longitude: 100.3327,
        radius: 95,
        description: 'Northern Malaysia branch',
        createdAt: DateTime.now().subtract(const Duration(days: 24)),
      ),
      Location(
        id: '10',
        name: 'Johor Bahru Factory',
        address: '741 Tebrau Highway, Johor Bahru 81100, Malaysia',
        latitude: 1.4927,
        longitude: 103.7414,
        radius: 180,
        description: 'Manufacturing plant in Johor Bahru',
        createdAt: DateTime.now().subtract(const Duration(days: 12)),
      ),
      Location(
        id: '11',
        name: 'Malacca Office',
        address: '852 Jonker Street, Malacca 75200, Malaysia',
        latitude: 2.1896,
        longitude: 102.2501,
        radius: 85,
        description: 'Historical city branch office',
        createdAt: DateTime.now().subtract(const Duration(days: 16)),
      ),
      Location(
        id: '12',
        name: 'Ipoh Regional Center',
        address: '963 Jalan Sultan Idris Shah, Ipoh 30000, Malaysia',
        latitude: 4.5979,
        longitude: 101.0901,
        radius: 100,
        description: 'Perak state regional center',
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
      ),
    ];
  }

  // Simulate API delay
  Future<List<Location>> getMockLocations() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockLocations;
  }

  // Simulate API call delay
  Future<List<Location>> fetchLocations() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockLocations;
  }

  // Update radius for a specific location (simulate backend update)
  Future<bool> updateLocationRadius(String locationId, int newRadius) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final index = _mockLocations.indexWhere(
      (location) => location.id == locationId,
    );
    if (index != -1) {
      final location = _mockLocations[index];
      _mockLocations[index] = location.copyWith(radius: newRadius.toDouble());
      print('✅ Mock API: Updated radius for ${location.name} to ${newRadius}m');
      return true;
    }
    return false;
  }

  // Update radius for Ho Chi Minh City Office (for testing)
  Future<bool> updateHoChiMinhRadius(int newRadius) async {
    return await updateLocationRadius('1', newRadius);
  }

  // Simulate updating location status
  Future<bool> updateLocationStatus(String locationId, bool isActive) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return true;
  }

  // Get current mock data (for debugging)
  List<Location> getCurrentMockData() {
    return _mockLocations;
  }
}
