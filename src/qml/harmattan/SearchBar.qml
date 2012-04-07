// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0

Item {
    id: root
    property alias searchingText: chatInputEdit.text
    signal cancel
    signal search

    height: textEdit.height;
    width: parent ? parent.width : 600
    TitleBar {
        id: textEdit;
        height: chatInputEdit.height + 16;
        width: parent.width

        TextField {
            id: chatInputEdit;
            height: 50;
            anchors.verticalCenter: parent.verticalCenter;
            anchors.left: parent.left;
            anchors.leftMargin: 10;
            anchors.right: text.length ? clearButton.left : parent.right;
            anchors.rightMargin: 10;
            placeholderText: qsTr("Search");
            inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhNoPredictiveText;
            platformSipAttributes: SipAttributes {
                actionKeyLabel: qsTr("Search");
            }

            Image {
                id: iconSearch;
                anchors.right: parent.right;
                anchors.rightMargin: 15;
                anchors.verticalCenter: parent.verticalCenter;
                source: "images/ic_search.png";
                MouseArea {
                    anchors.fill: parent
                    onClicked: chatInputEdit.text = "";
                }
            }

            Keys.onReturnPressed: {
                clearButton.forceActiveFocus();
                search();
            }
        }

        Button {
            id: clearButton;
            platformStyle: ButtonStyle {
                fontPixelSize: 20;
            }
            width: 100;
            anchors.bottom: chatInputEdit.bottom;
            anchors.right: parent.right;
            anchors.rightMargin: 10;
            visible: chatInputEdit.text.length;
            text: qsTr("Cancel");
            onClicked: {
                chatInputEdit.text = "";
                cancel();
            }
        }
    }
}
