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
import Liri.NetworkManager 1.0 as NM
import Liri.Settings 1.0

ModulePage {
    id: page

    property var settingsMap: ({})

    anchors.fill: parent

    Dialog {
        id: addRouteDialog

        title: qsTr("Add Route")

        x: (parent.width - width) / 2
        y: (parent.height - height) / 2

        width: 320

        focus: true
        modal: true

        standardButtons: Dialog.Ok | Dialog.Cancel

        ColumnLayout {
            width: parent.width

            IPAddressField {
                id: addressField
                placeholderText: qsTr("Address")
                focus: true

                Layout.fillWidth: true
            }

            IPAddressField {
                id: netmaskField
                placeholderText: qsTr("Netmask")

                Layout.fillWidth: true
            }

            IPAddressField {
                id: gatewayField
                placeholderText: qsTr("Gateway")

                Layout.fillWidth: true
            }

            SpinBox {
                id: metricField
                textFromValue: function(value, locale) {
                    return qsTr("Metric %1").arg(Number(value).toLocaleString(locale, 'f', 0));
                }

                Layout.fillWidth: true
            }
        }

        onAccepted: {
            var route = {
                "dest": addressField.text,
                "prefix": networkSettings.getSubnetPrefix(netmaskField.text),
                "gateway": gatewayField.text,
                "metric": metricField.value,
            };

            if (!settingsMap.hasOwnProperty("route-data"))
                settingsMap["route-data"] = [];

            settingsMap["route-data"].push(route);
        }
    }

    ScrollView {
        anchors.fill: parent
        clip: true

        Column {
            ModuleContainer {
                title: qsTr("Method")
                width: page.width

                FluidControls.ListItem {
                    secondaryItem: ComboBox {
                        id: methodCombo
                        anchors.verticalCenter: parent.verticalCenter
                        width: parent.width
                        model: [
                            QT_TR_NOOP("Automatic (DHCP)"),
                            QT_TR_NOOP("Link-Local Only"),
                            QT_TR_NOOP("Manual"),
                            QT_TR_NOOP("Disabled")
                        ]
                    }
                }
            }

            ModuleContainer {
                title: qsTr("DNS")
                width: page.width

                FluidControls.ListItem {
                    text: qsTr("Automatic")
                    rightItem: Switch {
                        id: autoDnsSwitch
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                FluidControls.ListItem {
                    subText: qsTr("Separate IP addresses with commas")
                    secondaryItem: TextField {
                        id: dnsField
                        anchors.verticalCenter: parent.verticalCenter
                        width: parent.width
                    }
                }
            }

            ModuleContainer {
                title: qsTr("Routes")
                width: page.width

                FluidControls.ListItem {
                    text: qsTr("Automatic")
                    rightItem: Switch {
                        id: autoRoutesSwitch
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                FluidControls.ListItem {
                    icon.source: FluidControls.Utils.iconUrl("content/add")
                    text: qsTr("Add Route...")
                    onClicked: addRouteDialog.open()
                }

                Repeater {
                    model: settingsMap["route-data"]

                    FluidControls.ListItem {
                        text: qsTr("%1/%2 via %3").arg(modelData.dest).arg(modelData.prefix).arg(modelData.gateway)
                        subText: qsTr("Metric %1").arg(modelData.metric)
                    }
                }
            }
        }
    }

    function loadSettings() {
        var autoDns = true;
        if (settingsMap.hasOwnProperty("ignore-auto-dns"))
            autoDns = !settingsMap["ignore-auto-dns"];

        var autoRoutes = true;
        if (settingsMap.hasOwnProperty("ignore-auto-routes"))
            autoRoutes = !settingsMap["ignore-auto-routes"];

        switch (settingsMap["method"]) {
        case "auto":
            methodCombo.currentIndex = 0;
            autoDnsSwitch.checked = autoDns;
            autoRoutesSwitch.checked = autoRoutes;
            break;
        case "link-local":
            methodCombo.currentIndex = 1;
            autoDnsSwitch.checked = false;
            autoRoutesSwitch.checked = false;
            break;
        case "manual":
            methodCombo.currentIndex = 2;
            autoDnsSwitch.checked = false;
            autoRoutesSwitch.checked = false;
            break;
        default:
            methodCombo.currentIndex = 3;
            autoDnsSwitch.checked = false;
            autoRoutesSwitch.checked = false;
            break;
        }

        var dnsString = "";
        if (settingsMap.hasOwnProperty("dns") && settingsMap["dns"]) {
            for (var i = 0; i < settingsMap["dns"].length; i++) {
                var ip = settingsMap["dns"][i];
                dnsString += networkSettings.ipv4AddressAsString(ip);
                if (i > 0 && i < settingsMap["dns"].length - 1)
                    dnsString += ",";
            }
        }
        dnsField.text = dnsString;
    }

    function updateSettings() {
        settingsMap = {};

        switch (methodCombo.currentIndex) {
        case 0:
            settingsMap["method"] = "auto";
            settingsMap["ignore-auto-dns"] = !autoDnsSwitch.checked;
            settingsMap["ignore-auto-routes"] = !autoRoutesSwitch.checked;
            break;
        case 1:
            settingsMap["method"] = "link-local";
            delete settingsMap["ignore-auto-dns"];
            delete settingsMap["ignore-auto-routes"];
            break;
        case 2:
            settingsMap["method"] = "manual";
            delete settingsMap["ignore-auto-dns"];
            delete settingsMap["ignore-auto-routes"];
            break;
        default:
            settingsMap = { "method": "none" };
            return;
        }

        dnsField.text.replace(" ");
        if (dnsField.text) {
            var dnsList = dnsField.text.split(",");
            settingsMap["dns"] = [];
            for (var i = 0; i < dnsList.length; i++)
                settingsMap["dns"].push(networkSettings.ipv4AddressFromString(dnsList[i]));
        } else {
            delete settingsMap["dns"];
        }
    }
}
