/*
    Copyright (C) 2019 Pier Luigi Fiorini <pierluigi.fiorini@gmail.com>
    Copyright 2013-2018 Jan Grulich <jgrulich@redhat.com>

    This library is free software; you can redistribute it and/or
    modify it under the terms of the GNU Lesser General Public
    License as published by the Free Software Foundation; either
    version 2.1 of the License, or (at your option) version 3, or any
    later version accepted by the membership of KDE e.V. (or its
    successor approved by the membership of KDE e.V.), which shall
    act as a proxy defined in Section 6 of version 3 of the license.

    This library is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
    Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public
    License along with this library.  If not, see <http://www.gnu.org/licenses/>.
*/

#include <NetworkManagerQt/AdslDevice>
#include <NetworkManagerQt/BluetoothDevice>
#include <NetworkManagerQt/BondDevice>
#include <NetworkManagerQt/BridgeDevice>
#include <NetworkManagerQt/InfinibandDevice>
#include <NetworkManagerQt/Manager>
#include <NetworkManagerQt/ModemDevice>
#include <NetworkManagerQt/Settings>
#include <NetworkManagerQt/TeamDevice>
#include <NetworkManagerQt/Utils>
#include <NetworkManagerQt/VlanDevice>
#include <NetworkManagerQt/VpnConnection>
#include <NetworkManagerQt/VpnSetting>
#include <NetworkManagerQt/WiredDevice>
#include <NetworkManagerQt/WirelessDevice>
#include <NetworkManagerQt/WirelessSetting>

#if WITH_MODEMMANAGER_SUPPORT
#include <ModemManagerQt/manager.h>
#include <ModemManagerQt/modem.h>
#include <ModemManagerQt/modemdevice.h>
#include <ModemManagerQt/modem3gpp.h>
#include <ModemManagerQt/modemcdma.h>
#endif

#include "networkmodelitem.h"
#include "uiutils.h"

NetworkModelItem::NetworkModelItem(QObject *parent)
    : QObject(parent)
    , m_connectionState(NetworkManager::ActiveConnection::Deactivated)
    , m_deviceState(NetworkManager::Device::UnknownState)
    , m_detailsValid(false)
    , m_duplicate(false)
    , m_mode(NetworkManager::WirelessSetting::Infrastructure)
    , m_securityType(NetworkManager::NoneSecurity)
    , m_signal(0)
    , m_slave(false)
    , m_type(NetworkManager::ConnectionSettings::Unknown)
    , m_vpnState(NetworkManager::VpnConnection::Unknown)
    , m_rxBytes(0)
    , m_txBytes(0)
{
}

NetworkModelItem::NetworkModelItem(const NetworkModelItem *item, QObject *parent)
    : QObject(parent)
    , m_connectionPath(item->connectionPath())
    , m_connectionState(NetworkManager::ActiveConnection::Deactivated)
    , m_detailsValid(false)
    , m_duplicate(true)
    , m_mode(item->mode())
    , m_name(item->name())
    , m_securityType(item->securityType())
    , m_slave(item->slave())
    , m_ssid(item->ssid())
    , m_timestamp(item->timestamp())
    , m_type(item->type())
    , m_uuid(item->uuid())
    , m_vpnState(NetworkManager::VpnConnection::Unknown)
    , m_rxBytes(0)
    , m_txBytes(0)
{
}

NetworkModelItem::~NetworkModelItem()
{
}

QString NetworkModelItem::activeConnectionPath() const
{
    return m_activeConnectionPath;
}

void NetworkModelItem::setActiveConnectionPath(const QString &path)
{
    m_activeConnectionPath = path;
}

QString NetworkModelItem::connectionPath() const
{
    return m_connectionPath;
}

void NetworkModelItem::setConnectionPath(const QString &path)
{
    m_connectionPath = path;
}

NetworkManager::ActiveConnection::State NetworkModelItem::connectionState() const
{
    return m_connectionState;
}

