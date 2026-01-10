# Visual Mapper

**Transform any Android device into a Home Assistant-integrated automation platform.**

## What is Visual Mapper?

Visual Mapper lets you **monitor, control, and automate** Android devices directly from Home Assistant. Create sensors from any app's UI, automate device interactions, and integrate legacy Android-only devices into your smart home.

## Use Cases

- Create Home Assistant sensors from any Android app's UI (battery, media status, notifications)
- Automate repetitive tasks on tablets, phones, or Android-based devices
- Build custom dashboards that interact with Android devices
- Control legacy devices that only have Android apps (thermostats, cameras, etc.)

## Features

| Feature | Description |
|---------|-------------|
| **Screenshot Capture** | Real-time device screenshots with element detection |
| **Device Control** | Tap, swipe, type, scroll on devices |
| **Sensor Creation** | Create HA sensors from any UI element |
| **MQTT Integration** | Auto-discovery and state publishing to Home Assistant |
| **Flow Automation** | Record and replay multi-step interactions |
| **Flow Wizard** | Visual step-by-step flow creation |
| **Smart Flows** | AI-assisted flow generation from app screens |
| **Multi-Device** | Manage multiple Android devices |
| **WiFi ADB** | Wireless connection (Android 11+) |
| **Network Discovery** | Auto-scan for Android devices |
| **Live Streaming** | Real-time device screen streaming |

## Quick Start

1. **Install the Add-on** - Click "Install" and wait for it to complete
2. **Configure MQTT** - Set your MQTT broker settings (default: core-mosquitto)
3. **Start the Add-on** - Click "Start"
4. **Open Web UI** - Click "OPEN WEB UI" button
5. **Connect a Device** - Follow the onboarding wizard or go to Devices page

## Connecting Android Devices

### Android 11+ (Recommended)

1. Enable Developer Options on your Android device
2. Go to Settings > Developer Options > Wireless debugging
3. Enable "Wireless debugging"
4. Tap "Pair device with pairing code"
5. In Visual Mapper, use the pairing option and enter the IP, ports, and code

### Android 10 and below

1. Enable Developer Options
2. Enable USB Debugging
3. Connect via USB once to authorize
4. Enable ADB over TCP: `adb tcpip 5555`
5. Connect in Visual Mapper using IP:5555

## Configuration

| Option | Description | Default |
|--------|-------------|---------|
| `mqtt_broker` | MQTT broker hostname | core-mosquitto |
| `mqtt_port` | MQTT broker port | 1883 |
| `mqtt_username` | MQTT username (optional) | - |
| `mqtt_password` | MQTT password (optional) | - |
| `log_level` | Logging level | info |

## MQTT Topics

Sensors are automatically discovered by Home Assistant. Topic format:

```
homeassistant/sensor/{device_id}/{sensor_id}/config  # Discovery
homeassistant/sensor/{device_id}/{sensor_id}/state   # State updates
visual_mapper/{device_id}/availability               # Device online/offline
```

## Troubleshooting

### Device won't connect

- Ensure both devices are on the same network
- Check that wireless debugging is enabled (Android 11+)
- Try using the pairing code method
- Verify the IP address is correct

### Sensors show "Unavailable"

- Check MQTT connection in the add-on logs
- Verify MQTT broker settings
- Ensure the device is connected and online

### Flows not running

- Check that the flow is enabled
- Verify the device is connected
- Check add-on logs for errors

## Support

- **Issues:** [GitHub Issues](https://github.com/botts7/visual-mapper/issues)
- **Main Repository:** [visual-mapper](https://github.com/botts7/visual-mapper)
- **Add-on Repository:** [visual-mapper-addon](https://github.com/botts7/visual-mapper-addon)

## License

MIT License
