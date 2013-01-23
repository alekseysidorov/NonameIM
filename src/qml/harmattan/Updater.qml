import QtQuick 1.0

Item {
    id: updater

    property bool canUpdate: client.online
    property bool busy: false
    property int count: 25
    property int offset: flickableItem.count

    property ListView flickableItem
    property Component header: Item {
            width: parent.width
            height: visible ? childrenRect.height + 2 * mm : 0
            Text {
                anchors.centerIn: parent
                text: qsTr("Loading...")
                visible: updater.busy
                color: systemPalette.dark
            }
        }
    property Component footer: Item {
        width: parent.width
        height: visible ? childrenRect.height + 2 * mm : 0
        Text {
            anchors.centerIn: parent
            text: qsTr("Loading...")
            visible: updater.busy
            color: systemPalette.dark
        }
    }

    function update(count, offset) {
        console.log("Updater: please implement function with signature update(count, offset)")
    }

    function truncate(count) {
        console.log("Updater: please implement function with signature truncate(count)")
    }

    onFlickableItemChanged: {
        flickableItem.header = header;
        flickableItem.footer = footer;
    }

    Connections {
        target: flickableItem

        onAtYEndChanged: {
            if (flickableItem.atYEnd && canUpdate) {
                var reply = update(count, offset);
                if (reply) {
                    busy = true;
                    reply.resultReady.connect(function() {
                        busy = false;
                    });
                }
            }
        }

        onAtYBeginningChanged: {
            if (flickableItem.atYBeginning && canUpdate) {
                var reply = update(count, 0);
                if (reply) {
                    busy = true;
                    reply.resultReady.connect(function() {
                        busy = false;
                    });
                }
            }
        }
    }
}
