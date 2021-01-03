cmake_minimum_required(VERSION 3.10.0)

project("NetworkManager"
    VERSION "0.9.0"
    DESCRIPTION "NetworkManager support for Liri"
    LANGUAGES CXX C
)

## Shared macros and functions:
if(NOT LIRI_LOCAL_ECM)
    find_package(LiriCMakeShared "1.0.0" REQUIRED NO_MODULE)
    list(APPEND CMAKE_MODULE_PATH "${LCS_MODULE_PATH}")
endif()

## Set minimum versions required:
set(QT_MIN_VERSION "5.10.0")
set(KF5_MIN_VERSION "5.48.0")

## Liri specific setup common for all modules:
include(LiriSetup)

## Find Qt 5:
find_package(Qt5 "${QT_MIN_VERSION}"
    CONFIG REQUIRED
    COMPONENTS
        Core
        DBus
        Xml
        Gui
        Qml
        Quick
        LinguistTools
)

## Add subdirectories:
add_subdirectory(src/imports/networkmanager)
add_subdirectory(src/settings/networkmanager)
add_subdirectory(src/statusarea/networkmanager)
