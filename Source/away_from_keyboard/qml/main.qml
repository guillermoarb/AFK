import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15

Window {
    id: window
    width: 400
    height: 100
    visible: true
    color: "#00000000"
    title: qsTr("Hello World")

    Rectangle {
        id: app_container
        visible: true
        color: "#eceff4"
        radius: 5
        border.color: "#00000000"
        border.width: 1
        anchors.fill: parent


        Rectangle {
            id: day_timer_rt
            width: 148
            height: 50
            color: "#00000000"
            border.color: "#00000000"
            border.width: 1
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.leftMargin: 10
            anchors.topMargin: 10

            Label {
                id: day_timer_lb
                color: "#2e3440"
                text: qsTr("01:23")
                anchors.fill: parent
                font.pixelSize: 50
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                topPadding: 4
                clip: true
                padding: 0
                font.weight: Font.Black
                font.bold: false
                styleColor: "#b62323"
                font.family: "Roboto Black"
            }
        }

        Rectangle {
            id: issue_rt
            height: 25
            color: "#ffffff"
            border.color: "#00000000"
            border.width: 1
            anchors.left: day_timer_rt.right
            anchors.right: menu_im.left
            anchors.top: project_rt.bottom
            anchors.rightMargin: 10
            anchors.leftMargin: 10
            anchors.topMargin: 0

            Label {
                id: issue_lb
                text: qsTr("GI_GenIV#43")
                anchors.fill: parent
                padding: 0
                font.pixelSize: 20
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignTop
                topPadding: 3
                font.kerning: true
                font.family: "Roboto"
            }
        }

        Rectangle {
            id: project_rt
            height: 25
            color: "#ffffff"
            border.color: "#00000000"
            border.width: 1
            anchors.left: day_timer_rt.right
            anchors.right: menu_im.left
            anchors.top: parent.top
            anchors.rightMargin: 10
            anchors.leftMargin: 10
            anchors.topMargin: 10

            Label {
                id: project_lb
                text: qsTr("Ford 4x4 Gen IV")
                anchors.fill: parent
                font.pixelSize: 15
                verticalAlignment: Text.AlignBottom

                font.family: "Roboto"
            }
        }

        Rectangle {
            id: task_rt
            height: 20
            color: "#ffffff"
            border.color: "#00000000"
            anchors.left: parent.left
            anchors.right: menu_im.left
            anchors.top: day_timer_rt.bottom
            anchors.rightMargin: 10
            anchors.topMargin: 5
            anchors.leftMargin: 10

            Label {
                id: task_lb
                text: qsTr("Code development  01:23")
                anchors.fill: parent
                font.pixelSize: 15
                verticalAlignment: Text.AlignVCenter
                wrapMode: Text.WrapAnywhere
                font.family: "Roboto"
            }
        }

        Rectangle {
            id: menu_rt
            x: 332
            width: 24
            height: 24
            color: "#ffffff"
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.rightMargin: 10
            anchors.topMargin: 10

            Image {
                id: menu_im
                x: 0
                y: 0
                width: 24
                height: 24
                source: "images/menu_lines.png"
                sourceSize.height: 50
                sourceSize.width: 50
                fillMode: Image.PreserveAspectFit
                
                MouseArea {
                id: menu_ma
                objectName: "menu_ma"
                anchors.fill: parent
                onClicked: {
                    // once the "con" context has been declared,
                    // slots can be called like functions
                    console.outputInt("Menu clicked")
                    }
                onDoubleClicked: {
                    // once the "con" context has been declared,
                    // slots can be called like functions
                    console.outputInt("Menu double clicked")
                    }
                }
            }
        }
    }
}

/*##^##
Designer {
    D{i:0;formeditorColor:"#4c4e50"}
}
##^##*/
