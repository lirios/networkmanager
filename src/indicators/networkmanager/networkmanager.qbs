import qbs 1.0

LiriIndicator {
    shortName: "networkmanager"

    Group {
        name: "Metadata"
        files: ["metadata.desktop.in"]
        fileTags: ["liri.desktop.template"]
    }

    Group {
        name: "Metadata Translations"
        files: ["metadata_*.desktop"]
        prefix: "translations/"
        fileTags: ["liri.desktop.translations"]
    }

    Group {
        name: "Contents"
        prefix: "contents/"
        files: [
            "main.qml",
            "AirplaneMode.qml",
            "ConnectionItem.qml",
        ]
        fileTags: ["liri.indicator.contents"]
    }

    Group {
        name: "Translations"
        files: ["*_*.ts"]
        prefix: "translations/"
    }
}
