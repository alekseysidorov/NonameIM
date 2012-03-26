import QtQuick 1.1

Row {
    id: update;
    property bool on: false;
    property date lastUpdate: new Date()
    signal triggered

    function formatDate(date) {
        return Qt.formatDateTime(date, "dd.MM.yyyy hh:mm");
    }

    height: 70;

    Image {
        id: iconUpdate;
        anchors.top: parent.top;
        source: "images/ic_pull_arrow.png";

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

    //TODO rewrite with states
    onYChanged: {
        if(update.y > 110){
            iconUpdate.rotation = 180;
            on = true;
            textUpdate.text = qsTr("Release to refresh...");
        } else {
            if (on) {
                lastUpdate = new Date();
                triggered();
            }
            iconUpdate.rotation = 0;
            on = false;
            textUpdate.text = qsTr("Pull down to refresh...");
        }
    }
}
