/****************************************************************************
 * This file is part of Liri.
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
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.0
import Fluid.Controls 1.0 as FluidControls
import Liri.Shell 1.0
import Liri.NetworkManager 1.0 as NM

Indicator {
    id: indicator

    title: qsTr("Network")
    iconSource: FluidControls.Utils.iconUrl(connectionIconProvider.connectionTooltipIcon)
    tooltip: networking.activeConnections
    visible: networking.enabled

    component: ColumnLayout {
        spacing: 0

        FluidControls.ListItem {
            text: qsTr("Use Wi-Fi")
            rightItem: Switch {
                id: wirelessSwitch
                anchors.verticalCenter: parent.verticalCenter
                onCheckedChanged: networking.wirelessEnabled = checked
            }
        }

        ListView {
            model: NM.AppletProxyModel {
                sourceModel: NM.NetworkModel {}
            }
            clip: true
            currentIndex: -1
            section.property: "section"
            section.delegate: FluidControls.Subheader { text: section }

            delegate: Connection {}

            ScrollBar.horizontal: ScrollBar {}
            ScrollBar.vertical: ScrollBar {}

            Layout.fillWidth: true
            Layout.fillHeight: true
        }
    }

    NM.Networking {
        id: networking
    }

    NM.ConnectionIcon {
        id: connectionIconProvider
    }

    Component.onCompleted: {
        wirelessSwitch.checked = networking.wirelessEnabled;
    }
}
