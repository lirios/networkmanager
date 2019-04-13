/****************************************************************************
 * This file is part of Settings.
 *
 * Copyright (C) 2018 Pier Luigi Fiorini <pierluigi.fiorini@gmail.com>
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

import QtQuick 2.1
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtGSettings 1.0
import Fluid.Controls 1.0 as FluidControls
import Liri.NetworkManager 1.0 as NM
import Liri.Settings 1.0

ModulePage {
    id: networkPreflet

    header: ToolBar {
        Material.primary: Material.color(Material.BlueGrey, Material.Shade400)
        Material.theme: Material.Dark

        Switch {
            id: wirelessSwitch
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 8

            text: qsTr("Use Wi-Fi")
            onCheckedChanged: networking.wirelessEnabled = checked
        }
    }

    Component.onCompleted: {
        wirelessSwitch.checked = networking.wirelessEnabled;
    }

    NM.Networking {
        id: networking
    }

    NM.NetworkModel {
        id: networkModel
    }

    NM.NetworkSettings {
        id: networkSettings
    }

    Component {
        id: wiredPage

        WiredPage {}
    }

    Component {
        id: wirelessPage

        WirelessPage {}
    }

    StackLayout {
        anchors.fill: parent
        currentIndex: networking.enabled ? 1 : 0

        Item {
            FluidControls.Placeholder {
                anchors.centerIn: parent
                icon.source: FluidControls.Utils.iconUrl("alert/warning")
                text: qsTr("Please make sure the \"NetworkManager\" service is running.")
            }
        }

        Item {
            ScrollView {
                anchors.fill: parent
                clip: true

                Column {
                    ModuleContainer {
                        title: qsTr("Wired")
                        width: networkPreflet.width
                        visible: networking.enabled && wiredRepeater.count > 0

                        Repeater {
                            id: wiredRepeater

                            model: NM.TechnologyProxyModel {
                                type: NM.TechnologyProxyModel.WiredType
                                sourceModel: networkModel
                            }

                            FluidControls.ListItem {
                                icon.source: FluidControls.Utils.iconUrl(model.connectionIcon)

                                text: model.itemUniqueName
                                subText: model.connectionStateString
                                onClicked: window.pageStack.push(wiredPage, {"model": model})
                            }
                        }
                    }

                    ModuleContainer {
                        title: qsTr("Wireless")
                        width: networkPreflet.width
                        visible: networking.enabled && networking.wirelessEnabled &&
                                 networking.wirelessHardwareEnabled

                        FluidControls.ListItem {
                            icon.source: FluidControls.Utils.iconUrl("content/add")
                            text: qsTr("Add Network")
                        }

                        Repeater {
                            id: wirelessRepeater

                            model: NM.TechnologyProxyModel {
                                type: NM.TechnologyProxyModel.WirelessType
                                sourceModel: networkModel
                                showInactiveConnections: true
                            }

                            FluidControls.ListItem {
                                icon.source: FluidControls.Utils.iconUrl(model.connectionIcon)

                                text: model.itemUniqueName
                                subText: model.connectionStateString
                                onClicked: window.pageStack.push(wirelessPage, {"model": model})
                            }
                        }
                    }

                    /*
                    ModuleContainer {
                        title: qsTr("Bluetooth")
                        width: networkPreflet.width
                        visible: networking.enabled && bluetoothRepeater.count > 0

                        Repeater {
                            id: bluetoothRepeater

                            model: NM.TechnologyProxyModel {
                                type: NM.TechnologyProxyModel.BluetoothType
                                sourceModel: networkModel
                            }

                            FluidControls.ListItem {
                                icon.source: FluidControls.Utils.iconUrl(model.connectionIcon)

                                text: model.itemUniqueName
                                subText: model.connectionStateString
                            }
                        }
                    }

                    ModuleContainer {
                        title: qsTr("Wimax")
                        width: networkPreflet.width
                        visible: networking.enabled && wimaxRepeater.count > 0

                        Repeater {
                            id: wimaxRepeater

                            model: NM.TechnologyProxyModel {
                                type: NM.TechnologyProxyModel.WimaxType
                                sourceModel: networkModel
                            }

                            FluidControls.ListItem {
                                icon.source: FluidControls.Utils.iconUrl(model.connectionIcon)

                                text: model.itemUniqueName
                                subText: model.connectionStateString
                            }
                        }
                    }

                    ModuleContainer {
                        title: qsTr("ADSL")
                        width: networkPreflet.width
                        visible: networking.enabled && networking.mobileEnabled &&
                                 networking.mobileHardwareEnabled && adslRepeater.count > 0

                        Repeater {
                            id: adslRepeater

                            model: NM.TechnologyProxyModel {
                                type: NM.TechnologyProxyModel.AdslType
                                sourceModel: networkModel
                            }

                            FluidControls.ListItem {
                                icon.source: FluidControls.Utils.iconUrl(model.connectionIcon)

                                text: model.itemUniqueName
                                subText: model.connectionStateString
                            }
                        }
                    }

                    ModuleContainer {
                        title: qsTr("VPN")
                        width: networkPreflet.width
                        visible: networking.enabled

                        FluidControls.ListItem {
                            icon.source: FluidControls.Utils.iconUrl("content/add")
                            text: qsTr("Add VPN")
                        }

                        Repeater {
                            id: vpnRepeater

                            model: NM.TechnologyProxyModel {
                                type: NM.TechnologyProxyModel.VpnType
                                sourceModel: networkModel
                            }

                            FluidControls.ListItem {
                                icon.source: FluidControls.Utils.iconUrl(model.connectionIcon)

                                text: model.itemUniqueName
                                subText: model.connectionStateString
                            }
                        }
                    }
                    */

                    ModuleContainer {
                        width: networkPreflet.width

                        FluidControls.ListItem {
                            text: qsTr("Network Proxy")
                            valueText: qsTr("Off")
                        }
                    }
                }
            }
        }
    }
}
