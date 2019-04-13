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

import QtQuick 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0
import Liri.NetworkManager 1.0 as NM
import Fluid.Controls 1.0 as FluidControls
import Liri.Settings 1.0

FluidControls.TabbedPage {
    id: wiredPage

    property var model

    title: model.name

    actions: [
        FluidControls.Action {
            icon.source: FluidControls.Utils.iconUrl("content/save")
            toolTip: qsTr("Save this connection")
            onTriggered: {
                identityPage.updateSettings();
                ipV4Page.updateSettings();
                ipV6Page.updateSettings();
                //securityPage.updateSettings();

                console.debug("Identity:", JSON.stringify(identityPage.settingsMap));
                networkSettings.saveSettings(model.connectionPath, "connection", identityPage.settingsMap["connection"]);
                networkSettings.saveSettings(model.connectionPath, "802-3-ethernet", identityPage.settingsMap["802-3-ethernet"]);

                console.debug("IPv4:", JSON.stringify(ipV4Page.settingsMap));
                networkSettings.saveSettings(model.connectionPath, "ipv4", ipV4Page.settingsMap);

                console.debug("IPv6:", JSON.stringify(ipV6Page.settingsMap));
                networkSettings.saveSettings(model.connectionPath, "ipv6", ipV6Page.settingsMap);

                //console.debug("Security:", JSON.stringify(securityPage.settingsMap));
                //networkSettings.saveSettings(model.connectionPath, "802-1x", securityPage.settingsMap);
            }
        }
    ]

    Component.onCompleted: {
        identityPage.settingsMap = {
            "connection": {},
            "802-3-ethernet": {},
        };
        Object.keys(identityPage.settingsMap).forEach(function(key) {
            identityPage.settingsMap[key] = networkSettings.getSettings(model.connectionPath, key);
        });
        console.debug("Identity:", JSON.stringify(identityPage.settingsMap));
        identityPage.loadSettings();

        ipV4Page.settingsMap = networkSettings.getSettings(model.connectionPath, "ipv4");
        console.debug("IPv4:", JSON.stringify(ipV4Page.settingsMap));
        ipV4Page.loadSettings();

        ipV6Page.settingsMap = networkSettings.getSettings(model.connectionPath, "ipv6");
        console.debug("IPv6:", JSON.stringify(ipV6Page.settingsMap));
        ipV6Page.loadSettings();

        //securityPage.settingsMap = networkSettings.getSettings(model.connectionPath, "802-1x");
        //console.warn("Security:", JSON.stringify(securityPage.settingsMap));
        //securityPage.loadSettings();
    }

    FluidControls.Tab {
        title: qsTr("Details")

        WiredDetailsPage {}
    }

    FluidControls.Tab {
        title: qsTr("Identity")

        WiredIdentityPage {
            id: identityPage
        }
    }

    FluidControls.Tab {
        title: qsTr("IPv4")

        IPAddressPage {
            id: ipV4Page
        }
    }

    FluidControls.Tab {
        title: qsTr("IPv6")

        IPAddressPage {
            id: ipV6Page
        }
    }

    FluidControls.Tab {
        title: qsTr("Security")

        WiredSecurityPage {
            id: securityPage
        }
    }
}
