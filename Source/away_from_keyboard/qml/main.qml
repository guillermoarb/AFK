import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15

Window {
    id: window
    width: 600

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
        radius: 3
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
        height: 216
        color: "#ECEFF4"
        radius: 5
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        visible: true





        Rectangle {
            id: edit_issue_lb_rt
            width: 50
            height: 25
            color: "#00000000"
            border.color: "#00000000"
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.topMargin: 10
            anchors.leftMargin: 20
            Label {
                id: edit_issue_lb
                y: 5
                width: 45
                height: 15
                text: qsTr("Issue")
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                font.pixelSize: 15
                verticalAlignment: Text.AlignVCenter
                anchors.leftMargin: 0
                font.family: "Roboto"
            }
        }
        
        Rectangle {
            id: task_rt_tl
            width: 200
            height: 35
            color: "#D8DEE9"
            border.width: 0
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.leftMargin: 131
            anchors.topMargin: -270
            radius: 5
            border.color: "#00000000"

            TextField {
                id: task_tl
                y: 12
                width: 150

                height: 25

                placeholderText: qsTr("Task")
                color: "#3B4252"
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                font.pixelSize: 15
                anchors.leftMargin: 10
                padding: 0
                rightPadding: 0
                bottomPadding: 0
                topPadding: 0
                font.family: "Roboto"
                background: Rectangle {
                    color: "#D8DEE9"
                    radius:3
                }

                selectByMouse: true
                selectedTextColor: "#ECEFF4"
                selectionColor: "#BF616A"
                placeholderTextColor: "#4C566A"



            }
            Image {
                id: task_tl_arrow_down_image

                width: 16
                height: 16
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                source: "../images/arrow-down-sign-to-navigate.png"
                anchors.rightMargin: 5
                fillMode: Image.PreserveAspectFit

                MouseArea {
                    id: task_tl_arrow_down_ma
                    anchors.fill: parent
                    onClicked: {
                        task_cb_rt.visible = true
                        task_tl_arrow_up_image.visible = true
                        task_tl_arrow_down_image.visible = false
                    }
                }
            }

            Image {
                id: task_tl_arrow_up_image

                width: 16
                height: 16
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                source: "../images/navigate-up-arrow.png"
                anchors.rightMargin: 5
                fillMode: Image.PreserveAspectFit
                visible: false
                MouseArea {
                    id: task_tl_up_down_ma
                    anchors.fill: parent
                    onClicked: {
                        task_cb_rt.visible = false
                        task_tl_arrow_down_image.visible = true
                        task_tl_arrow_up_image.visible = false
                    }
                }
            }
        }



        Rectangle {
            id: edit_task_lb_rt
            width: 50
            height: 25
            color: "#00000000"
            border.color: "#00000000"
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.topMargin: 150
            anchors.leftMargin: 20
            Label {
                id: edit_task_lb
                text: qsTr("Task")
                anchors.fill: parent
                font.pixelSize: 15
                verticalAlignment: Text.AlignVCenter
                font.family: "Roboto"
            }
        }

        Rectangle {
            id: issue_cb_rt
            width: 200; height: 150
            anchors.left: issue_rt_tl.left
            anchors.top: issue_rt_tl.bottom
            anchors.leftMargin: 0
            anchors.topMargin: -5
            visible: false
            radius: 10


            ListModel {
                id: issue_cb_Model
                ListElement { name: "Alice" }
                ListElement { name: "Bob" }
                ListElement { name: "Harry" }
                ListElement { name: "Jane" }
                ListElement { name: "Karen" }
                ListElement { name: "Lionel" }
                ListElement { name: "Victor" }

            }

            Component {
                id: issue_cb_Delegate
                Text {
                    readonly property ListView __lv: ListView.view
                    width: parent.width
                    text: model.name;
                    color: "#4C566A"
                    font.pixelSize: 15
                    font.family: "Roboto"
                    MouseArea {
                        anchors.fill: parent
                        onClicked:
                        {
                            __lv.currentIndex = index
                            backend.issue_ma_option_clicked(model.name, model.index)
                            issue_tl.text = model.name
                            issue_cb_rt.visible = false
                            issue_tl_arrow_down_image.visible = true
                            issue_tl_arrow_up_image.visible = false
                        }
                    }

                }
            }

            Rectangle {
                border.color: "#D8DEE9"
                anchors.fill: parent
                color: "#D8DEE9"
                radius: 4
                //clip: true
                //--> slide
                ListView {
                    id: listView//--> hide
                    anchors.fill: parent
                    anchors.margins: 4
                    model: issue_cb_Model
                    delegate: issue_cb_Delegate
                    focus: true
                    clip: true
                    highlight: Rectangle {
                        color: "#81A1C1"
                        width: parent.width
                    }//<-- hide
                    preferredHighlightBegin: 0
                    preferredHighlightEnd: 150
                    highlightRangeMode: ListView.StrictlyEnforceRange

                }
                //<-- slide
            }
        }


        Rectangle {
            id: project_cb_rt
            width: 200; height: 150
            anchors.left: project_rt_tl.left
            anchors.top: project_rt_tl.bottom
            anchors.leftMargin: 0
            anchors.topMargin: -5
            visible: false
            radius: 10


            ListModel {
                id: project_cb_Model
                ListElement { name: "Alice" }
                ListElement { name: "Bob" }
                ListElement { name: "Harry" }
                ListElement { name: "Jane" }
                ListElement { name: "Karen" }
                ListElement { name: "Lionel" }
                ListElement { name: "Victor" }

            }

            Component {
                id: project_cb_Delegate
                Text {
                    readonly property ListView __lv: ListView.view
                    width: parent.width
                    text: model.name;
                    color: "#4C566A"
                    font.pixelSize: 15
                    font.family: "Roboto"
                    MouseArea {
                        anchors.fill: parent
                        onClicked:
                        {
                            __lv.currentIndex = index
                            backend.project_ma_option_clicked(model.name, model.index)
                            project_tl.text = model.name
                            project_cb_rt.visible = false
                            project_tl_arrow_down_image.visible = true
                            project_tl_arrow_up_image.visible = false
                        }
                    }

                }
            }

            Rectangle {
                border.color: "#D8DEE9"
                anchors.fill: parent
                color: "#D8DEE9"
                radius: 4
                //clip: true
                //--> slide
                ListView {
                    id: project_listView//--> hide
                    anchors.fill: parent
                    anchors.margins: 4
                    model: project_cb_Model
                    delegate: project_cb_Delegate
                    focus: true
                    clip: true
                    highlight: Rectangle {
                        color: "#81A1C1"
                        width: parent.width
                    }//<-- hide
                    preferredHighlightBegin: 0
                    preferredHighlightEnd: 150
                    highlightRangeMode: ListView.StrictlyEnforceRange

                }
                //<-- slide
            }
        }



        TextField {
            id: task_tl_old
            x: -19
            y: -155
            width: 200
            height: 25
            color: "#3b4252"
            font.pixelSize: 15
            padding: 0
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
        }

        Rectangle {
            id: edit_check_rt
            x: 241
            width: 80
            height: 25
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.rightMargin: 79
            anchors.topMargin: 376
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
                    backend.edit_check_ma_clicked(qsTr(issue_tl.text), qsTr(project_tl.text), qsTr(task_tl.text))
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
                anchors.rightMargin: -8
                anchors.bottomMargin: -61
                anchors.leftMargin: 8
                anchors.topMargin: 61
                onClicked: {
                    backend.edit_close_ma_clicked()
                    // Close the edit dialog
                    edit_container.visible = false
                }
            }
        }

        Rectangle {
            id: add_issue_rtbt
            y: 13
            width: 50
            height: 30
            color: "#8FBCBB"
            radius: 3
            anchors.verticalCenter: issue_rt_tl.verticalCenter
            anchors.left: issue_rt_tl.right
            anchors.leftMargin: 50
            Text {
                id: add_issue_rtbt_text
                text: qsTr("Add")
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 15
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                anchors.horizontalCenter: parent.horizontalCenter
                font.family: "Roboto"
                color: "#4C566A"
            }
        }

        Rectangle {
            id: project_rt_tl
            width: 200
            height: 35
            color: "#D8DEE9"
            border.width: 0
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.leftMargin: 15
            anchors.topMargin: 105
            radius: 5
            border.color: "#00000000"

            TextField {
                id: project_tl
                y: 12
                width: 150
                height: 25

                placeholderText: qsTr("Project")
                color: "#3B4252"
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                font.pixelSize: 15
                anchors.leftMargin: 10
                padding: 0
                rightPadding: 0
                bottomPadding: 0
                topPadding: 0
                font.family: "Roboto"
                background: Rectangle {
                    color: "#D8DEE9"
                    radius:3
                }

                selectByMouse: true
                selectedTextColor: "#ECEFF4"
                selectionColor: "#BF616A"
                placeholderTextColor: "#4C566A"



            }

            Image {
                id: project_tl_arrow_down_image

                width: 16
                height: 16
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                source: "../images/arrow-down-sign-to-navigate.png"
                anchors.rightMargin: 5
                fillMode: Image.PreserveAspectFit

                MouseArea {
                    id: project_tl_arrow_down_ma
                    anchors.fill: parent
                    onClicked: {
                        project_cb_rt.visible = true
                        project_tl_arrow_up_image.visible = true
                        project_tl_arrow_down_image.visible = false
                    }
                }
            }

            Image {
                id: project_tl_arrow_up_image

                width: 16
                height: 16
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                source: "../images/navigate-up-arrow.png"
                anchors.rightMargin: 5
                fillMode: Image.PreserveAspectFit
                visible: false
                MouseArea {
                    id: project_tl_up_down_ma
                    anchors.fill: parent
                    onClicked: {
                        project_cb_rt.visible = false
                        project_tl_arrow_down_image.visible = true
                        project_tl_arrow_up_image.visible = false
                    }
                }
            }
        }



        Rectangle {
            id: edit_project_lb_rt
            width: 50
            height: 25
            color: "#00000000"
            border.color: "#00000000"
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.topMargin: 80
            anchors.leftMargin: 20

            Label {
                id: edit_project_lb
                text: qsTr("Project")
                anchors.fill: parent
                font.pixelSize: 15
                verticalAlignment: Text.AlignVCenter
                font.bold: false
                font.family: "Roboto"
            }
        }

        Rectangle {
            id: issue_rt_tl
            width: 200
            height: 35
            color: "#D8DEE9"
            border.width: 0
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.leftMargin: 15
            anchors.topMargin: 35
            radius: 5
            border.color: "#00000000"

            TextField {
                id: issue_tl
                y: 12
                width: 150

                height: 25

                placeholderText: qsTr("Issue")
                color: "#3B4252"
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                font.pixelSize: 15
                anchors.leftMargin: 10
                padding: 0
                rightPadding: 0
                bottomPadding: 0
                topPadding: 0
                font.family: "Roboto"
                background: Rectangle {
                    color: "#D8DEE9"
                    radius:3
                }

                selectByMouse: true
                selectedTextColor: "#ECEFF4"
                selectionColor: "#BF616A"
                placeholderTextColor: "#4C566A"



            }
            Image {
                id: issue_tl_arrow_down_image

                width: 16
                height: 16
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                source: "../images/arrow-down-sign-to-navigate.png"
                anchors.rightMargin: 5
                fillMode: Image.PreserveAspectFit

                MouseArea {
                    id: issue_tl_arrow_down_ma
                    anchors.fill: parent
                    onClicked: {
                        issue_cb_rt.visible = true
                        issue_tl_arrow_up_image.visible = true
                        issue_tl_arrow_down_image.visible = false

                        //Hide things behind
                        edit_project_lb_rt.visible = false
                        project_rt_tl.visible = false
                    }
                }
            }

            Image {
                id: issue_tl_arrow_up_image

                width: 16
                height: 16
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                source: "../images/navigate-up-arrow.png"
                anchors.rightMargin: 5
                fillMode: Image.PreserveAspectFit
                visible: false
                MouseArea {
                    id: issue_tl_up_down_ma
                    anchors.fill: parent
                    onClicked: {
                        issue_cb_rt.visible = false
                        issue_tl_arrow_down_image.visible = true
                        issue_tl_arrow_up_image.visible = false

                        //Unhide things behind
                        edit_project_lb_rt.visible = true
                        project_rt_tl.visible = true

                    }
                }
            }
        }
    }




    

    Rectangle {
        x: 68
        y: 726
        width: 200;
        height: 150

        ListModel {
            id: nameModel
            ListElement { name: "Alice" }
            ListElement { name: "Bob" }
            ListElement { name: "Harry" }
            ListElement { name: "Jane" }
            ListElement { name: "Karen" }
            ListElement { name: "Lionel" }
            ListElement { name: "Victor" }

        }

        Component {
            id: nameDelegate
            Text {
                readonly property ListView __lv: ListView.view
                width: parent.width
                text: model.name;
                color: "#3B4252"
                font.pixelSize: 15
                font.family: "Roboto"
                MouseArea {
                    anchors.fill: parent
                    onClicked:
                    {
                        __lv.currentIndex = index
                        backend.issue_ma_option_clicked(model.name, model.index)
                        textField.text = model.name
                    }
                }

            }
        }

        Rectangle {
            border.color: "black"
            anchors.fill: parent
            color: "#ECEFF4"
            //clip: true
            //--> slide
            ListView {
                id: issue_cb_listView//--> hide
                anchors.fill: parent
                anchors.margins: 4
                model: nameModel
                delegate: nameDelegate
                focus: true
                clip: true
                highlight: Rectangle {
                    color: "#D8DEE9"
                    width: parent.width
                }//<-- hide
                preferredHighlightBegin: 0
                preferredHighlightEnd: 150
                highlightRangeMode: ListView.StrictlyEnforceRange

            }
            //<-- slide
        }
    }

    TextField {
        id: textField
        x: 32
        y: 656
        width: 194
        height: 40
        placeholderText: qsTr("Text Field")
    }

    Rectangle {
        id: rectangle
        x: 107
        y: 936
        width: 85
        height: 48
        color: "#ffffff"

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            onClicked: {
                nameModel.append({"name": textField.text})
            }
        }
    }


}

/*##^##
Designer {
    D{i:0;formeditorColor:"#4c4e50"}D{i:2;locked:true}D{i:25}D{i:34;locked:true}D{i:66}
D{i:69}D{i:72}D{i:81}D{i:90;locked:true}D{i:105;locked:true}D{i:106;locked:true}
}
##^##*/