void NetworkModelItem::setConnectionState(NetworkManager::ActiveConnection::State state)
{
    m_connectionState = state;
}

QString NetworkModelItem::connectionStateString() const
{
    switch (m_connectionState)
    {
    case NetworkManager::ActiveConnection::Activating:
        return tr("Activating");
    case NetworkManager::ActiveConnection::Activated:
        return tr("Activated");
    case NetworkManager::ActiveConnection::Deactivating:
        return tr("Deactivating");
    case NetworkManager::ActiveConnection::Deactivated:
        return tr("Deactivated");
    default:
        break;
    }

    return tr("Unknown");
}

QStringList NetworkModelItem::details() const
{
    if (!m_detailsValid) {
        updateDetails();
    }
    return m_details;
}

QString NetworkModelItem::devicePath() const
{
    return m_devicePath;
}

QString NetworkModelItem::deviceName() const
{
    return m_deviceName;
}

void NetworkModelItem::setDeviceName(const QString &name)
{
    m_deviceName = name;
}

void NetworkModelItem::setDevicePath(const QString &path)
{
    m_devicePath = path;
}

QString NetworkModelItem::deviceState() const
{
    return UiUtils::connectionStateToString(m_deviceState);
}

void NetworkModelItem::setDeviceState(const NetworkManager::Device::State state)
{
    m_deviceState = state;
}

bool NetworkModelItem::duplicate() const
{
    return m_duplicate;
}

QString NetworkModelItem::icon() const
{
    switch (m_type) {
    case NetworkManager::ConnectionSettings::Adsl:
        return QStringLiteral("device/network_cell");
        break;
    case NetworkManager::ConnectionSettings::Bluetooth:
        if (connectionState() == NetworkManager::ActiveConnection::Activated) {
            return QStringLiteral("device/bluetooth_connected");
        } else {
            return QStringLiteral("device/bluetooth");
        }
        break;
    case NetworkManager::ConnectionSettings::Bond:
        break;
    case NetworkManager::ConnectionSettings::Bridge:
        break;
    case NetworkManager::ConnectionSettings::Cdma:
    case NetworkManager::ConnectionSettings::Gsm:
        if (m_signal == 0 ) {
            return QStringLiteral("device/signal_cellular_0_bar");
        } else if (m_signal < 20) {
            return QStringLiteral("device/signal_cellular_1_bar");
        } else if (m_signal < 60) {
            return QStringLiteral("device/signal_cellular_2_bar");
        } else if (m_signal < 80) {
            return QStringLiteral("device/signal_cellular_3_bar");
        } else {
            return QStringLiteral("device/signal_cellular_4_bar");
        }
        break;
    case NetworkManager::ConnectionSettings::Infiniband:
        break;
    case NetworkManager::ConnectionSettings::OLPCMesh:
        break;
    case NetworkManager::ConnectionSettings::Pppoe:
        return QStringLiteral("device/signal_cellular_4_bar");
        break;
    case NetworkManager::ConnectionSettings::Vlan:
        break;
    case NetworkManager::ConnectionSettings::Vpn:
        return QStringLiteral("communication/vpn_key");
        break;
    case NetworkManager::ConnectionSettings::Wired:
        if (connectionState() == NetworkManager::ActiveConnection::Activated) {
            return QStringLiteral("action/settings_ethernet");
        } else {
            return QStringLiteral("action/settings_ethernet");
        }
        break;
    case NetworkManager::ConnectionSettings::Wireless:
        if (m_signal == 0 ) {
            if (m_mode == NetworkManager::WirelessSetting::Adhoc || m_mode == NetworkManager::WirelessSetting::Ap) {
                return (m_securityType <= NetworkManager::NoneSecurity) ? QStringLiteral("device/signal_wifi_4_bar") : QStringLiteral("device/signal_wifi_4_bar_lock");
            }
            return (m_securityType <= NetworkManager::NoneSecurity) ? QStringLiteral("device/signal_wifi_0_bar") : QStringLiteral("device/signal_wifi_0_bar");
        } else if (m_signal < 20) {
            return (m_securityType <= NetworkManager::NoneSecurity) ? QStringLiteral("device/signal_wifi_1_bar") : QStringLiteral("device/signal_wifi_1_bar_lock");
        } else if (m_signal < 40) {
            return (m_securityType <= NetworkManager::NoneSecurity) ? QStringLiteral("device/signal_wifi_2_bar") : QStringLiteral("device/signal_wifi_2_bar_lock");
        } else if (m_signal < 60) {
            return (m_securityType <= NetworkManager::NoneSecurity) ? QStringLiteral("device/signal_wifi_2_bar") : QStringLiteral("device/signal_wifi_2_bar_lock");
        } else if (m_signal < 80) {
            return (m_securityType <= NetworkManager::NoneSecurity) ? QStringLiteral("device/signal_wifi_3_bar") : QStringLiteral("device/signal_wifi_3_bar_lock");
        } else {
            return (m_securityType <= NetworkManager::NoneSecurity) ? QStringLiteral("device/signal_wifi_4_bar") : QStringLiteral("device/signal_wifi_4_bar_lock");
        }
        break;
    default:
        break;
    }

    if (connectionState() == NetworkManager::ActiveConnection::Activated) {
        return QStringLiteral("action/settings_ethernet");
    } else {
        return QStringLiteral("action/settings_ethernet");
    }
}

