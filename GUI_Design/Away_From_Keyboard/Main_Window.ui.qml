import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15
import QtQuick.Layouts 1.11

Item {
    id: item1
    width: 1000
    height: 300
    visible: true
    property alias app_container: app_container

    Rectangle {
        id: app_container
        visible: true
        anchors.fill: parent
        anchors.rightMargin: 0
        anchors.bottomMargin: 0
        anchors.leftMargin: 0
        anchors.topMargin: 0

        Label {
            id: issue_lb
            x: 521
            y: 145
            width: 190
            height: 25
            text: qsTr("GI_GenIV#43")
            font.pixelSize: 25
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            font.family: "Roboto"
        }

        Label {
            id: day_time_lb
            x: 272
            y: 95
            width: 243
            height: 75
            color: "#2e3440"
            text: qsTr("01:23")
            font.pixelSize: 100
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.weight: Font.Light
            font.bold: true
            styleColor: "#b62323"
            font.family: "Roboto"
        }

        Label {
            id: task_lb
            x: 272
            y: 179
            width: 471
            height: 20
            text: qsTr("Code development  01:23")
            font.pixelSize: 20
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.WrapAnywhere
            font.family: "Roboto"
        }

        Label {
            id: status_lb
            x: -153
            y: -107
            width: 129
            text: qsTr("saving...")
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            font.pixelSize: 15
            verticalAlignment: Text.AlignVCenter
            font.family: "Roboto Mono"
            anchors.topMargin: 206
            anchors.leftMargin: 272
            anchors.bottomMargin: 63
        }

        Label {
            id: project_lb
            x: 521
            y: 114
            width: 207
            height: 25
            text: qsTr("Ford 4x4 Gen IV")
            font.pixelSize: 25
            verticalAlignment: Text.AlignVCenter
            font.family: "Roboto"
        }
    }
}
