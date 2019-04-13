/****************************************************************************
 * This file is part of Liri.
 *
 * Copyright (C) 2017 Pier Luigi Fiorini <pierluigi.fiorini@gmail.com>
 *
 * $BEGIN_LICENSE:LGPLv3+$
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
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

#include <QHostAddress>

#include <NetworkManagerQt/ActiveConnection>
#include <NetworkManagerQt/Connection>
#include <NetworkManagerQt/ConnectionSettings>
#include <NetworkManagerQt/Manager>
#include <NetworkManagerQt/Settings>
#include <NetworkManagerQt/Utils>

#include "networksettings.h"

#include <sys/types.h>
#include <unistd.h>
#include <pwd.h>

// To know more about NetworkManager settings map, please take a look at:
// https://developer.gnome.org/NetworkManager/stable/index.html

NetworkSettings::NetworkSettings(QObject *parent)
    : QObject(parent)
{
    // Find the current user name
    uid_t uid = ::geteuid();
    struct passwd *pw = ::getpwuid(uid);
    if (pw)
        m_currentUserName = QString::fromLocal8Bit(pw->pw_name);
}

QString NetworkSettings::currentUserName() const
{
    return m_currentUserName;
}

QString NetworkSettings::ipv4AddressAsString(quint32 ip) const
{
    return QHostAddress(ip).toString();
}

quint32 NetworkSettings::ipv4AddressFromString(const QString &ip) const
{
    return QHostAddress(ip).toIPv4Address();
}

QString NetworkSettings::ipv6AddressAsString(const QByteArray &ip) const
{
    return NetworkManager::ipv6AddressAsHostAddress(ip).toString();
}

QByteArray NetworkSettings::ipv6AddressFromString(const QString &ip) const
{
    return NetworkManager::ipv6AddressFromHostAddress(QHostAddress(ip));
}

QString NetworkSettings::macAddressAsString(const QByteArray &address) const
{
    return NetworkManager::macAddressAsString(address);
}

QByteArray NetworkSettings::macAddressFromString(const QString &address) const
{
    return NetworkManager::macAddressFromString(address);
}

int NetworkSettings::getSubnetPrefix(const QString &netmask) const
{
    return QHostAddress::parseSubnet(netmask).second;
}

QVariantMap NetworkSettings::getSettings(const QString &connectionPath, const QString &type) const
{
    if (type.isEmpty())
        return QVariantMap();

    NetworkManager::Connection::Ptr connection = NetworkManager::findConnection(connectionPath);
    if (!connection)
        return QVariantMap();

    return connection->settings()->toMap().value(type);
}

void NetworkSettings::saveSettings(const QString &connectionPath, const QString &type, const QVariantMap &map)
{
    NetworkManager::Connection::Ptr connection = NetworkManager::findConnection(connectionPath);
    if (!connection)
        return;

    NMVariantMapMap updateMap = connection->settings()->toMap();
    updateMap.insert(type, map);

    connection->update(updateMap);
}
