/****************************************************************************
 * This file is part of Settings.
 *
 * Copyright (C) 2017 Pier Luigi Fiorini <pierluigi.fiorini@gmail.com>
 *
 * $BEGIN_LICENSE:GPL3+$
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * $END_LICENSE$
 ***************************************************************************/

import QtQuick 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.2
import Fluid.Controls 1.0 as FluidControls
import Liri.Settings 1.0

ModulePage {
    id: page

    property var settingsMap: ({})

    anchors.fill: parent

    ScrollView {
        anchors.fill: parent
        clip: true

        Column {
            ModuleContainer {
                title: qsTr("General")
                width: page.width

                FluidControls.ListItem {
                    secondaryItem: TextField {
                        id: nameField
                        anchors.verticalCenter: parent.verticalCenter
                        width: parent.width
                        placeholderText: qsTr("Name")
                    }
                }

                FluidControls.ListItem {
                    secondaryItem: CheckBox {
                        id: autoConnectCheckBox
                        anchors.verticalCenter: parent.verticalCenter
                        text: qsTr("Connect automatically")
                    }
                }

                FluidControls.ListItem {
                    secondaryItem: CheckBox {
                        id: availableToOthersCheckBox
                        anchors.verticalCenter: parent.verticalCenter
                        text: qsTr("Make available to other users")
                    }
                }
            }

            ModuleContainer {
                title: qsTr("Address")
                width: page.width

                FluidControls.ListItem {
                    text: qsTr("SSID")
                    secondaryItem: TextField {
                        id: ssidField
                        anchors.verticalCenter: parent.verticalCenter
                        width: parent.width
                        placeholderText: qsTr("SSID")
                    }
                }

                FluidControls.ListItem {
                    text: qsTr("BSSID")
                    secondaryItem: TextField {
                        id: bssidField
                        anchors.verticalCenter: parent.verticalCenter
                        width: parent.width
                        placeholderText: qsTr("BSSID")
                        inputMask: "HH:HH:HH:HH:HH:HH;_"
                    }
                }

                FluidControls.ListItem {
                    text: qsTr("MAC Address")
                    secondaryItem: TextField {
                        id: macField
                        anchors.verticalCenter: parent.verticalCenter
                        width: parent.width
                        placeholderText: qsTr("MAC Address")
                        inputMask: "HH:HH:HH:HH:HH:HH;_"
                    }
                }

                FluidControls.ListItem {
                    text: qsTr("Cloned Address")
                    secondaryItem: TextField {
                        id: clonedMacField
                        anchors.verticalCenter: parent.verticalCenter
                        width: parent.width
                        placeholderText: qsTr("Cloned Address")
                        inputMask: "HH:HH:HH:HH:HH:HH;_"
                    }
                }
            }
        }
    }

    function loadSettings() {
        nameField.text = settingsMap["connection"]["id"];

        if (settingsMap.hasOwnProperty("autoconnect"))
            autoConnectCheckBox.checked = settingsMap["autoconnect"];
        else
            autoConnectCheckBox.checked = true;

        if (settingsMap["connection"].hasOwnProperty("permissions")) {
            if (settingsMap["connection"]["permissions"].length === 0)
                availableToOthersCheckBox.checked = true;
            else
                availableToOthersCheckBox.checked = false;
        } else {
            availableToOthersCheckBox.checked = true;
        }

        ssidField.text = settingsMap["802-11-wireless"]["ssid"] || nameField.text;
        bssidField.text = settingsMap["802-11-wireless"]["bssid"] || "";
        macField.text = networkSettings.macAddressAsString(settingsMap["802-11-wireless"]["mac-address"]) || "";
        clonedMacField.text = networkSettings.macAddressAsString(settingsMap["802-11-wireless"]["cloned-mac-address"]) || "";
    }

    function updateSettings() {
        settingsMap = {"connection": {}, "802-11-wireless": {}};

        settingsMap["connection"]["id"] = nameField.text;
        settingsMap["connection"]["autoconnect"] = autoConnectCheckBox.checked;

        if (availableToOthersCheckBox.checked)
            settingsMap["connection"]["permissions"] = [];
        else
            settingsMap["connection"]["permissions"] = [networkSettings.currentUserName];

        settingsMap["802-11-wireless"]["ssid"] = ssidField.text;
        settingsMap["802-11-wireless"]["bssid"] = bssidField.text;
        settingsMap["802-11-wireless"]["mac-address"] = networkSettings.macAddressFromString(macField.text);
        settingsMap["802-11-wireless"]["cloned-mac-address"] = networkSettings.macAddressFromString(clonedMacField.text);
    }
}
