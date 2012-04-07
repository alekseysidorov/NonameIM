// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Rectangle {
    id: root;
    property alias source: avatar.source
    signal clicked

    width: 64
    height: 64
    color: avatar.sourceSize ? "black" : "transparent";

    Image {
        id: avatar
        anchors.centerIn: parent
        source: "images/user.png"
        width: root.width - 2
        height: root.height -2
        smooth: true
        asynchronous: true
    }

    MouseArea {
        anchors.fill: parent
        onClicked: root.clicked()
    }
}
