import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents
import org.kde.plasma.plasmoid 2.0

Item {
    id: root
    width: 200
    height: 150

    // Properties for storing temperature
    property string cpuTemp: "N/A"
    property string core0Temp: "N/A"
    property string core2Temp: "N/A"
    property string ssdTemp: "N/A"

    // Configuration
    Plasmoid.configuration {
        property string theme: "light"
        property int cpuTempThreshold: 80
        property int ssdTempThreshold: 60
        //property int updateInterval: 1000
    }

    // Read CPU temperature
    PlasmaCore.DataSource {
        id: cpuTempReader
        engine: "executable"
        connectedSources: ["/usr/bin/sensors"]
        interval: 1000

        onNewData: {
            var output = data["stdout"].trim().split("\n");
            for (var i = 0; i < output.length; i++) {
                if (output[i].includes("Core 0:")) {
                    root.core0Temp = output[i].match(/([\d.]+)°C/)[1];
                }
                if (output[i].includes("Core 2:")) {
                    root.core2Temp = output[i].match(/([\d.]+)°C/)[1];
                }
            }
            root.cpuTemp = (parseFloat(root.core0Temp) + parseFloat(root.core2Temp)) / 2 + "°C";
        }
    }

    // Read SSD temperature
    PlasmaCore.DataSource {
        id: ssdTempReader
        engine: "executable"
        connectedSources: ["sudo /usr/sbin/smartctl -a /dev/sda | grep Temperature | awk '{print $10}'"]
        interval: 1000

        onNewData: {
            var newTemp = data["stdout"].trim();
            if (newTemp !== "" && newTemp !== "N/A") {
                root.ssdTemp = newTemp;
            } else {
                root.ssdTemp = "N/A";
            }
        }
    }

    // Main view (on desktop)
    ColumnLayout {
        anchors.centerIn: parent
        spacing: 5

        PlasmaComponents.Label {
            text: "CPU Avg Temp: " + root.cpuTemp
            font.bold: true
        }
        PlasmaComponents.Label {
            text: "Core 0 Temp: " + root.core0Temp + "°C"
        }
        PlasmaComponents.Label {
            text: "Core 2 Temp: " + root.core2Temp + "°C"
        }
        PlasmaComponents.Label {
            text: "SSD Temp: " + root.ssdTemp + "°C"
        }
    }

    // Compact representation in the panel
    Plasmoid.compactRepresentation: RowLayout {
        spacing: 5

        // Temperature icon
        PlasmaCore.IconItem {
            source: root.core0Temp > 80 ? "temperature-warm" : "temperature-normal"
            width: 5
            height: 5
        }

        // Temperature information
        PlasmaComponents.Label {
            text: root.core0Temp + "°C | " + root.core2Temp + "°C | " + root.ssdTemp + "°C"
            font.bold: true
        }

        // Custom Tooltip
        MouseArea {
            anchors.fill: parent
            hoverEnabled: true

            Rectangle {
                id: tooltip
                visible: parent.containsMouse
                width: tooltipText.implicitWidth + 15
                height: tooltipText.implicitHeight + 10
                color: Qt.rgba(0, 0, 0, 0.7)
                //border.color: "white"
                border.width: 1
                radius: 5

                Text {
                    id: tooltipText
                    color: "white"
                    anchors.centerIn: parent
                    text: "Core 0: " + root.core0Temp + "°C | " +
                          "Core 2: " + root.core2Temp + "°C | " +
                          "SSD: " + root.ssdTemp + "°C"
                }
            }
        }
    }
}
