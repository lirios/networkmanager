Network Manager
===============

[![ZenHub.io](https://img.shields.io/badge/supercharged%20by-zenhub.io-blue.svg)](https://zenhub.io)

[![License](https://img.shields.io/badge/license-GPLv3.0-blue.svg)](https://www.gnu.org/licenses/gpl-3.0.html)
[![GitHub release](https://img.shields.io/github/release/lirios/networkmanager.svg)](https://github.com/lirios/networkmanager)
[![Build Status](https://travis-ci.org/lirios/networkmanager.svg?branch=develop)](https://travis-ci.org/lirios/networkmanager)
[![GitHub issues](https://img.shields.io/github/issues/lirios/networkmanager.svg)](https://github.com/lirios/networkmanager/issues)
[![Maintained](https://img.shields.io/maintenance/yes/2018.svg)](https://github.com/lirios/networkmanager/commits/develop)

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

 * [qbs](http://code.qt.io/cgit/qbs/qbs.git) >= 1.9.0
 * [qbs-shared](https://github.com/lirios/qbs-shared.git) >= 1.2.0
 * [fluid](https://github.com/lirios/fluid.git) >= 1.0.0
 * [networkmanager-qt](http://quickgit.kde.org/?p=networkmanager-qt.git)
 * [modemmanager-qt](http://quickgit.kde.org/?p=modemmanager-qt.git)

## Installation

Qbs is a new build system that is much easier to use compared to qmake or CMake.

If you want to learn more, please read the [Qbs manual](http://doc.qt.io/qbs/index.html),
especially the [setup guide](http://doc.qt.io/qbs/configuring.html) and how to install artifacts
from the [installation guide](http://doc.qt.io/qbs/installing-files.html).

If you haven't already, start by setting up a `qt5` profile for `qbs`:

```sh
qbs setup-toolchains --type gcc /usr/bin/g++ gcc
qbs setup-qt $(which qmake) qt5 # make sure that qmake is in PATH
qbs config profiles.qt5.baseProfile gcc
```

Then, from the root of the repository, run:

```sh
qbs -d build -j $(nproc) profile:qt5 # use sudo if necessary
```

To the `qbs` call above you can append additional configuration parameters:

 * `modules.lirideployment.prefix:/path/to/prefix` where most files are installed (default: `/usr/local`)
 * `modules.lirideployment.dataDir:path/to/lib` where data files are installed (default: `/usr/local/share`)
 * `modules.lirideployment.libDir:path/to/lib` where libraries are installed (default: `/usr/local/lib`)
 * `modules.lirideployment.qmlDir:path/to/qml` where QML plugins are installed (default: `/usr/local/lib/qml`)
 * `modules.lirideployment.pluginsDir:path/to/plugins` where Qt plugins are installed (default: `/usr/local/lib/plugins`)
 * `modules.lirideployment.qbsModulesDir:path/to/qbs` where Qbs modules are installed (default: `/usr/local/share/qbs/modules`)

See [lirideployment.qbs](https://github.com/lirios/qbs-shared/blob/develop/modules/lirideployment/lirideployment.qbs)
for more deployment-related parameters.

You can also specify the following options:

 * `projects.NetworkManager.useStaticAnalyzer:true` to enable the Clang static analyzer

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
