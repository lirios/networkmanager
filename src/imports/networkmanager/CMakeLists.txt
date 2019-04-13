find_package(KF5NetworkManagerQt "${KF5_MIN_VERSION}" REQUIRED)
find_package(KF5ModemManagerQt "${KF5_MIN_VERSION}" REQUIRED)

if(NOT TARGET Liri::Notifications)
    find_package(Liri1Notifications REQUIRED)
endif()

liri_add_qml_plugin(nm
    MODULE_PATH
        "Liri/NetworkManager"
    VERSION
        "1.0"
    SOURCES
        appletproxymodel.cpp
        appletproxymodel.h
        connectionicon.cpp
        connectionicon.h
        connectionsettings.cpp
        connectionsettings.h
        networking.cpp
        networking.h
        networkitemslist.cpp
        networkitemslist.h
        networkmodel.cpp
        networkmodel.h
        networkmodelitem.cpp
        networkmodelitem.h
        networksettings.cpp
        networksettings.h
        plugin.cpp
        technologyproxymodel.cpp
        technologyproxymodel.h
        uiutils.cpp
        uiutils.h
    QML_FILES
        qmldir
    DEFINES
        QT_NO_CAST_FROM_ASCII
        QT_NO_FOREACH
        QT_NO_KEYWORDS
        WITH_MODEMMANAGER_SUPPORT
    LIBRARIES
        Qt5::Core
        Qt5::DBus
        KF5::NetworkManagerQt
        KF5::ModemManagerQt
        Liri::Notifications
)