NetworkModelItem::ItemType NetworkModelItem::itemType() const
{
    if (!m_devicePath.isEmpty() ||
            m_type == NetworkManager::ConnectionSettings::Bond ||
            m_type == NetworkManager::ConnectionSettings::Bridge ||
            m_type == NetworkManager::ConnectionSettings::Vlan ||
            m_type == NetworkManager::ConnectionSettings::Team ||
            ((NetworkManager::status() == NetworkManager::Connected ||
              NetworkManager::status() == NetworkManager::ConnectedLinkLocal ||
              NetworkManager::status() == NetworkManager::ConnectedSiteOnly) && m_type == NetworkManager::ConnectionSettings::Vpn)) {
        if (m_connectionPath.isEmpty() && m_type == NetworkManager::ConnectionSettings::Wireless) {
            return NetworkModelItem::AvailableAccessPoint;
        } else {
            return NetworkModelItem::AvailableConnection;
        }
    }
    return NetworkModelItem::UnavailableConnection;
}

NetworkManager::WirelessSetting::NetworkMode NetworkModelItem::mode() const
{
    return m_mode;
}

void NetworkModelItem::setMode(const NetworkManager::WirelessSetting::NetworkMode mode)
{
    m_mode = mode;
}

QString NetworkModelItem::name() const
{
    return m_name;
}

void NetworkModelItem::setName(const QString &name)
{
    m_name = name;
}

QString NetworkModelItem::originalName() const
{
    if (m_deviceName.isEmpty()) {
        return m_name;
    }
    return m_name % QLatin1String(" (") % m_deviceName % QLatin1Char(')');
}

QString NetworkModelItem::sectionType() const
{
    if (m_connectionState == NetworkManager::ActiveConnection::Activated) {
        return tr("Active connections");
    }  else {
        return tr("Available connections");
    }
}

NetworkManager::WirelessSecurityType NetworkModelItem::securityType() const
{
    return m_securityType;
}

void NetworkModelItem::setSecurityType(NetworkManager::WirelessSecurityType type)
{
    m_securityType = type;
}

int NetworkModelItem::signal() const
{
    return m_signal;
}

void NetworkModelItem::setSignal(int signal)
{
    m_signal = signal;
}

QString NetworkModelItem::signalStrength() const
{
    if (m_signal < 20)
        return tr("None");
    else if (m_signal < 40)
        return tr("Weak");
    else if (m_signal < 50)
        return tr("Ok");
    else if (m_signal < 80)
        return tr("Good");
    else
        return tr("Excellent");
}

