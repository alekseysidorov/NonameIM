import QtQuick 1.0

ItemDelegate {
    property alias imageSource: image.source
    property url imageUrl

    leftSideData: Image {
        id: image

        width: leftSideWidth
        height: width

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: mm
    }
}
