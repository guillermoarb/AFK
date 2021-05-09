import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15

Window {
    width: 400
    height: 90
    visible: true
    title: qsTr("Hello World")

    Rectangle {
        id: app_container
        visible: true
        anchors.fill: parent

        Label {
            id: issue_lb
            x: 159
            y: 33
            width: 190
            height: 25
            text: qsTr("GI_GenIV#43")
            font.pixelSize: 20
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            font.family: "Roboto"
        }

        Label {
            id: activity_timer_lb
            x: 8
            y: 8
            width: 145
            height: 50
            color: "#2e3440"
            text: qsTr("01:23")
            font.pixelSize: 50
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.weight: Font.Black
            font.bold: false
            styleColor: "#b62323"
            font.family: "Roboto Black"
        }

        Label {
            id: task_lb
            x: 8
            y: 64
            width: 471
            height: 20
            text: qsTr("Code development  01:23")
            font.pixelSize: 15
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.WrapAnywhere
            font.family: "Roboto"
        }

        Label {
            id: project_lb
            x: 159
            y: 13
            width: 207
            height: 25
            text: qsTr("Ford 4x4 Gen IV")
            font.pixelSize: 15
            verticalAlignment: Text.AlignVCenter
            font.family: "Roboto"

            Image {
                id: image
                x: 175
                y: 1
                width: 24
                height: 24
                source: "images/menu_vertical.png"
                fillMode: Image.PreserveAspectFit
            }
        }
    }

    Image {
        id: image1
        x: 367
        y: 13
        width: 24
        height: 24
        source: "images/close.png"
        fillMode: Image.PreserveAspectFit
    }
}
