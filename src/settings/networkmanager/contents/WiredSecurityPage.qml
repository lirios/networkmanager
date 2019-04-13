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
                    text: qsTr("802.1x Security")
                    rightItem: Switch {
                        id: securitySwitch
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                FluidControls.ListItem {
                    secondaryItem: ComboBox {
                        id: securityCombo
                        anchors.verticalCenter: parent.verticalCenter
                        width: parent.width
                        textRole: "label"
                        enabled: securitySwitch.checked
                        model: ListModel {
                            ListElement {
                                //: Security method
                                label: QT_TR_NOOP("MD5")
                            }
                            ListElement {
                                //: Security method
                                label: QT_TR_NOOP("TLS")
                            }
                            ListElement {
                                //: Security method
                                label: QT_TR_NOOP("PWD")
                            }
                            ListElement {
                                //: Security method
                                label: QT_TR_NOOP("FAST")
                            }
                            ListElement {
                                //: Security method
                                label: QT_TR_NOOP("Tunneled TLS")
                            }
                            ListElement {
                                //: Security method
                                label: QT_TR_NOOP("Protected EAP (PEAP)")
                            }
                        }
                    }
                }
            }
        }
    }

    function loadSettings() {
    }

    function updateSettings() {
        settingsMap = {};
    }
}
