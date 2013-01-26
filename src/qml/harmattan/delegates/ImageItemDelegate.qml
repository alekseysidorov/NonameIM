import QtQuick 1.0
import "../components"

ItemDelegate {
    property alias imageSource: image.source
    property url imageUrl

    leftSideData: Avatar {
        id: image

        width: leftSideWidth
        height: width

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: mm
    }
}
