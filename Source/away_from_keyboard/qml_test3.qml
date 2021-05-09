/****************************************************************************
**
** Copyright (C) 2016 The Qt Company Ltd.
** Contact: http://www.qt.io/licensing/
**
** This file is part of the Qt for Python examples of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** You may use this file under the terms of the BSD license as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of The Qt Company Ltd nor the names of its
**     contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/



//More info https://wiki.qt.io/Qt_for_Python/Connecting_QML_Signals

import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: page

    function updateRotater() {
        rotater.angle = rotater.angle + 45
    }

    function updateTime(text) {
        activity_timer_lb.text = text
    }

    width: 500; height: 200
    color: "lightgray"

    Rectangle {
        id: rotater
        property real angle : 0
        x: 240
        width: 100; height: 10
        color: "black"
        y: 95

        transform: Rotation {
            origin.x: 10; origin.y: 5
            angle: rotater.angle
            Behavior on angle {
                SpringAnimation {
                    spring: 1.4
                    damping: .05
                }
            }
        }
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
        
        MouseArea {
            id: labelMouseArea
            objectName: "labelMouseArea"
            anchors.fill: parent
            onClicked: {
                // once the "con" context has been declared,
                // slots can be called like functions
                con.outputInt(activity_timer_lb.text)

            }
        }


    }
}