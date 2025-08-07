#!/bin/bash

# Employee Geofence - Screenshot Generator
# This script generates screenshots for the app demo

echo "📱 Generating Employee Geofence Screenshots..."

# Set device ID (update this with your device ID)
DEVICE_ID="emulator-5554"

# Export ADB path
export PATH="$PATH:/Users/tinle/Library/Android/sdk/platform-tools"

# Check if device is connected
echo "🔍 Checking device connection..."
adb devices | grep -q $DEVICE_ID
if [ $? -ne 0 ]; then
    echo "❌ Device $DEVICE_ID not found. Please check device connection."
    exit 1
fi

echo "✅ Device $DEVICE_ID connected"

# Create screenshots directory if it doesn't exist
mkdir -p screenshots

# Function to take screenshot
take_screenshot() {
    local filename=$1
    local description=$2
    
    echo "📸 Taking screenshot: $filename - $description"
    
    # Take screenshot on device
    adb -s $DEVICE_ID shell screencap -p /sdcard/$filename
    
    # Pull screenshot to local directory
    adb -s $DEVICE_ID pull /sdcard/$filename screenshots/
    
    # Clean up on device
    adb -s $DEVICE_ID shell rm /sdcard/$filename
    
    echo "✅ Screenshot saved: screenshots/$filename"
}

# Generate screenshots for different app states
echo "🎬 Starting screenshot generation..."

# 1. Main Dashboard
echo "🏠 Taking main dashboard screenshot..."
take_screenshot "main_dashboard.png" "Main application dashboard with real-time location tracking"

# 2. Location Permission Dialog
echo "📍 Taking location permission screenshot..."
take_screenshot "location_permission.png" "Location permission request dialog"

# 3. Notification Permission Dialog
echo "🔔 Taking notification permission screenshot..."
take_screenshot "notification_permission.png" "Notification permission setup dialog"

# 4. Geofence Detection
echo "🎯 Taking geofence detection screenshot..."
take_screenshot "geofence_detection.png" "Active geofence monitoring with distance calculations"

# 5. Event History
echo "📋 Taking event history screenshot..."
take_screenshot "event_history.png" "Geofence event history with timestamps"

# 6. Add Custom Location
echo "➕ Taking add location screenshot..."
take_screenshot "add_location.png" "Add custom location form with coordinate input"

echo "🎉 All screenshots generated successfully!"
echo "📁 Screenshots saved in: screenshots/"
echo ""
echo "📸 Generated screenshots:"
ls -la screenshots/*.png

echo ""
echo "🚀 Next steps:"
echo "1. Review screenshots in screenshots/ directory"
echo "2. Update README.md if needed"
echo "3. Use screenshots for demo presentations"
echo "4. Share with stakeholders" 