bool NetworkModelItem::slave() const
{
    return m_slave;
}

void NetworkModelItem::setSlave(bool slave)
{
    m_slave = slave;
}

QString NetworkModelItem::specificPath() const
{
    return m_specificPath;
}

void NetworkModelItem::setSpecificPath(const QString &path)
{
    m_specificPath = path;
}

QString NetworkModelItem::ssid() const
{
    return m_ssid;
}

void NetworkModelItem::setSsid(const QString &ssid)
{
    m_ssid = ssid;
}

NetworkManager::ConnectionSettings::ConnectionType NetworkModelItem::type() const
{
    return m_type;
}

QDateTime NetworkModelItem::timestamp() const
{
    return m_timestamp;
}

void NetworkModelItem::setTimestamp(const QDateTime &date)
{
    m_timestamp = date;
}

void NetworkModelItem::setType(NetworkManager::ConnectionSettings::ConnectionType type)
{
    m_type = type;
}

QString NetworkModelItem::uni() const
{
    if (m_type == NetworkManager::ConnectionSettings::Wireless && m_uuid.isEmpty()) {
        return QStringLiteral("%1%%2").arg(m_ssid, m_devicePath);
    } else {
        return QStringLiteral("%1%%2").arg(m_connectionPath, m_devicePath);
    }
}

QString NetworkModelItem::uuid() const
{
    return m_uuid;
}

void NetworkModelItem::setUuid(const QString &uuid)
{
    m_uuid = uuid;
}

QString NetworkModelItem::vpnState() const
{
    return UiUtils::vpnConnectionStateToString(m_vpnState);
}

void NetworkModelItem::setVpnState(NetworkManager::VpnConnection::State state)
{
    m_vpnState = state;
}

QString NetworkModelItem::vpnType() const
{
    return m_vpnType;
}

void NetworkModelItem::setVpnType(const QString &type)
{
    m_vpnType = type;
}

qulonglong NetworkModelItem::rxBytes() const
{
    return m_rxBytes;
}

void NetworkModelItem::setRxBytes(qulonglong bytes)
{
    m_rxBytes = bytes;
}

qulonglong NetworkModelItem::txBytes() const
{
    return m_txBytes;
}

void NetworkModelItem::setTxBytes(qulonglong bytes)
{
    m_txBytes = bytes;
}

QString NetworkModelItem::linkSpeed() const
{
    NetworkManager::Device::Ptr device = NetworkManager::findNetworkInterface(m_devicePath);

    if (m_type == NetworkManager::ConnectionSettings::Wired) {
        NetworkManager::WiredDevice::Ptr wiredDevice = device.objectCast<NetworkManager::WiredDevice>();
        if (wiredDevice)
            return UiUtils::connectionSpeed(wiredDevice->bitRate());
    } else if (m_type == NetworkManager::ConnectionSettings::Wireless) {
        NetworkManager::WirelessDevice::Ptr wirelessDevice = device.objectCast<NetworkManager::WirelessDevice>();
        if (wirelessDevice)
            return UiUtils::connectionSpeed(wirelessDevice->bitRate());
    }

    return QString();
}

QString NetworkModelItem::ipV4Address() const
{
    NetworkManager::Device::Ptr device = NetworkManager::findNetworkInterface(m_devicePath);

    if (device && device->ipV4Config().isValid() && m_connectionState == NetworkManager::ActiveConnection::Activated) {
        if (!device->ipV4Config().addresses().isEmpty()) {
            QHostAddress addr = device->ipV4Config().addresses().first().ip();
            if (!addr.isNull())
                return addr.toString();
        }
    }

    return QString();
}

QString NetworkModelItem::ipV6Address() const
{
    NetworkManager::Device::Ptr device = NetworkManager::findNetworkInterface(m_devicePath);

    if (device && device->ipV6Config().isValid() && m_connectionState == NetworkManager::ActiveConnection::Activated) {
        if (!device->ipV6Config().addresses().isEmpty()) {
            QHostAddress addr = device->ipV6Config().addresses().first().ip();
            if (!addr.isNull())
                return addr.toString();
        }
    }

    return QString();
}

