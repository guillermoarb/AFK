import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15

Window {
    id: window
    width: 400

    height: 100
    visible: true
    color: "#00000000"
    title: qsTr("AFK")
    flags: Qt.Window | Qt.FramelessWindowHint


    onActiveFocusItemChanged: print(activeFocusItem)



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

        function onIssueComboBoxAddItem(cb_item){
            issue_cb_Model.append({ name: cb_item})
        }

        function onTaskComboBoxAddItem(cb_item){
            task_cb_Model.append({ name: cb_item})
        }

        function onProjectComboBoxAddItem(cb_item){
            project_cb_Model.append({ name: cb_item})
        }

        function onTaskComboBoxClear(){
            task_cb_Model.clear()
        }

        function onProjectComboBoxClear(){
            project_cb_Model.clear()
        }

        function onIssueComboBoxClear(){
            issue_cb_Model.clear()
        }

        function onEditDialogValidation(error){
            if (error === "None"){
                // Close the edit dialog
                edit_container.visible = false
                edit_container.focus = false
                // Open / focus main app container
                app_container.focus = true
            }
        }


    }

    Rectangle {
        id: app_container
        x: 0
        width: 400
        height: 100
        visible: true
        radius: 5
        color: "#ECEFF4"
        border.color: "#00000000"
        border.width: 1
        anchors.top: parent.top
        anchors.topMargin: 0
        anchors.horizontalCenter: parent.horizontalCenter

        // Key events in app_container

        focus: true
        Keys.onPressed: {
            // Open edit window
            if ((event.modifiers & Qt.ControlModifier) && (event.key === Qt.Key_E)){
                edit_container.visible = true
                issue_tl.focus = true
                window.height = 470
                //window.setY(470)
                backend.edit_dialog_opened()
            }
            // Save all
            if ((event.modifiers & Qt.ControlModifier) && (event.key === Qt.Key_S)){
                backend.save_all()
            }

            // Quit app
            if ((event.modifiers & Qt.ControlModifier) && (event.key === Qt.Key_Q)){
                backend.quit_app()
            }

            // Open JSON report
            if ((event.modifiers & Qt.ControlModifier) && (event.key === Qt.Key_J)){
                backend.open_json_report_file()
            }

            // Generate and open Markdown report
            if ((event.modifiers & Qt.ControlModifier) && (event.key === Qt.Key_R)){
                backend.generate_markdown_week_report()
            }

            // Pause time counter (One second loop task)
            if ((event.modifiers & Qt.ControlModifier) && (event.key === Qt.Key_P)){
                //Same action as clicking the main timer label/text
                backend.day_timer_ma_clicked(day_timer_lb.text)
            }

        }




        Rectangle {
            id: day_timer_rt
            width: 129
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
                font.family: "Moon"
                color: "#2e3440"
                text: qsTr("01:23")
                anchors.fill: parent
                font.pixelSize: 50
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                topPadding: 4
                clip: true
                padding: 0
                styleColor: "#b62323"
                
                
                MouseArea {
                    id: day_timer_ma
                    objectName: "day_timer_ma"
                    anchors.fill: parent
                    onClicked: {
                        backend.day_timer_ma_clicked(day_timer_lb.text)
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
                color: "#ECEFF4"

                Label {
                    id: status_lb
                    text: qsTr("")
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
        width: 338
        height: 351
        color: "#ECEFF4"
        radius: 5
        anchors.left: parent.left
        anchors.top: app_container.bottom
        anchors.topMargin: 10
        anchors.leftMargin: 0
        visible: true

        Keys.onPressed: {
            // Close edit dialog with ESC key without a update request
            if(event.key === Qt.Key_Escape){
                // Close the edit dialog
                edit_container.visible = false
                edit_container.focus = false
                // Open / focus main app container
                app_container.focus = true
                window.height = 100
            }

            // Perform a reques to update the time traking information
            if((event.modifiers & Qt.ControlModifier) && (event.key === Qt.Key_U)){
                window.height = 100
                app_container.focus = true
                // Send info to backend for validation, backend will close the dialog if the update is right
                backend.edit_update_ma_clicked(qsTr(issue_tl.text), qsTr(project_tl.text), qsTr(task_tl.text))
            }
        }

        // Keys.onEscapePressed:{
        //     // Close the edit dialog
        //     edit_container.visible = false
        //     edit_container.focus = false
        //     // Open / focus main app container
        //     app_container.focus = true
        // }


        Rectangle {
            id: issue_cb_rt
            height: 150
            anchors.left: issue_rt_tl.left
            anchors.right: issue_rt_tl.right
            anchors.top: issue_rt_tl.bottom
            anchors.rightMargin: 0
            anchors.leftMargin: 0
            anchors.topMargin: -5
            visible: false
            radius: 10
            z:3


            ListModel {
                id: issue_cb_Model
            }

            Component {
                id: issue_cb_Delegate
                Text {
                    readonly property ListView __lv: ListView.view
                    width: parent.width
                    text: model.name
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
                ListView {
                    id: issue_listView
                    anchors.fill: parent
                    anchors.margins: 4
                    model: issue_cb_Model
                    delegate: issue_cb_Delegate
                    //focus: true
                    //clip: true
                    highlight: Rectangle {
                        color: "#81A1C1"
                        width: parent.width
                    }

                    preferredHighlightBegin: 0
                    preferredHighlightEnd: 150
                    highlightRangeMode: ListView.StrictlyEnforceRange

                    Keys.onDownPressed: issue_listView.incrementCurrentIndex()
                    Keys.onUpPressed: issue_listView.decrementCurrentIndex()

                    Keys.onReturnPressed: {
                            backend.issue_ma_option_clicked(currentItem.text, issue_listView.currentIndex)
                            issue_tl.text = currentItem.text
                            issue_cb_rt.visible = false
                            issue_tl_arrow_down_image.visible = true
                            issue_tl_arrow_up_image.visible = false
                            // Focus next text line item
                            //edit_container.focus = true
                            project_tl.focus = true
                    }

                    Keys.onEscapePressed:{
                        // Hide the combobox
                        issue_cb_rt.visible = false
                        issue_tl_arrow_down_image.visible = true
                        issue_tl_arrow_up_image.visible = false
                        edit_container.focus = true
                        edit_container.focus = true
                    }

                }
            }
        }


        Rectangle {
            id: project_cb_rt
            height: 150
            z:2
            anchors.left: project_rt_tl.left
            anchors.right: project_rt_tl.right
            anchors.top: project_rt_tl.bottom
            anchors.rightMargin: 0
            anchors.leftMargin: 0
            anchors.topMargin: -5
            visible: false
            radius: 10


            ListModel {
                id: project_cb_Model
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
                ListView {
                    id: project_cb_listView
                    anchors.fill: parent
                    anchors.margins: 4
                    model: project_cb_Model
                    delegate: project_cb_Delegate
                    focus: true
                    clip: true
                    highlight: Rectangle {
                        color: "#81A1C1"
                        width: parent.width
                    }
                    preferredHighlightBegin: 0
                    preferredHighlightEnd: 150
                    highlightRangeMode: ListView.StrictlyEnforceRange

                    Keys.onDownPressed: project_cb_listView.incrementCurrentIndex()
                    Keys.onUpPressed: project_cb_listView.decrementCurrentIndex()

                    Keys.onReturnPressed: {
                            backend.project_ma_option_clicked(currentItem.text, project_cb_listView.currentIndex)
                            project_tl.text = currentItem.text
                            project_cb_rt.visible = false
                            project_tl_arrow_down_image.visible = true
                            project_tl_arrow_up_image.visible = false
                            // Focus next text line edit item
                            //edit_container.focus = true
                            task_tl.focus = true
                    }

                    Keys.onEscapePressed:{
                        // Hide the combobox
                        project_cb_rt.visible = false
                        project_tl_arrow_down_image.visible = true
                        project_tl_arrow_up_image.visible = false
                        edit_container.focus = true
                    }


                }
            }
        }

        Rectangle {
            id: task_cb_rt
            height: 150
            anchors.left: task_rt_tl.left
            anchors.right: task_rt_tl.right
            anchors.top: task_rt_tl.bottom
            anchors.rightMargin: 0
            anchors.leftMargin: 0
            anchors.topMargin: -5
            visible: false
            radius: 10
            z:1


            ListModel {
                id: task_cb_Model
            }

            Component {
                id: task_cb_Delegate
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
                            backend.task_ma_option_clicked(model.name, model.index)
                            task_tl.text = model.name
                            task_cb_rt.visible = false
                            task_tl_arrow_down_image.visible = true
                            task_tl_arrow_up_image.visible = false
                        }
                    }

                }
            }

            Rectangle {
                border.color: "#D8DEE9"
                anchors.fill: parent
                color: "#D8DEE9"
                radius: 4
                ListView {
                    id: task_cb_listView
                    anchors.fill: parent
                    anchors.margins: 4
                    model: task_cb_Model
                    delegate: task_cb_Delegate
                    focus: true
                    clip: true
                    highlight: Rectangle {
                        color: "#81A1C1"
                        width: parent.width
                    }
                    preferredHighlightBegin: 0
                    preferredHighlightEnd: 150
                    highlightRangeMode: ListView.StrictlyEnforceRange

                    Keys.onDownPressed: task_cb_listView.incrementCurrentIndex()
                    Keys.onUpPressed: task_cb_listView.decrementCurrentIndex()

                    Keys.onReturnPressed: {
                            backend.task_ma_option_clicked(currentItem.text, task_cb_listView.currentIndex)
                            task_tl.text = currentItem.text
                            task_cb_rt.visible = false
                            task_tl_arrow_down_image.visible = true
                            task_tl_arrow_up_image.visible = false
                            // Focus next edit
                            // None
                    }

                    Keys.onEscapePressed:{
                        // Hide the combobox
                        task_cb_rt.visible = false
                        task_tl_arrow_down_image.visible = true
                        task_tl_arrow_up_image.visible = false
                    }

                }
            }
        }



        Rectangle {
            id: update_edit_rt_bt
            y: 365
            z: 0
            width: 108
            height: 30
            color: "#8FBCBB"
            radius: 3
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 20
            anchors.leftMargin: 20
            Text {
                id: update_edit_rt_bt_text
                text: qsTr("Update")
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 15
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                anchors.horizontalCenter: parent.horizontalCenter
                font.family: "Roboto"
                color: "#2E3440"
            }

            MouseArea {
                id: update_edit_ma
                anchors.fill: parent
                hoverEnabled: true

                onEntered: {
                    update_edit_rt_bt.color = "#80a9a8"
                }

                onExited: {
                    update_edit_rt_bt.color = "#8FBCBB"

                }

                onClicked: {
                    update_edit_rt_bt.color = "#8FBCBB"
                    window.height = 100
                    // Send info to backend for validation, backend will close the dialog if the update is right
                    backend.edit_update_ma_clicked(qsTr(issue_tl.text), qsTr(project_tl.text), qsTr(task_tl.text))
                    app_container.focus = true

                }
            }


        }

        Rectangle {
            id: cancel_edit_rt_bt
            y: 365
            z: 0
            width: 108
            height: 30
            color: "#BF616A"
            radius: 3
            anchors.verticalCenter: update_edit_rt_bt.verticalCenter
            anchors.left: update_edit_rt_bt.right
            anchors.leftMargin: 20
            Text {
                id: cancel_edit_rt_bt_text
                text: qsTr("Cancel")
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 15
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                anchors.horizontalCenter: parent.horizontalCenter
                font.family: "Roboto"
                color: "#2E3440"
            }

            MouseArea {
                id: cancel_edit_ma
                anchors.fill: parent
                hoverEnabled: true

                onEntered: {
                    cancel_edit_rt_bt.color = "#ab575f"
                }

                onExited: {
                    cancel_edit_rt_bt.color = "#BF616A"

                }

                onClicked: {
                    cancel_edit_rt_bt.color = "#BF616A"
                    backend.edit_close_ma_clicked()
                    // Close the edit dialog
                    edit_container.visible = false
                    edit_container.focus = false
                    // Open / focus main container
                    app_container.focus = true
                    window.height = 100


                }
            }

        }


            Rectangle {
            id: issue_rt_tl
            height: 35
            color: "#D8DEE9"
            border.width: 3
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.rightMargin: 20
            anchors.leftMargin: 20
            anchors.topMargin: 85
            radius: 5
            border.color: "#00000000"
            z:3

            TextField {
                id: issue_tl
                y: 12
                width: 260

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

                onEditingFinished: {
                    backend.issue_te_editingFinished(issue_tl.text)
                }

                focus: true
                Keys.onPressed: {
                    if (event.key === Qt.Key_Return){
                        issue_cb_rt.visible = false
                    }
                    if (event.key === Qt.Key_Down){
                        issue_cb_rt.visible = true
                        issue_listView.focus = true
                    }
                }

                // Highliight the item if the text line has focus
                onActiveFocusChanged: {
                    if (issue_tl.activeFocus) {
                        issue_rt_tl.border.color = "#88C0D0"
                    }
                    else{
                        issue_rt_tl.border.color = "#00000000"
                    }
                }


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
                        issue_listView.focus = true

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


                    }
                }
            }
        }

        Rectangle {
            id: edit_issue_lb_rt
            width: 50
            height: 25
            color: "#00000000"
            border.color: "#00000000"
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.topMargin: 60
            anchors.leftMargin: 25
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
                font.styleName: "Regular"
                anchors.leftMargin: 0
                font.family: "Roboto"
            }
        }

        Rectangle {
            id: project_rt_tl
            height: 35
            color: "#D8DEE9"
            border.width: 3
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.rightMargin: 20
            anchors.leftMargin: 20
            anchors.topMargin: 155
            radius: 5
            border.color: "#00000000"

            TextField {
                id: project_tl
                y: 12
                width: 260

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

                onEditingFinished: {
                    backend.project_te_editingFinished(project_tl.text)
                }

                focus: true
                Keys.onPressed: {
                    if (event.key === Qt.Key_Return){
                        project_cb_rt.visible = false
                        project_cb_listView.focus = true
                    }
                        if (event.key === Qt.Key_Down){
                        project_cb_rt.visible = true
                        project_cb_listView.focus = true
                    }
                }

                // Highliight the item if the text line has focus
                onActiveFocusChanged: {
                    if (project_tl.activeFocus) {
                        project_rt_tl.border.color = "#88C0D0"
                    }
                    else{
                        project_rt_tl.border.color = "#00000000"
                    }
                }


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
                        project_cb_listView.focus = true
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
            anchors.topMargin: 130
            anchors.leftMargin: 25

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
            id: task_rt_tl
            height: 35
            color: "#D8DEE9"
            border.width: 3
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.rightMargin: 20
            anchors.topMargin: 230
            anchors.leftMargin: 20
            radius: 5
            border.color: "#00000000"

            TextField {
                id: task_tl
                y: 12
                width: 260

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

                onEditingFinished: {
                    backend.task_te_editingFinished(task_tl.text)
                }

                focus: true
                Keys.onPressed: {
                    if (event.key === Qt.Key_Return){
                        task_cb_rt.visible = false
                        task_cb_listView.focus = true
                    }
                        if (event.key === Qt.Key_Down){
                        task_cb_rt.visible = true
                        task_cb_listView.focus = true
                    }
                }

                // Highliight the item if the text line has focus
                onActiveFocusChanged: {
                    if (task_tl.activeFocus) {
                        task_rt_tl.border.color = "#88C0D0"
                    }
                    else{
                        task_rt_tl.border.color = "#00000000"
                    }
                }


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
                        task_cb_listView.focus = true
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
            anchors.topMargin: 205
            anchors.leftMargin: 25
            Label {
                id: edit_task_lb
                text: qsTr("Task")
                anchors.fill: parent
                font.pixelSize: 15
                verticalAlignment: Text.AlignVCenter
                font.family: "Roboto"
            }
        }



        Text {
            id: text1
            y: 14
            color: "#2e3440"
            text: qsTr("Update information")
            anchors.left: parent.left
            font.pixelSize: 30
            anchors.leftMargin: 25
            font.family: "Roboto Black"
        }
    }




    







    Rectangle {
        id: rectangle1
        x: 505
        y: 684
        width: 200
        height: 200
        color: "#eceff4"
        radius: 5
        visible: false
        
        Label {
            id: label
            x: 5
            y: 21
            width: 162
            height: 31
            text: qsTr("Edit  ctrl + e")
            font.pixelSize: 15
            font.family: "Roboto"
        }
    }


}

/*##^##
Designer {
    D{i:0;formeditorColor:"#4c4e50"}D{i:33;locked:true}
}
##^##*/
