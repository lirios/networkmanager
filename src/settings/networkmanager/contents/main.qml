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
import QtQuick.Controls 2.0
import QtGSettings 1.0
import Fluid.Controls 1.0 as FluidControls
import Liri.NetworkManager 1.0 as NM
import Liri.Settings 1.0

ModulePage {
    id: networkPreflet

    readonly property bool networkAvailable: connectionIconProvider.connectionIcon !== "network-unavailable"

    //property var profileDialog: ProfileDialog {}

    NM.ConnectionIcon {
        id: connectionIconProvider

        function massageIconName(iconName) {
            var newName = iconName.replace("-activated", "");
            if (newName !== "")
                return newName + "-symbolic";
            return newName;
        }
    }

    NM.Handler {
        id: handler
    }

    NM.ConnectionModel {
        id: connectionModel
    }

    Component {
        id: wiredPage

        WiredPage {}
    }

    FluidControls.Placeholder {
        anchors.centerIn: parent
        icon.source: FluidControls.Utils.iconUrl("alert/warning")
        text: qsTr("Please make sure the \"NetworkManager\" service is running.")
        visible: !networkAvailable
    }

    ModuleContainer {
        title: qsTr("Wired")
        visible: networkAvailable && wiredRepeater.count > 0

        Repeater {
            id: wiredRepeater

            model: NM.TechnologyProxyModel {
                type: NM.TechnologyProxyModel.WiredType
                sourceModel: connectionModel
            }

            FluidControls.ListItem {
                icon.source: FluidControls.Utils.iconUrl(model.symbolicIconName)

                text: model.ItemUniqueName
                onClicked: window.pageStack.push(wiredPage, {"model": model})
            }
        }
    }

    ModuleContainer {
        title: qsTr("Wireless")
        visible: networkAvailable && wirelessRepeater.count > 0

        Repeater {
            id: wirelessRepeater

            model: NM.TechnologyProxyModel {
                type: NM.TechnologyProxyModel.WirelessType
                sourceModel: connectionModel
            }

            FluidControls.ListItem {
                icon.source: FluidControls.Utils.iconUrl(model.symbolicIconName)

                text: model.ItemUniqueName
            }
        }
    }

    ModuleContainer {
        title: qsTr("Bluetooth")
        visible: networkAvailable && bluetoothRepeater.count > 0

        Repeater {
            id: bluetoothRepeater

            model: NM.TechnologyProxyModel {
                type: NM.TechnologyProxyModel.BluetoothType
                sourceModel: connectionModel
            }

            FluidControls.ListItem {
                icon.source: FluidControls.Utils.iconUrl(model.symbolicIconName)

                text: model.ItemUniqueName
            }
        }
    }

    ModuleContainer {
        title: qsTr("Wimax")
        visible: networkAvailable && wimaxRepeater.count > 0

        Repeater {
            id: wimaxRepeater

            model: NM.TechnologyProxyModel {
                type: NM.TechnologyProxyModel.WimaxType
                sourceModel: connectionModel
            }

            FluidControls.ListItem {
                icon.source: FluidControls.Utils.iconUrl(model.symbolicIconName)

                text: model.ItemUniqueName
            }
        }
    }

    ModuleContainer {
        title: qsTr("ADSL")
        visible: networkAvailable && adslRepeater.count > 0

        Repeater {
            id: adslRepeater

            model: NM.TechnologyProxyModel {
                type: NM.TechnologyProxyModel.AdslType
                sourceModel: connectionModel
            }

            FluidControls.ListItem {
                icon.source: FluidControls.Utils.iconUrl(model.symbolicIconName)

                text: model.ItemUniqueName
            }
        }
    }

    ModuleContainer {
        title: qsTr("VPN")
        visible: networkAvailable && vpnRepeater.count > 0

        Repeater {
            id: vpnRepeater

            model: NM.TechnologyProxyModel {
                type: NM.TechnologyProxyModel.VpnType
                sourceModel: connectionModel
            }

            FluidControls.ListItem {
                icon.source: FluidControls.Utils.iconUrl(model.symbolicIconName)

                text: model.ItemUniqueName
            }
        }
    }
}
