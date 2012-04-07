// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Item {
    id: root
    property alias imageSize: avatar.width
    property alias imageSource: avatar.source
    property Item item: null
    property bool clickable: true
    property bool horizontalLine: true
    property int __spacing: 6

    function getMinHeight() {
        var avatarHeight = avatar.y + avatar.height + __spacing;
        var itemHeight = item ? item.y + item.height + __spacing : 0
        return Math.max(avatarHeight, itemHeight)
    }

    signal clicked

    width: parent ? parent.width : 600
    height: getMinHeight()
    //scale: 10
    //opacity: 0

    Component.onCompleted: {
        scale = 1
        opacity = 1
    }

    Behavior on scale {
        NumberAnimation {
            easing.type: Easing.InOutQuad;
            duration: 600
        }
    }

    Behavior on opacity {
        NumberAnimation {
            easing.type: Easing.InOutQuad;
            duration: 600
        }
    }

    Avatar {
        id: avatar
        anchors.left: parent.left
        anchors.leftMargin: 12
        anchors.top: item ? item.top : parent.top
        anchors.topMargin: item ? __spacing/2 : 0
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
        width:  parent.width;
        height: 1;
        color: "#c0c0c0";
    }

    onItemChanged: {
        item.anchors.top = root.top
        item.anchors.topMargin = 12
        //item.anchors.bottom = hr.top
        item.anchors.left = avatar.right
        item.anchors.leftMargin = 12
        item.anchors.right = arrow.left
    }
}
