import qbs 1.0

Project {
    name: "NetworkManager"

    readonly property string version: "0.9.0"

    property bool useStaticAnalyzer: false

    condition: qbs.targetOS.contains("linux") && !qbs.targetOS.contains("android")

    minimumQbsVersion: "1.9.0"

    references: [
        "src/imports/networkmanager/networkmanager.qbs",
        "src/settings/networkmanager/networkmanager.qbs",
    ]
}
