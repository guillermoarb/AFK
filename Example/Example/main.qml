import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Hello World")

    Label {
        id: label
        x: 109
        y: 165
        width: 344
        height: 161
        color: "#4fe7a1"
        text: qsTr("12:32")
        font.styleName: "Black"
        font.weight: Font.Normal
        font.bold: true
        font.family: "Roboto Black"
        font.pointSize: 100
    }
}
