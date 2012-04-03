import QtQuick 1.1
import com.nokia.meego 1.0

BorderImage {
    id: root;
    property alias text: label.text
    signal clicked

    width: 140;
    anchors.left: parent.left;
    anchors.leftMargin: 10;
    anchors.verticalCenter: parent.verticalCenter;
    source: "images/btn_back.sci";

    Text {
        id: label
        anchors.centerIn: parent;
        color: "white";
        text: qsTr("Back");
        font.pixelSize: 21;
        font.bold: true;
    }
    MouseArea{
        anchors.fill: parent;
        onClicked: root.clicked()
    }
}
