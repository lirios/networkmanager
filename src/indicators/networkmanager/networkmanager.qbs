import qbs 1.0

Product {
    name: "networkmanager-indicator"

    Depends { name: "lirideployment" }

    Group {
        prefix: "contents/"
        files: [
            "main.qml",
            "AirplaneMode.qml",
            "ConnectionItem.qml",
        ]
        qbs.install: true
        qbs.installSourceBase: prefix
        qbs.installDir: lirideployment.dataDir + "/liri-shell/indicators/networkmanager/contents"
    }
}