QString NetworkModelItem::gateway() const
{
    NetworkManager::Device::Ptr device = NetworkManager::findNetworkInterface(m_devicePath);

    if (device && device->ipV4Config().isValid() && m_connectionState == NetworkManager::ActiveConnection::Activated)
        return device->ipV4Config().gateway();

    return QString();
}

QString NetworkModelItem::nameServer() const
{
    NetworkManager::Device::Ptr device = NetworkManager::findNetworkInterface(m_devicePath);

    if (device && device->ipV4Config().isValid() && m_connectionState == NetworkManager::ActiveConnection::Activated) {
        if (!device->ipV4Config().nameservers().isEmpty()) {
            QHostAddress addr = device->ipV4Config().nameservers().first();
            if (!addr.isNull())
                return addr.toString();
        }
    }

    return QString();
}

QString NetworkModelItem::macAddress() const
{
    NetworkManager::Device::Ptr device = NetworkManager::findNetworkInterface(m_devicePath);

    if (m_type == NetworkManager::ConnectionSettings::Wired) {
        NetworkManager::WiredDevice::Ptr wiredDevice = device.objectCast<NetworkManager::WiredDevice>();
        if (wiredDevice)
            return wiredDevice->permanentHardwareAddress();
    } else if (m_type == NetworkManager::ConnectionSettings::Wireless) {
        NetworkManager::WirelessDevice::Ptr wirelessDevice = device.objectCast<NetworkManager::WirelessDevice>();
        if (wirelessDevice)
            return wirelessDevice->permanentHardwareAddress();
    } else if (m_type == NetworkManager::ConnectionSettings::Bluetooth) {
        NetworkManager::BluetoothDevice::Ptr bluetoothDevice = device.objectCast<NetworkManager::BluetoothDevice>();
        if (bluetoothDevice)
            return bluetoothDevice->hardwareAddress();
    } else if (m_type == NetworkManager::ConnectionSettings::Infiniband) {
        NetworkManager::InfinibandDevice::Ptr infinibandDevice = device.objectCast<NetworkManager::InfinibandDevice>();
        if (infinibandDevice)
            return infinibandDevice->hwAddress();;
    } else if (m_type == NetworkManager::ConnectionSettings::Bond) {
        NetworkManager::BondDevice::Ptr bondDevice = device.objectCast<NetworkManager::BondDevice>();
        if (bondDevice)
            return bondDevice->hwAddress();
    } else if (m_type == NetworkManager::ConnectionSettings::Bridge) {
        NetworkManager::BridgeDevice::Ptr bridgeDevice = device.objectCast<NetworkManager::BridgeDevice>();
        if (bridgeDevice)
            return bridgeDevice->hwAddress();
    } else if (m_type == NetworkManager::ConnectionSettings::Vlan) {
        NetworkManager::VlanDevice::Ptr vlanDevice = device.objectCast<NetworkManager::VlanDevice>();
        if (vlanDevice)
            return vlanDevice->hwAddress();
    } else if (m_type == NetworkManager::ConnectionSettings::Team) {
        NetworkManager::TeamDevice::Ptr teamDevice = device.objectCast<NetworkManager::TeamDevice>();
        if (teamDevice)
            return teamDevice->hwAddress();
    }

    return QString();
}

bool NetworkModelItem::operator==(const NetworkModelItem *item) const
{
    if (!item->uuid().isEmpty() && !uuid().isEmpty()) {
        if (item->devicePath() == devicePath() && item->uuid() == uuid()) {
            return true;
        }
    } else if (item->type() == NetworkManager::ConnectionSettings::Wireless && type() == NetworkManager::ConnectionSettings::Wireless) {
        if (item->ssid() == ssid() && item->devicePath() == devicePath()) {
            return true;
        }
    }

    return false;
}

