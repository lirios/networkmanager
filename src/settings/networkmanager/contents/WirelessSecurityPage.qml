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
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import Fluid.Controls 1.0 as FluidControls
import Liri.Settings 1.0
import Liri.NetworkManager 1.0 as NM

ModulePage {
    id: page

    property var settingsMap: ({})

    anchors.fill: parent

    ScrollView {
        anchors.fill: parent
        clip: true

        Column {
            ModuleContainer {
                title: qsTr("Security")
                width: page.width

                FluidControls.ListItem {
                    secondaryItem: ComboBox {
                        id: securityCombo
                        anchors.verticalCenter: parent.verticalCenter
                        width: parent.width
                        textRole: "label"
                        model: ListModel {
                            ListElement {
                                //: Security method
                                label: QT_TR_NOOP("None")
                            }
                            ListElement {
                                //: Security method
                                label: QT_TR_NOOP("WEP 40/128-bit Key (Hex or ASCII)")
                            }
                            ListElement {
                                //: Security method
                                label: QT_TR_NOOP("WEP 128-bit Passphrase")
                            }
                            ListElement {
                                //: Security method
                                label: QT_TR_NOOP("LEAP")
                            }
                            ListElement {
                                //: Security method
                                label: QT_TR_NOOP("Dynamic WEP (802.1x)")
                            }
                            ListElement {
                                //: Security method
                                label: QT_TR_NOOP("WPA && WPA2 Personal")
                            }
                            ListElement {
                                //: Security method
                                label: QT_TR_NOOP("WPA && WPA2 Enterprise")
                            }
                        }
                    }
                }
            }

            SecurityWepHex {
                id: wepHex
                width: page.width
                visible: securityCombo.currentIndex == 1
            }

            SecurityWepPassphrase {
                id: wepPassphrase
                width: page.width
                visible: securityCombo.currentIndex == 2
            }

            SecurityWpaPsk {
                id: wpaPsk
                width: page.width
                visible: securityCombo.currentIndex == 5
            }
        }
    }

    function loadSettings() {
        switch (settingsMap["key-mgmt"]) {
        case "none":
            securityCombo.currentIndex = 0;
            break;
        case "ieee8021x":
            if (settingsMap["wep-key-type"] === NM.NetworkSettings.Hex) {
                wepHex.loadSettings();
                securityCombo.currentIndex = 1;
            } else if (settingsMap["wep-key-type"] === NM.NetworkSettings.Passphrase) {
                wepPassphrase.loadSettings();
                securityCombo.currentIndex = 2;
            } else if (settingsMap["auth-alg"] === "leap") {
                securityCombo.currentIndex = 3;
            } else {
                securityCombo.currentIndex = 4;
            }
            break;
        case "wpa-psk":
            wpaPsk.loadSettings();
            securityCombo.currentIndex = 5;
            break;
        case "wpa-eap":
            securityCombo.currentIndex = 6;
            break;
        }
    }

    function updateSettings() {
        settingsMap = {};

        switch (securityCombo.currentIndex) {
        case 1:
            wepHex.updateSettings();
            break;
        case 2:
            wepPassphrase.updateSettings();
            break;
        case 5:
            wpaPsk.updateSettings();
            break;
        }

        switch (securityCombo.currentIndex) {
        case 0:
            settingsMap["key-mgmt"] = "none";
            break;
        case 1:
            settingsMap["key-mgmt"] = "ieee8021x";
            settingsMap["wep-key-type"] = NM.NetworkSettings.Hex;
            break;
        case 2:
            settingsMap["key-mgmt"] = "ieee8021x";
            settingsMap["wep-key-type"] = NM.NetworkSettings.Passphrase;
            break;
        case 3:
            settingsMap["key-mgmt"] = "ieee8021x";
            settingsMap["auth-alg"] = "leap";
            break;
        case 4:
            settingsMap["key-mgmt"] = "ieee8021x";
            break;
        case 5:
            settingsMap["key-mgmt"] = "wpa-psk";
            break;
        case 6:
            settingsMap["key-mgmt"] = "wpa-eap";
            break;
        }
    }
}
