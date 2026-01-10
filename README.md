# Visual Mapper Home Assistant Add-on

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Home Assistant](https://img.shields.io/badge/home%20assistant-add--on-41BDF5.svg)](https://www.home-assistant.io/)
[![Sponsor](https://img.shields.io/badge/sponsor-GitHub%20Sponsors-ea4aaa.svg?logo=github)](https://github.com/sponsors/botts7)

Android device control and sensor creation for Home Assistant.

## Installation

1. In Home Assistant, go to **Settings** → **Add-ons** → **Add-on Store**
2. Click the menu (⋮) in the top right and select **Repositories**
3. Add this repository URL:
   ```
   https://github.com/botts7/visual-mapper-addon
   ```
4. Find **Visual Mapper** in the add-on store and click **Install**
5. Start the add-on and open the Web UI

## Features

- **Device Control** - Tap, swipe, type on Android devices via ADB
- **Sensor Creation** - Create Home Assistant sensors from any UI element
- **Flow Automation** - Record and replay multi-step device interactions
- **MQTT Integration** - Auto-discovery sensors in Home Assistant
- **Multi-Device** - Manage multiple Android devices
- **WiFi ADB** - Wireless connection (Android 11+)

## Configuration

| Option | Description | Default |
|--------|-------------|---------|
| `mqtt_broker` | MQTT broker hostname | `core-mosquitto` |
| `mqtt_port` | MQTT broker port | `1883` |
| `mqtt_username` | MQTT username | (empty) |
| `mqtt_password` | MQTT password | (empty) |
| `mqtt_discovery_prefix` | HA discovery prefix | `homeassistant` |
| `log_level` | Logging level | `info` |

## Requirements

- Home Assistant OS or Supervised
- Android device with Developer Options enabled
- Network access between HA and Android device

## Related Repositories

| Repository | Description |
|------------|-------------|
| [visual-mapper](https://github.com/botts7/visual-mapper) | Main server application |
| [visual-mapper-android](https://github.com/botts7/visual-mapper-android) | Android companion app |
| [visual-mapper-addon](https://github.com/botts7/visual-mapper-addon) | Home Assistant add-on (this repo) |

## Support

- **Issues:** [GitHub Issues](https://github.com/botts7/visual-mapper-addon/issues)

## License

MIT License - see [LICENSE](LICENSE) for details.
