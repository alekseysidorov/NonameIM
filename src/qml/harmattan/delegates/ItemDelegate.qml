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

        spacing:  0.5 * mm

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

    Image {
        id: arrow
        opacity: 0.5
        width: showArrow ? implicitWidth : 0
        visible: showArrow

        anchors {
            verticalCenter: parent.verticalCenter
            right: parent.right
            rightMargin:  1 * mm
        }

        source: "image://theme/icon-m-common-drilldown-arrow" + (theme.inverted ? "-inverse" : "")

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

        enabled: clickable

        onClicked: root.clicked()
    }
}
