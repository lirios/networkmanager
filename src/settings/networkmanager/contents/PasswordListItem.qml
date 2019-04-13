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
import QtQuick.Controls 2.0
import Fluid.Controls 1.0 as FluidControls
import Liri.NetworkManager 1.0 as NM

FluidControls.ListItem {
    id: passwordListItem

    property alias password: passwordField.text
    property alias placeholderText: passwordField.placeholderText
    property alias validator: passwordField.validator
    property alias maximumLength: passwordField.maximumLength
    readonly property int secretFlagType: {
        switch (secretFlagCombo.currentIndex) {
        case 0:
            return NM.NetworkSettings.AgentOwned;
        case 1:
            return NM.NetworkSettings.None;
        case 2:
            return NM.NetworkSettings.NotSaved;
        }
    }

    signal accepted()

    secondaryItem: Column {
        anchors.verticalCenter: parent.verticalCenter
        width: passwordListItem.width

        TextField {
            id: passwordField
            width: parent.width
            placeholderText: qsTr("Password")
            echoMode: showPasswordCheckBox.checked ? TextInput.Normal : TextInput.Password
            onAccepted: passwordListItem.accepted()
        }

        CheckBox {
            id: showPasswordCheckBox
            text: qsTr("Show password")
        }

        ComboBox {
            id: secretFlagCombo
            width: parent.width
            model: [
                qsTr("Store the password only for this user"),
                qsTr("Store the password for all users"),
                qsTr("Ask for this password every time")
            ]
        }
    }
}
