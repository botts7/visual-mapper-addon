# Visual Mapper Home Assistant Add-on

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Home Assistant](https://img.shields.io/badge/home%20assistant-add--on-41BDF5.svg)](https://www.home-assistant.io/)
[![Sponsor](https://img.shields.io/badge/sponsor-GitHub%20Sponsors-ea4aaa.svg?logo=github)](https://github.com/sponsors/botts7)

Android device control and sensor creation for Home Assistant.

## Available Add-ons

This repository provides two versions:

| Add-on | Description | Port | Recommended For |
|--------|-------------|------|-----------------|
| **Visual Mapper** | Stable release | 8080 | Production use |
| **Visual Mapper Beta** | Pre-release with latest features | 8081 | Testing new features |

Both add-ons can be installed simultaneously - they use different ports and data directories.

## Installation

1. In Home Assistant, go to **Settings** → **Add-ons** → **Add-on Store**
2. Click the menu (⋮) in the top right and select **Repositories**
3. Add this repository URL:
   ```
   https://github.com/botts7/visual-mapper-addon
   ```
4. Choose your version:
   - **Visual Mapper** - Stable, recommended for most users
   - **Visual Mapper Beta** - Latest features, may have bugs
5. Click **Install** and start the add-on

## Stable vs Beta

### Visual Mapper (Stable)
- Thoroughly tested releases
- Recommended for daily use
- Data stored in `/config/visual_mapper/`
- Runs on port 8080

### Visual Mapper Beta
- Latest features and improvements
- May contain bugs or breaking changes
- Data stored in `/config/visual_mapper_beta/`
- Runs on port 8081
- Default log level: debug

**Tip:** Install Beta alongside Stable to test new features without risking your production setup.

## Features

- **Device Control** - Tap, swipe, type on Android devices via ADB
- **Sensor Creation** - Create Home Assistant sensors from any UI element
- **Flow Automation** - Record and replay multi-step device interactions
- **MQTT Integration** - Auto-discovery sensors in Home Assistant
- **Multi-Device** - Manage multiple Android devices
- **WiFi ADB** - Wireless connection (Android 11+)
- **Interactive Tutorial** - Built-in guide for new users

## Configuration

| Option | Description | Default |
|--------|-------------|---------|
| `mqtt_broker` | MQTT broker hostname | `core-mosquitto` |
| `mqtt_port` | MQTT broker port | `1883` |
| `mqtt_username` | MQTT username | (empty) |
| `mqtt_password` | MQTT password | (empty) |
| `log_level` | Logging level | `info` |
| `ml_training_mode` | ML training mode | `disabled` |

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

## Contributing

We welcome contributions! To test your changes:

1. Make changes in `visual-mapper-beta/`
2. Push to trigger a beta build
3. Test the beta add-on in your HA instance
4. Once stable, copy changes to `visual-mapper/`

## Support

- **Issues:** [GitHub Issues](https://github.com/botts7/visual-mapper-addon/issues)
- **Discussions:** [GitHub Discussions](https://github.com/botts7/visual-mapper/discussions)

## License

MIT License - see [LICENSE](LICENSE) for details.
