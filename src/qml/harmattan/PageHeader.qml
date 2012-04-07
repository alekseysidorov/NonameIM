import QtQuick 1.1
import com.nokia.meego 1.0

PageHeaderBar {
    id: root
    property alias text: label.text
    property bool backButton: false
    signal backButtonClicked

    state: "common"

    Label {
        id: label

        color: "white";
        text: qsTr("Header");
        font.pixelSize: 27;
        font.bold: true;
        z: 2
        elide: Text.ElideMiddle
    }
    Label {
        id: shadow
        property int offset: 1

        color: "black"
        text: label.text
        z: label.z - 1
        x: label.x + offset
        y: label.y + offset
        opacity: 0.7
        font.pixelSize: label.font.pixelSize
        font.bold: label.font.bold
    }

    BackButton {
        id: back
        onClicked: root.backButtonClicked()
        visible: false
    }

    states: [
        State {
            name: "backButton"
            when: root.backButton
            PropertyChanges {
                target: back
                visible: true
            }
            AnchorChanges {
                target: label
                anchors.left: back.right;
                anchors.right: parent.right;
                anchors.verticalCenter: parent.verticalCenter;
            }
            PropertyChanges {
                target: label
                anchors.leftMargin: 10;
                anchors.rightMargin: 5;
            }
        },
        State {
            name: "common"
            when: !root.backButton
            AnchorChanges {
                target: label
                anchors.verticalCenter: root.verticalCenter
                anchors.horizontalCenter: root.horizontalCenter
            }
        }
    ]

}
