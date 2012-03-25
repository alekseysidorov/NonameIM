import QtQuick 1.1
import com.nokia.meego 1.0

HeaderBar {
    id: root
    property alias text: label.text

    Label {
        id: label

        anchors.centerIn: parent;
        color: "white";
        text: qsTr("Header");
        font.pixelSize: 27;
        font.bold: true;
    }
}
