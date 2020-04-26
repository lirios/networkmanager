Network Manager
===============

[![License](https://img.shields.io/badge/license-GPLv3.0-blue.svg)](https://www.gnu.org/licenses/gpl-3.0.html)
[![GitHub release](https://img.shields.io/github/release/lirios/networkmanager.svg)](https://github.com/lirios/networkmanager)
[![CI](https://github.com/lirios/networkmanager/workflows/CI/badge.svg?branch=develop)](https://github.com/lirios/networkmanager/actions?query=workflow%3ACI)
[![GitHub issues](https://img.shields.io/github/issues/lirios/networkmanager.svg)](https://github.com/lirios/networkmanager/issues)

NetworkManager support for Liri.

## Features

This repository contains:

 * A QML plugin to use and configure NetworkManager
 * An indicator for the shell
 * A configuration module for Settings

## Dependencies

Qt >= 5.10.0 with at least the following modules is required:

 * [qtbase](http://code.qt.io/cgit/qt/qtbase.git)
 * [qtdeclarative](http://code.qt.io/cgit/qt/qtdeclarative.git)
 * [qtquickcontrols2](http://code.qt.io/cgit/qt/qtquickcontrols2.git)

The following modules and their dependencies are required:

 * [cmake](https://gitlab.kitware.com/cmake/cmake) >= 3.10.0
 * [cmake-shared](https://github.com/lirios/cmake-shared.git) >= 1.0.0
 * [fluid](https://github.com/lirios/fluid.git) >= 1.0.0
 * [libliri](https://github.com/lirios/libliri.git)
 * [networkmanager-qt](http://quickgit.kde.org/?p=networkmanager-qt.git)
 * [modemmanager-qt](http://quickgit.kde.org/?p=modemmanager-qt.git)

## Installation

```sh
mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=/path/to/prefix ..
make
make install # use sudo if necessary
```

Replace `/path/to/prefix` to your installation prefix.
Default is `/usr/local`.

## Translations

We use Transifex to translate this project, please submit your
translations [here](https://www.transifex.com/lirios/liri-networkmanager/dashboard/).

```sh
./scripts/txpush.sh
```

New translations can be pulled from Transifex with:

```sh
./scripts/txpull.sh
```

## Notes

### Logging categories

Qt 5.2 introduced logging categories and we takes advantage of
them to make debugging easier.

Please refer to the [Qt](http://doc.qt.io/qt-5/qloggingcategory.html) documentation
to learn how to enable them.

### Available categories

 * Network QML plugin:
   * **liri.networkmanager:** NetworkManager support.

## Licensing

Licensed under the terms of the GNU General Public License version 3.