void NetworkModelItem::invalidateDetails()
{
    m_detailsValid = false;
}

void NetworkModelItem::updateDetails() const
{
    m_detailsValid = true;
    m_details.clear();

    if (itemType() == NetworkModelItem::UnavailableConnection) {
        return;
    }

    NetworkManager::Device::Ptr device = NetworkManager::findNetworkInterface(m_devicePath);

    // Get IPv[46]Address
    if (device && device->ipV4Config().isValid() && m_connectionState == NetworkManager::ActiveConnection::Activated) {
        if (!device->ipV4Config().addresses().isEmpty()) {
            QHostAddress addr = device->ipV4Config().addresses().first().ip();
            if (!addr.isNull()) {
                m_details << tr("IPv4 Address") << addr.toString();
            }
        }
    }

    if (device && device->ipV6Config().isValid() && m_connectionState == NetworkManager::ActiveConnection::Activated) {
        if (!device->ipV6Config().addresses().isEmpty()) {
            QHostAddress addr = device->ipV6Config().addresses().first().ip();
            if (!addr.isNull()) {
                m_details << tr("IPv6 Address") << addr.toString();
            }
        }
    }

    if (m_type == NetworkManager::ConnectionSettings::Wired) {
        NetworkManager::WiredDevice::Ptr wiredDevice = device.objectCast<NetworkManager::WiredDevice>();
        if (wiredDevice) {
            if (m_connectionState == NetworkManager::ActiveConnection::Activated) {
                m_details << tr("Connection speed") << UiUtils::connectionSpeed(wiredDevice->bitRate());
            }
            m_details << tr("MAC Address") << wiredDevice->permanentHardwareAddress();
        }
    } else if (m_type == NetworkManager::ConnectionSettings::Wireless) {
        NetworkManager::WirelessDevice::Ptr wirelessDevice = device.objectCast<NetworkManager::WirelessDevice>();
        m_details << tr("Access point (SSID)") << m_ssid;
        if (m_mode == NetworkManager::WirelessSetting::Infrastructure) {
            m_details << tr("Signal strength") << QStringLiteral("%1%").arg(m_signal);
        }
        if (m_connectionState == NetworkManager::ActiveConnection::Activated) {
            m_details << tr("Security type") << UiUtils::labelFromWirelessSecurity(m_securityType);
        }
        if (wirelessDevice) {
            if (m_connectionState == NetworkManager::ActiveConnection::Activated) {
                m_details << tr("Connection speed") << UiUtils::connectionSpeed(wirelessDevice->bitRate());
            }
            m_details << tr("MAC Address") << wirelessDevice->permanentHardwareAddress();
        }
    } else if (m_type == NetworkManager::ConnectionSettings::Gsm || m_type == NetworkManager::ConnectionSettings::Cdma) {
#if WITH_MODEMMANAGER_SUPPORT
        NetworkManager::ModemDevice::Ptr modemDevice = device.objectCast<NetworkManager::ModemDevice>();
        if (modemDevice) {
            ModemManager::ModemDevice::Ptr modem = ModemManager::findModemDevice(modemDevice->udi());
            if (modem) {
                ModemManager::Modem::Ptr modemNetwork = modem->interface(ModemManager::ModemDevice::ModemInterface).objectCast<ModemManager::Modem>();

                if (m_type == NetworkManager::ConnectionSettings::Gsm) {
                    ModemManager::Modem3gpp::Ptr gsmNet = modem->interface(ModemManager::ModemDevice::GsmInterface).objectCast<ModemManager::Modem3gpp>();
                    if (gsmNet) {
                        m_details << tr("Operator") << gsmNet->operatorName();
                    }
                } else {
                    ModemManager::ModemCdma::Ptr cdmaNet = modem->interface(ModemManager::ModemDevice::CdmaInterface).objectCast<ModemManager::ModemCdma>();
                    m_details << tr("Network ID") << QString::number(cdmaNet->nid());
                }

                if (modemNetwork) {
                    m_details << tr("Signal Quality") << QStringLiteral("%1%").arg(modemNetwork->signalQuality().signal);
                    m_details << tr("Access Technology") << UiUtils::convertAccessTechnologyToString(modemNetwork->accessTechnologies());
                }
            }
        }
#endif
    } else if (m_type == NetworkManager::ConnectionSettings::Vpn) {
        m_details << tr("VPN plugin") << m_vpnType;

        if (m_connectionState == NetworkManager::ActiveConnection::Activated) {
            NetworkManager::ActiveConnection::Ptr active = NetworkManager::findActiveConnection(m_activeConnectionPath);
            NetworkManager::VpnConnection::Ptr vpnConnection;

            if (active) {
                vpnConnection = NetworkManager::VpnConnection::Ptr(new NetworkManager::VpnConnection(active->path()), &QObject::deleteLater);
            }

            if (vpnConnection && !vpnConnection->banner().isEmpty()) {
                m_details << tr("Banner") << vpnConnection->banner().simplified();
            }
        }
    } else if (m_type == NetworkManager::ConnectionSettings::Bluetooth) {
        NetworkManager::BluetoothDevice::Ptr bluetoothDevice = device.objectCast<NetworkManager::BluetoothDevice>();
        if (bluetoothDevice) {
            m_details << tr("Name") << bluetoothDevice->name();
            if (bluetoothDevice->bluetoothCapabilities() == NetworkManager::BluetoothDevice::Pan) {
                m_details << tr("Capabilities") << QStringLiteral("PAN");
            } else if (bluetoothDevice->bluetoothCapabilities() == NetworkManager::BluetoothDevice::Dun) {
                m_details << tr("Capabilities") << QStringLiteral("DUN");
            }
            m_details << tr("MAC Address") << bluetoothDevice->hardwareAddress();

        }
    } else if (m_type == NetworkManager::ConnectionSettings::Infiniband) {
        NetworkManager::InfinibandDevice::Ptr infinibandDevice = device.objectCast<NetworkManager::InfinibandDevice>();
        m_details << tr("Type") << tr("Infiniband");
        if (infinibandDevice) {
            m_details << tr("MAC Address") << infinibandDevice->hwAddress();
        }
    } else if (m_type == NetworkManager::ConnectionSettings::Bond) {
        NetworkManager::BondDevice::Ptr bondDevice = device.objectCast<NetworkManager::BondDevice>();
        m_details << tr("Type") << tr("Bond");
        if (bondDevice) {
            m_details << tr("MAC Address") << bondDevice->hwAddress();
        }
    } else if (m_type == NetworkManager::ConnectionSettings::Bridge) {
        NetworkManager::BridgeDevice::Ptr bridgeDevice = device.objectCast<NetworkManager::BridgeDevice>();
        m_details << tr("Type") << tr("Bridge");
        if (bridgeDevice) {
            m_details << tr("MAC Address") << bridgeDevice->hwAddress();
        }
    } else if (m_type == NetworkManager::ConnectionSettings::Vlan) {
        NetworkManager::VlanDevice::Ptr vlanDevice = device.objectCast<NetworkManager::VlanDevice>();
        m_details << tr("Type") << tr("Vlan");
        if (vlanDevice) {
            m_details << tr("Vlan ID") << QString::number(vlanDevice->vlanId());
            m_details << tr("MAC Address") << vlanDevice->hwAddress();
        }
    } else if (m_type == NetworkManager::ConnectionSettings::Adsl) {
        m_details << tr("Type") << tr("Adsl");
    }
    else if (m_type == NetworkManager::ConnectionSettings::Team) {
        NetworkManager::TeamDevice::Ptr teamDevice = device.objectCast<NetworkManager::TeamDevice>();
        m_details << tr("Type") << tr("Team");
        if (teamDevice) {
            m_details << tr("MAC Address") << teamDevice->hwAddress();
        }
    }
}
