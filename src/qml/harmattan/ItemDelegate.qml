// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Item {
    id: root
    property alias imageSize: image.width
    property alias imageSource: image.source
    property Item item: null
    property bool clickable: true
    property bool horizontalLine: true

    signal clicked

    width: parent ? parent.width : 600
    height: 90

    Rectangle {
        id: imageBorder;
        width: image.width + 2
        height: image.height + 2
        anchors.left: parent.left
        anchors.leftMargin: 12
        anchors.verticalCenter: parent.verticalCenter;
        color: image.sourceSize ? "black" : "transparent";
        Behavior on scale {
            NumberAnimation {
                easing.type: Easing.InOutQuad;
            }
        }
        Image {
            id: image;
            anchors.centerIn: parent;
            smooth: true;
            source: photo;
            width: 64
            height: width
        }
    }

    Image {
        id: arrow;
        visible: clickable
        opacity: 0.5;
        source: "image://theme/icon-m-common-drilldown-arrow" + (theme.inverted ? "-inverse" : "")
        anchors.right: parent.right;
        anchors.rightMargin: visible ? 12 : 0;
        anchors.verticalCenter: parent.verticalCenter;
    }

    MouseArea {
        enabled: clickable
        anchors.fill: parent
        onClicked: root.clicked();
    }


    Rectangle {
        id: hr

        visible: horizontalLine
        anchors.bottom: root.bottom
        anchors.bottomMargin: 1
        width:  parent.width;
        height: 1;
        color: "#c0c0c0";
    }

    onItemChanged: {
        item.anchors.top = root.top
        item.anchors.bottom = hr.top
        item.anchors.left = imageBorder.right
        item.anchors.leftMargin = 12
        item.anchors.right = arrow.left
    }
}
