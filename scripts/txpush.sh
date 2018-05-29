#!/bin/bash

LUPDATE=${LUPDATE-lupdate}

###
# Update source translation files
###

indicatordir=src/indicators/networkmanager
mkdir -p $indicatordir/translations
$LUPDATE $indicatordir/contents -ts -no-obsolete $indicatordir/translations/networkmanager.ts

settingsdir=src/settings/networkmanager
mkdir -p $settingsdir/translations
$LUPDATE $settingsdir/contents -ts -no-obsolete $settingsdir/translations/networkmanager.ts

tx push --source --no-interactive
