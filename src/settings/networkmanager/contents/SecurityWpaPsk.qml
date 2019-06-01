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
    title: qsTr("WPA && WPA2 Personal")

    PasswordListItem {
        id: passwordField
        width: parent.width
    }

    function loadSettings() {
        passwordField.text = page.settingsMap["psk"];

        if (page.settingsMap["psk-flags"] & NM.NetworkSettings.None)
            passwordField.setSecretFlagType(NM.NetworkSettings.None);
        else if (page.settingsMap["psk-flags"] & NM.NetworkSettings.AgentOwned)
            passwordField.setSecretFlagType(NM.NetworkSettings.AgentOwned);
    }

    function updateSettings() {
        page.settingsMap["psk"] = passwordField.text;
        page.settingsMap["psk-flags"] = passwordField.secretFlagType;
    }
}
