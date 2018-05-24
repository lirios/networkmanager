/****************************************************************************
 * This file is part of Liri.
 *
 * Copyright (C) 2018 Pier Luigi Fiorini <pierluigi.fiorini@gmail.com>
 * Copyright (C) 2013-2014 Jan Grulich <jgrulich@redhat.com>
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
import QtQuick.Controls 2.1
import QtQuick.Controls.Material 2.1
import Fluid.Controls 1.0 as FluidControls
import Liri.NetworkManager 1.0 as NM

FluidControls.ListItem {
    id: listItem

    property bool predictableWirelessPassword: !Uuid && Type === NM.Enums.Wireless &&
                                               (SecurityType === NM.Enums.StaticWep || SecurityType === NM.Enums.WpaPsk ||
                                                SecurityType === NM.Enums.Wpa2Psk)
    property bool showSpeed: ConnectionState === NM.Enums.Activated &&
                             (Type === NM.Enums.Wimax ||
                              Type === NM.Enums.Wired ||
                              Type === NM.Enums.Wireless ||
                              Type === NM.Enums.Gsm ||
                              Type === NM.Enums.Cdma)

    onClicked: {
        if (ConnectionState === NM.Enums.Deactivated) {
            if (predictableWirelessPassword) {
                passwordDialog.open()
            } else if (Uuid) {
                handler.activateConnection(ConnectionPath, DevicePath, SpecificPath)
            } else {
                handler.addAndActivateConnection(DevicePath, SpecificPath)
            }
        } else {
            handler.deactivateConnection(ConnectionPath, DevicePath)
        }
    }

    icon.source: FluidControls.Utils.iconUrl(materialIconName(ConnectionIcon))
    text: ItemUniqueName
    subText: {
        if (ConnectionState === NM.Enums.Activating) {
            if (Type === NM.Enums.Vpn)
                return VpnState;
            else
                return DeviceState;
        } else if (ConnectionState === NM.Enums.Deactivating) {
            if (Type === NM.Enums.Vpn)
                return VpnState;
            else
                return DeviceState;
        } else if (ConnectionState === NM.Enums.Deactivated) {
            var result = LastUsed;
            if (SecurityType > NM.Enums.None)
                result += ", " + SecurityTypeString;
            return result;
        } else if (ConnectionState === NM.Enums.Activated) {
            return qsTr("Connected");
        }
    }

    Dialog {
        id: passwordDialog

        Material.primary: Material.Blue
        Material.accent: Material.Blue

        title: qsTr("Connect to Network")

        parent: screenView
        x: (output.availableGeometry.width - width)/2
        y: (output.availableGeometry.height - height)/2
        focus: true

        footer: DialogButtonBox {
            Button {
                text: qsTr("Connect")
                enabled: passwordField.acceptableInput
                flat: true

                DialogButtonBox.buttonRole: DialogButtonBox.AcceptRole
            }

            Button {
                text: qsTr("Cancel")
                flat: true

                DialogButtonBox.buttonRole: DialogButtonBox.RejectRole
            }
        }

        onOpened: passwordField.text = ""
        onAccepted: handler.addAndActivateConnection(DevicePath, SpecificPath, passwordField.text)

        implicitWidth: 400

        ColumnLayout {
            width: parent.width

            FluidControls.DialogLabel {
                text: listItem.text
            }

            TextField {
                id: passwordField
                focus: true
                echoMode: showPasswordCheckbox.checked ? TextInput.Normal : TextInput.Password
                placeholderText: qsTr("Password")
                validator: RegExpValidator {
                    regExp: {
                        if (SecurityType === NM.Enums.StaticWep)
                            return /^(?:[\x20-\x7F]{5}|[0-9a-fA-F]{10}|[\x20-\x7F]{13}|[0-9a-fA-F]{26}){1}$/
                        else
                            return /^(?:[\x20-\x7F]{8,64}){1}$/
                    }
                }
                onAccepted: passwordDialog.accepted()

                Layout.fillWidth: true
            }

            CheckBox {
                id: showPasswordCheckbox
                checked: false
                text: qsTr("Show password")
            }
        }
    }
}
