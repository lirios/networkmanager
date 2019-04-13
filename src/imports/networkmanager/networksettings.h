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

#ifndef NETWORKSETTINGS_H
#define NETWORKSETTINGS_H

#include <QObject>

class NetworkSettings : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString currentUserName READ currentUserName CONSTANT)
public:
    // Keep in sync with NetworkManager::Setting::SecretFlagType
    enum SecretFlagType {
        None = 0,
        AgentOwned = 0x01,
        NotSaved = 0x02,
        NotRequired = 0x04
    };
    Q_DECLARE_FLAGS(SecretFlags, SecretFlagType)

    // Keep in sync with NetworkManager::WirelessSecuritySetting::WepKeyType
    enum WepKeyType {
        NotSpecified,
        Hex,
        Passphrase
    };
    Q_ENUM(WepKeyType)

    explicit NetworkSettings(QObject *parent = nullptr);

    QString currentUserName() const;

    Q_INVOKABLE QString ipv4AddressAsString(quint32 ip) const;
    Q_INVOKABLE quint32 ipv4AddressFromString(const QString &ip) const;

    Q_INVOKABLE QString ipv6AddressAsString(const QByteArray &ip) const;
    Q_INVOKABLE QByteArray ipv6AddressFromString(const QString &ip) const;

    Q_INVOKABLE QString macAddressAsString(const QByteArray &address) const;
    Q_INVOKABLE QByteArray macAddressFromString(const QString &address) const;

    Q_INVOKABLE int getSubnetPrefix(const QString &netmask) const;

    Q_INVOKABLE QVariantMap getSettings(const QString &connectionPath, const QString &type) const;
    Q_INVOKABLE void saveSettings(const QString &connectionPath, const QString &type, const QVariantMap &map);

private:
    QString m_currentUserName;
};

#endif // NETWORKSETTINGS_H
