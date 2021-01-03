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

import QtQuick 2.1
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.1
import QtQuick.Controls.Material 2.1
import Fluid.Controls 1.0 as FluidControls
import Liri.NetworkManager 1.0 as NM

FluidControls.ListItem {
    id: listItem

    icon.source: FluidControls.Utils.iconUrl(model.connectionIcon)
    text: model.itemUniqueName
    subText: {
        switch (model.connectionState) {
        case NM.NetworkModelItem.Activating:
            if (model.type === NM.NetworkModelItem.Vpn)
                return model.vpnState;
            else
                return model.deviceState;
        case NM.NetworkModelItem.Deactivating:
            if (model.type === NM.NetworkModelItem.Vpn)
                return model.vpnState;
            else
                return model.deviceState;
        case NM.NetworkModelItem.Deactivated:
            if (model.securityType > NM.NetworkModelItem.None)
                return qsTr("%1, %2").arg(model.lastUsed).arg(model.securityTypeString);
            return model.lastUsed;
        case NM.NetworkModelItem.Activated:
            return qsTr("Connected");
        default:
            break;
        }

        return "";
    }

    onClicked: {
        if (model.connectionState === NM.NetworkModelItem.Deactivated) {
            if (!model.uuid && model.type === NM.NetworkModelItem.Wireless &&
                (model.securityType === NM.NetworkModelItem.StaticWep ||
                 model.securityType === NM.NetworkModelItem.WpaPsk ||
                 model.securityType === NM.NetworkModelItem.Wpa2Psk))
                passwordDialog.open();
            else if (model.uuid)
                networking.activateConnection(model.connectionPath, model.devicePath, model.specificPath);
            else
                networking.addAndActivateConnection(model.devicePath, model.specificPath);
        } else {
            networking.deactivateConnection(model.connectionPath, model.devicePath);
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
        onAccepted: networking.addAndActivateConnection(model.devicePath, model.specificPath, passwordField.text)

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
                        if (model.securityType === NM.NetworkModelItem.StaticWep)
                            return /^(?:[\x20-\x7F]{5}|[0-9a-fA-F]{10}|[\x20-\x7F]{13}|[0-9a-fA-F]{26}){1}$/;
                        return /^(?:[\x20-\x7F]{8,64}){1}$/;
                    }
                }
                onAccepted: passwordDialog.accept()

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
