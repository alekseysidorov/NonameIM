import QtQuick 1.1

Row {
    id: root;
    property bool on: false;
    property date lastUpdate: new Date()
    property Flickable flickableItem
    signal triggered

    function formatDate(date) {
        return Qt.formatDateTime(date, "dd.MM.yyyy hh:mm");
    }
    function __calculateY(flickableItem)
    {
        return -flickableItem.visibleArea.yPosition * Math.max(flickableItem.contentHeight, flickableItem.height)
    }

    onFlickableItemChanged: {
        root.anchors.left = flickableItem.left;
        root.anchors.leftMargin = 35;
    }

    height: 70;
    y: flickableItem ? __calculateY(flickableItem) : 0
    spacing: 12

    Image {
        id: iconUpdate;
        anchors.top: parent.top;
        source: "../images/ic_pull_arrow.png";

        Behavior on rotation {
            NumberAnimation {
                easing.type: Easing.InCirc;
            }
        }
    }

    Column {
        spacing: 6;
        anchors.verticalCenter: parent.verticalCenter;
        Text {
            id: textUpdate;
            text: qsTr("Pull down to refresh...");
            font.pixelSize: 20
            font.bold: true;
            color: "#505050";
        }
        Text {
            id: textDateUpdate;
            text:  qsTr("Last updated: ") + formatDate(lastUpdate);
            font.pixelSize: 18
            color: "#606060";
        }
    }

    //TODO roote with states
    onYChanged: {
        if(root.y > 110) {
            iconUpdate.rotation = 180
            on = true
            textUpdate.text = qsTr("Release to refresh...")
        } else {
            if (on) {
                lastUpdate = new Date()
                triggered()
            }
            iconUpdate.rotation = 0
            on = false
            textUpdate.text = qsTr("Pull down to refresh...")
        }
    }
}
