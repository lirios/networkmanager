/****************************************************************************
 * This file is part of Liri.
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
import QtQuick.Controls 2.0
import Fluid.Controls 1.0 as FluidControls
import Liri.Settings 1.0
import Liri.NetworkManager 1.0 as NM

ModuleContainer {
    title: qsTr("WEP 128-bit Passphrase")

    PasswordListItem {
        id: passwordField
        width: parent.width
        maximumLength: 16
    }

    FluidControls.ListItem {
        text: qsTr("WEP Index")
        rightItem: ComboBox {
            id: wepIndexCombo
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width
            model: [
                qsTr("1 (Default)"),
                qsTr("2"),
                qsTr("3"),
                qsTr("4")
            ]
        }
    }

    FluidControls.ListItem {
        text: qsTr("Authentication")
        rightItem: ComboBox {
            id: authAlgCombo
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width
            model: [
                qsTr("Open System"),
                qsTr("Shared Key")
            ]
        }
    }

    function loadSettings() {
        if (page.settingsMap["wep-key-flags"] & NM.NetworkSettings.None)
            passwordField.setSecretFlagType(NM.NetworkSettings.None);

        if (page.settingsMap["wep-tx-keyidx"] !== undefined)
            wepIndexCombo.currentIndex = page.settingsMap["wep-tx-keyidx"];

        passwordField.text = page.settingsMap["wep-key" + wepIndexCombo.currentIndex];

        if (page.settingsMap["auth-alg"] === "open")
            authAlgCombo.currentIndex = 0;
        else if (page.settingsMap["auth-alg"] === "shared")
            authAlgCombo.currentIndex = 1;
    }

    function updateSettings() {
        page.settingsMap["key-mgmt"] = "ieee8021x";
        page.settingsMap["wep-key-type"] = NM.NetworkSettings.Passphrase;
        page.settingsMap["wep-key-flags"] = passwordField.secretFlagType;
        page.settingsMap["wep-tx-keyidx"] = wepIndexCombo.currentIndex;
        page.settingsMap["auth-alg"] = authAlgCombo.currentIndex == 0 ? "open" : "shared";
        page.settingsMap["wep-key" + wepIndexCombo.currentIndex] = passwordField.text;
    }
}
