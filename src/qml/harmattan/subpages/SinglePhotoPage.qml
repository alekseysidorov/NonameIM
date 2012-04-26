import QtQuick 1.1
import com.nokia.meego 1.0
import "../ios" as Ios

Page {
    id: page
    property alias source: image.source

    Rectangle {
        anchors.fill: parent
        color: "black"

        Image {
            id: image
            anchors.fill: parent
            fillMode: Image.PreserveAspectFit
        }

        Ios.BusyIndicator {
            id: busyIndicator
            platformStyle: BusyIndicatorStyle {
                size: "large"
                inverted: true
            }
            anchors.centerIn: parent
            running: image.status != Image.Ready
            visible: image.status != Image.Ready
        }

        MouseArea {
            anchors.fill: parent
            onClicked: pageStack.pop()
        }
    }
}
