import 'package:geofence_locator/services/mock_api_service.dart';

void main() async {
  print('🔄 Testing Mock API Radius Update...');

  final mockApi = MockApiService();

  // Test 1: Update Ho Chi Minh radius to 500m
  print('\n📝 Test 1: Update Ho Chi Minh radius to 500m');
  bool success1 = await mockApi.updateHoChiMinhRadius(500);
  print('Result: ${success1 ? '✅ Success' : '❌ Failed'}');

  // Test 2: Update Hanoi radius to 200m
  print('\n📝 Test 2: Update Hanoi radius to 200m');
  bool success2 = await mockApi.updateLocationRadius('2', 200);
  print('Result: ${success2 ? '✅ Success' : '❌ Failed'}');

  // Test 3: Fetch updated data
  print('\n📝 Test 3: Fetch updated data from backend');
  final locations = await mockApi.fetchLocations();
  print('Total locations: ${locations.length}');

  // Show Ho Chi Minh and Hanoi data
  for (var location in locations) {
    if (location.id == '1' || location.id == '2') {
      print('📍 ${location.name}: ${location.radius}m radius');
    }
  }

  print('\n✅ Mock API testing completed!');
  print(
    '💡 Now you can use the refresh button in the app to see the updated radius values.',
  );
}
