import QtQuick 1.1
import com.nokia.meego 1.0

Row {
    property alias running: updIndicator.running
    property alias text: textUpdate.text

    height: 70
    anchors.left: parent.left
    anchors.leftMargin: 35

    spacing: 30

    BusyIndicator {
        id: updIndicator
        anchors.verticalCenter: parent.verticalCenter
        platformStyle: BusyIndicatorStyle {
            size: "medium"
        }
        running: isNextLoad
    }

    Text {
        id: textUpdate
        anchors.verticalCenter: parent.verticalCenter
        text: qsTr("Loading...")
        font.pixelSize: 20
        font.bold: true
        color: "#505050"
    }
}

