// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import "../components"

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

    ListView.onRemove: SequentialAnimation {
        PropertyAction { target: root; property: "ListView.delayRemove"; value: true }
        NumberAnimation { target: root; property: "scale"; to: 0; duration: 300; easing.type: Easing.InOutQuad }
        PropertyAction { target: root; property: "ListView.delayRemove"; value: false }
    }

    ListView.onAdd: ParallelAnimation {
        NumberAnimation { target: root; property: "opacity"; from: 0; to: 1; duration: 600; easing.type: Easing.InOutQuad }
        NumberAnimation { target: root; property: "scale"; from: 0; to: 1; duration: 600; easing.type: Easing.InOutQuad }
    }

    width: parent ? parent.width : 600
    height: getMinHeight()

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
        item.anchors.left = avatar.right
        item.anchors.leftMargin = 12
        item.anchors.right = arrow.left
    }
}
