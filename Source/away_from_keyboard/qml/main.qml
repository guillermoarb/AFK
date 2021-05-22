import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15

Window {
    id: window
    width: 400
    height: 1000
    visible: true
    color: "#00000000"
    title: qsTr("Hello World")
    flags: Qt.Window | Qt.FramelessWindowHint


    Connections{
        target: backend
        //Python signal is setText, sintax is strange
        function onDayTimerSetText(text){
            day_timer_lb.text = text
        }

        function onProjectSetText(text){
            project_lb.text = text
        }

        function onIssueSetText(text){
            issue_lb.text = text
        }

        function onTaskSetText(text){
            task_lb.text = text
        }

        function onStatusSetText(text){
            status_lb.text = text
        }

        function onStatusSetColor(color){
            status_clipped_rt.color = color
        }

    }

    Rectangle {
        id: app_container
        x: 0
        y: 159
        width: 400
        height: 100
        visible: true
        radius: 5
        border.color: "#00000000"
        border.width: 1
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter


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
                
                MouseArea {
                    id: day_timer_ma
                    objectName: "day_timer_ma"
                    anchors.fill: parent
                    onClicked: {
                        backend.day_timer_ma_clicked(day_timer_lb.text)
                        edit_container.visible = true
                    }
                }
            }
        }

        Rectangle {
            id: issue_rt
            height: 25
            color: "#00000000"
            border.color: "#00000000"
            border.width: 2
            anchors.left: day_timer_rt.right
            anchors.right: menu_rt.left
            anchors.top: project_rt.bottom
            anchors.rightMargin: 10
            anchors.topMargin: -2
            anchors.leftMargin: 10

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
                
                MouseArea {
                    id: issue_ma
                    objectName: "issue_ma"
                    anchors.fill: parent
                    onClicked: {
                        backend.issue_ma_clicked(issue_lb.text)
                        edit_container.visible = false

                    }
                }
            }
        }

        Rectangle {
            id: project_rt
            width: 100
            height: 25
            color: "#00000000"
            border.color: "#00000000"
            border.width: 1
            anchors.left: day_timer_rt.right
            anchors.right: menu_rt.left
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
                
                MouseArea {
                    id: project_ma
                    anchors.fill: parent
                    objectName: "project_ma"
                    onClicked: {
                        backend.project_ma_clicked(project_lb.text)
                    }
                }
            }
        }

        Rectangle {
            id: task_rt
            height: 20
            color: "#00000000"
            border.color: "#00000000"
            anchors.left: parent.left
            anchors.right: menu_rt.left
            anchors.top: day_timer_rt.bottom
            anchors.topMargin: 5
            anchors.leftMargin: 10
            anchors.rightMargin: 10

            Label {
                id: task_lb
                text: qsTr("Code development  01:23")
                anchors.fill: parent
                font.pixelSize: 15
                verticalAlignment: Text.AlignVCenter
                wrapMode: Text.WrapAnywhere
                font.family: "Roboto"
                
                MouseArea {
                    id: task_ma
                    objectName: "task_ma"
                    anchors.fill: parent
                    onClicked: {
                        backend.task_ma_clicked(task_lb.text)
                    }
                }
            }
        }

        Rectangle {
            id: menu_rt
            x: 332
            width: 24
            height: 24
            color: "#00000000"
            border.color: "#00000000"
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.rightMargin: 10
            anchors.topMargin: 10

            Image {
                id: menu_im
                anchors.fill: parent
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
                        //console.outputInt("Menu clicked")
                        backend.menu_ma_clicked()
                    }
                    onDoubleClicked: {
                        // once the "con" context has been declared,
                        // slots can be called like functions
                        //console.outputInt("Menu double clicked")
                    }
                }
            }



        }


        Rectangle {
            id: status_clipper_rt
            y: 85
            height: 15
            color: "transparent"
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.rightMargin: 0
            anchors.leftMargin: 0
            anchors.bottomMargin: 0
            clip: true

            Rectangle {
                id: status_clipped_rt
                radius: 5
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.topMargin: -3
                anchors.rightMargin: 0
                anchors.leftMargin: 0
                anchors.bottomMargin: 0
                color: "#4fe7a1"

                Label {
                    id: status_lb
                    text: qsTr("Saving ...")
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    font.pixelSize: 12
                    verticalAlignment: Text.AlignVCenter
                    font.family: "Roboto"
                    anchors.rightMargin: 0
                    anchors.leftMargin: 10
                    anchors.topMargin: 3
                    anchors.bottomMargin: 0
                }
            }
        }

            DragHandler {
                        onActiveChanged: if(active){
                                             window.startSystemMove()
                                             //internal.ifMaximizedWindowRestore()
                                         }
                    }



    }

    Rectangle {
        id: edit_container
        x: 0
        y: 159
        width: 400
        height: 100
        color: "#ffffff"
        radius: 5
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        visible: false



        TextField {
            id: project_tl
            y: 10
            width: 200
            height: 25

            placeholderText: qsTr("Project")
            color: "#3B4252"
            anchors.verticalCenter: edit_project_lb_rt.verticalCenter
            anchors.left: edit_project_lb_rt.right
            font.pixelSize: 15
            padding: 0
            rightPadding: 0
            bottomPadding: 0
            topPadding: 0
            anchors.leftMargin: 20
            anchors.verticalCenterOffset: 0
            font.family: "Roboto"
            background: Rectangle {
                color: "#ECEFF4"
                radius:3
            }

            selectByMouse: true
            selectedTextColor: "#ECEFF4"
            selectionColor: "#BF616A"
            placeholderTextColor: "#4C566A"



        }

        Rectangle {
            id: edit_project_lb_rt
            width: 50
            height: 25
            color: "#00000000"
            border.color: "#00000000"
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.leftMargin: 10
            anchors.topMargin: 10

            Label {
                id: edit_project_lb
                text: qsTr("Project")
                anchors.fill: parent
                font.pixelSize: 15
                verticalAlignment: Text.AlignVCenter
                font.family: "Roboto"
            }
        }

        Rectangle {
            id: edit_issue_lb_rt
            width: 50
            height: 25
            color: "#00000000"
            border.color: "#00000000"
            anchors.left: parent.left
            anchors.top: edit_project_lb_rt.bottom
            anchors.leftMargin: 10
            anchors.topMargin: 5
            Label {
                id: edit_issue_lb
                text: qsTr("Issue")
                anchors.fill: parent
                font.pixelSize: 15
                verticalAlignment: Text.AlignVCenter
                font.family: "Roboto"
            }
        }

        Rectangle {
            id: edit_task_lb_rt
            width: 50
            height: 25
            color: "#00000000"
            border.color: "#00000000"
            anchors.left: parent.left
            anchors.top: edit_issue_lb_rt.bottom
            anchors.leftMargin: 10
            anchors.topMargin: 5
            Label {
                id: edit_task_lb
                text: qsTr("Task")
                anchors.fill: parent
                font.pixelSize: 15
                verticalAlignment: Text.AlignVCenter
                font.family: "Roboto"
            }
        }

        TextField {
            id: issue_tl
            y: 10
            width: 200
            height: 25
            color: "#3b4252"
            anchors.verticalCenter: edit_issue_lb_rt.verticalCenter
            anchors.left: edit_issue_lb_rt.right
            font.pixelSize: 15
            padding: 0
            placeholderTextColor: "#4c566a"
            anchors.leftMargin: 20
            selectionColor: "#bf616a"
            font.family: "Roboto"
            selectedTextColor: "#eceff4"
            selectByMouse: true
            placeholderText: qsTr("Issue")
            background: Rectangle {
                color: "#eceff4"
                radius: 3
            }
            anchors.verticalCenterOffset: 1
        }

        TextField {
            id: task_tl
            y: 71
            width: 200
            height: 25
            color: "#3b4252"
            anchors.verticalCenter: edit_task_lb_rt.verticalCenter
            anchors.left: edit_task_lb_rt.right
            font.pixelSize: 15
            padding: 0
            anchors.leftMargin: 20
            placeholderTextColor: "#4c566a"
            selectionColor: "#bf616a"
            font.family: "Roboto"
            selectedTextColor: "#eceff4"
            selectByMouse: true
            placeholderText: qsTr("Task")
            background: Rectangle {
                color: "#eceff4"
                radius: 3
            }
            anchors.verticalCenterOffset: 0
        }

        Rectangle {
            id: edit_check_rt
            x: 288
            width: 80
            height: 25
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.rightMargin: 10
            anchors.topMargin: 10
            radius: 3
            color: "#A3BE8C"

            Image {
                id: check_im
                width: 20
                height: 20
                anchors.verticalCenter: parent.verticalCenter
                source: "../images/check.png"
                anchors.horizontalCenter: parent.horizontalCenter
                sourceSize.height: 24
                sourceSize.width: 24
                mirror: false
                fillMode: Image.PreserveAspectFit
            }

            MouseArea {
                id: edit_check_ma
                objectName: "menu_ma"
                anchors.fill: parent
                onClicked: {
                    backend.edit_check_ma_clicked(qsTr(project_tl.text), qsTr(issue_tl.text), qsTr(task_tl.text))
                    // Close the edit dialog
                    edit_container.visible = false
                }
            }
        }

        Rectangle {
            id: edit_close_rt
            x: 310
            width: 80
            height: 25
            color: "#BF616A"
            radius: 3
            anchors.right: parent.right
            anchors.top: edit_check_rt.bottom
            anchors.topMargin: 5
            anchors.rightMargin: 10

            Image {
                id: close_im
                x: -11
                y: 31
                width: 20
                height: 20
                anchors.verticalCenter: parent.verticalCenter
                source: "images/close.png"
                anchors.horizontalCenter: parent.horizontalCenter
                fillMode: Image.PreserveAspectFit
            }

            MouseArea {
                id: edit_close_ma
                objectName: "menu_ma"
                anchors.fill: parent
                onClicked: {
                    backend.edit_close_ma_clicked()
                    // Close the edit dialog
                    edit_container.visible = false
                }
            }
        }

    }

    ComboBox {
        id: comboBox
        x: 41
        y: 287
        width: 250
        height: 25
        font.pixelSize: 15
        flat: true
        editable: true
        font.family: "Roboto"
        



        background: Rectangle {

            radius: 4

            color : "white"
            height: comboBox.height
            width: comboBox.width
            smooth: true
            border.width: 1
            border.color: "white"


        }

                delegate: ItemDelegate {
            id:itemDelegate
            width: comboButton.width

            background:Rectangle{
                gradient: Gradient {
                    GradientStop {
                        position: 0.0
                        color: itemDelegate.down ? "white" : "blue"
                    }
                    GradientStop {
                        position: 1.0
                        color: itemDelegate.down ? "yellow" : "orange"
                    }
                }
            }

            contentItem: Text {
                text: modelData
                elide: Text.ElideRight

                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                font.pointSize: 11
                font.family: "Arial"
                color:  itemDelegate.down ? "black" : "white"
            }
            highlighted: comboButton.highlightedIndex === index

        }

        model: ListModel
        {
            id: cbItems
            ListElement { text: "Banana"}
            ListElement { text: "Apple" }
            ListElement { text: "Coconut"}
            ListElement { text: "Perro"}
            ListElement { text: "Gato"}
        }

        popup: Popup {
            y: comboBox.height
            width: comboBox.width - 5

            //implicitHeight: contentItem.implicitHeight -1
            padding: 1

            background: Rectangle {
                border.color: "black"
                radius: 2
                color : "white"
            }

            contentItem: ListView {
                //clip: true
                implicitHeight: contentHeight
                model: comboBox.popup.visible ? comboBox.delegateModel : null
                currentIndex: comboBox.highlightedIndex
                interactive: true

            }
        }


        }
    

}

/*##^##
Designer {
    D{i:0;formeditorColor:"#4c4e50";formeditorZoom:0.9}D{i:2;locked:true}
}
##^##*/
