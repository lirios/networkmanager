/****************************************************************************
 * This file is part of Liri.
 *
 * Copyright (C) 2018 Pier Luigi Fiorini <pierluigi.fiorini@gmail.com>
 *
 * $BEGIN_LICENSE:LGPL2.1+$
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 2.1 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * $END_LICENSE$
 ***************************************************************************/

#include <QtQml>

#include "appletproxymodel.h"
#include "connectionicon.h"
#include "networking.h"
#include "networkmodel.h"
#include "networkmodelitem.h"
#include "networksettings.h"
#include "technologyproxymodel.h"

class NetworkManagerPlugin : public QQmlExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID "org.qt-project.Qt.QQmlExtensionInterface")
public:
    void registerTypes(const char *uri)
    {
        // @uri Liri.NetworkManager
        Q_ASSERT(QLatin1String(uri) == QLatin1String("Liri.NetworkManager"));

        qmlRegisterUncreatableType<NetworkModelItem>(uri, 1, 0, "NetworkModelItem",
                                                     QLatin1String("Cannot instantiate NetworkModelItem"));
        qmlRegisterType<AppletProxyModel>(uri, 1, 0, "AppletProxyModel");
        qmlRegisterType<ConnectionIcon>(uri, 1, 0, "ConnectionIcon");
        qmlRegisterType<Networking>(uri, 1, 0, "Networking");
        qmlRegisterType<NetworkModel>(uri, 1, 0, "NetworkModel");
        qmlRegisterType<NetworkSettings>(uri, 1, 0, "NetworkSettings");
        qmlRegisterType<TechnologyProxyModel>(uri, 1, 0, "TechnologyProxyModel");
    }
};

#include "plugin.moc"
