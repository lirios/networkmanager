/****************************************************************************
 * This file is part of Settings.
 *
 * Copyright (C) 2019 Pier Luigi Fiorini <pierluigi.fiorini@gmail.com>
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
import QtQuick.Controls 2.0

Page {
    anchors.fill: parent

    GridLayout {
        anchors.centerIn: parent

        columns: 2

        Label {
            font.bold: true
            text: qsTr("Signal Strength")

            Layout.alignment: Qt.AlignRight
        }

        Label {
            text: model.signalStrength
        }

        Label {
            font.bold: true
            text: qsTr("Link Speed")

            Layout.alignment: Qt.AlignRight
        }

        Label {
            text: model.linkSpeed
        }

        Label {
            font.bold: true
            text: qsTr("Security")

            Layout.alignment: Qt.AlignRight
        }

        Label {
            text: model.securityTypeString
        }

        Label {
            font.bold: true
            text: qsTr("IPv4 Address")

            Layout.alignment: Qt.AlignRight
        }

        Label {
            text: model.ipV4Address
        }

        Label {
            font.bold: true
            text: qsTr("IPv6 Address")

            Layout.alignment: Qt.AlignRight
        }

        Label {
            text: model.ipV6Address
        }

        Label {
            font.bold: true
            text: qsTr("Hardware Address")

            Layout.alignment: Qt.AlignRight
        }

        Label {
            text: model.macAddress
        }

        Label {
            font.bold: true
            text: qsTr("Default Route")

            Layout.alignment: Qt.AlignRight
        }

        Label {
            text: model.gateway
        }

        Label {
            font.bold: true
            text: qsTr("DNS")

            Layout.alignment: Qt.AlignRight
        }

        Label {
            text: model.nameServer
        }
    }
}
