// SPDX-FileCopyrightText: 2021 Pier Luigi Fiorini <pierluigi.fiorini@gmail.com>
//
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import Fluid.Controls 1.0 as FluidControls
import Liri.Shell 1.0 as Shell
import Liri.NetworkManager 1.0 as NM

Shell.StatusAreaExtension {
    NM.Networking {
        id: networking
    }

    NM.ConnectionIcon {
        id: connectionIconProvider
    }

    Component {
        id: pageComponent

        Page {
            padding: 0
            header: RowLayout {
                ToolButton {
                    icon.source: FluidControls.Utils.iconUrl("navigation/arrow_back")
                    onClicked: {
                        popFromMenu();
                    }
                }

                FluidControls.TitleLabel {
                    text: qsTr("Network")

                    Layout.alignment: Qt.AlignVCenter
                    Layout.fillWidth: true
                }
            }

            ScrollView {
                anchors.fill: parent
                clip: true

                ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

                ListView {
                    model: NM.AppletProxyModel {
                        sourceModel: NM.NetworkModel {}
                    }
                    currentIndex: -1
                    section.property: "section"
                    section.delegate: FluidControls.Subheader {
                        text: section
                    }
                    header: FluidControls.ListItem {
                        text: qsTr("Wi-Fi")
                        rightItem: Switch {
                            id: wirelessSwitch

                            anchors.verticalCenter: parent.verticalCenter
                            onCheckedChanged: {
                                networking.wirelessEnabled = checked;
                            }
                        }
                    }

                    delegate: Connection {}
                }
            }

            Component.onCompleted: {
                wirelessSwitch.checked = networking.wirelessEnabled;
            }
        }
    }

    indicator: Shell.Indicator {
        title: qsTr("Network")
        iconSource: FluidControls.Utils.iconUrl(connectionIconProvider.connectionTooltipIcon)
        visible: networking.enabled
    }

    menu: FluidControls.ListItem {
        icon.source: FluidControls.Utils.iconUrl(connectionIconProvider.connectionTooltipIcon)
        text: qsTr("Network")
        onClicked: {
            pushToMenu(pageComponent);
        }
    }
}
