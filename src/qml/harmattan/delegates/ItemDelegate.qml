import QtQuick 1.1

Rectangle {
    id: root

    property bool clickable: false
    property bool alternate: true
    property bool showArrow: clickable
    property alias leftSideData: leftSide.data
    property int leftSideWidth: 8 * mm
    property alias data: container.data

    signal clicked;

    width: parent ? parent.width : implicitWidth
    color: (alternate && index % 2) ? systemPalette.alternateBase : "transparent"

    implicitWidth: 200
    implicitHeight: Math.max(8 * mm, container.last.height + container.last.y, leftSide.childrenRect.height) + 2 * mm

    Item {
        id: leftSide

        width: leftSideWidth

        anchors {
            top: parent.top
            bottom: parent.bottom
            left: parent.left
            leftMargin: mm
        }
    }

    Column {
        id: container

        property Item last;

        onChildrenChanged: {
            last = children[children.length - 1];
        }

        spacing:  mm

        anchors {
            top: parent.top
            topMargin: mm
            bottom: parent.bottom
            bottomMargin:  mm
            left: leftSide.right
            leftMargin: mm
            right: arrow.left
            rightMargin:  mm
        }
    }

    Text {
        id: arrow

        width: showArrow ? implicitWidth : 0
        visible: showArrow
        text: qsTr("❭")
        color: systemPalette.shadow
        font.bold: true
        font.pointSize: 11

        anchors {
            top: parent.top
            bottom: parent.bottom
            right: parent.right
            rightMargin:  6 * mm
        }

        verticalAlignment: Text.AlignVCenter
    }

    Rectangle {
        id: hr
        width: parent.width
        height: 1
        anchors.bottom: parent.bottom
        color: systemPalette.window
    }

    MouseArea {
        anchors.fill: parent

        onClicked: root.clicked()
    }
}
