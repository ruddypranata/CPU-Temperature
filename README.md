# CPU Temperature

This widget is for Linux debian and derivatives, using DE KDE plasma and is designed to display real-time CPU and SSD temperatures on your desktop or system panel. With a simple and informative interface, this widget allows users to monitor CPU core temperatures (Core 0, Core 2 and others) and SSD temperatures easily.

### Key Features:
- **CPU Temperature Display**: Displays the average CPU temperature and the temperature of each core (Core 0 and Core 2).

- **SSD Temperature Display**: Displays the detected SSD temperature.

- **Compact View**: Provides a compact view in the system panel with icons and brief temperature information.

- **Information Tooltip**: Displays detailed temperature information when users hover over the widget in the panel.

- **Theme Configuration**: Supports light and dark themes to customize user preferences.

- **Temperature Warning**: The icon changes to "temperature-warm" if the temperature exceeds the specified limit (default: 80°C for CPU and 60°C for SSD).

### How it Works:
The widget uses the sensors command to read CPU temperature and smartctl to read SSD temperature.

Temperature data is updated every second (1000ms interval) to ensure the information displayed is always accurate.

### Installation:
1. Make sure you have lm-sensors and smartmontools installed to read CPU and SSD temperatures.
    - Install lm-sensor
  	```
  	sudo apt install lm-sensors
  	```
  
  	```
  	sudo sensors-detect
  	```
  
  	```
  	sudo service kmod start
  	```

    - Install smartmontools
  	```
  	sudo apt install smartmontools
    ```

2. Download and copy the org.kde.cpuTemp folder to /home/yourhomefolder/.local/share/plasma/plasmoids.
3. Add the widget to your desktop or panel via Plasma settings.
