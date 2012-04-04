import QtQuick 1.1
import com.nokia.meego 1.0
import com.vk.api 0.1

Page {
    id: chatPage;
    property ChatModel model: chatModel

    HeaderBar {
        id: header;

        BackButton {
            id: back
            onClicked: pageStack.pop();
        }

        Label {
            anchors.left: back.right;
            anchors.leftMargin: 5;
            anchors.right: parent.right;
            anchors.rightMargin: 5;
            anchors.verticalCenter: parent.verticalCenter;
            color: "white";
            text: chatModel.title
            horizontalAlignment: Text.AlignHCenter;
            font.pixelSize: 27;
            font.bold: true;
        }
    }

    ListView {
        id: chatView;
        width: parent.width;
        anchors.top: header.bottom;
        anchors.bottom: chatInput.top;
        model: chatModel
        highlight: HighlightDelegate {}
        delegate: ChatDelegate {}
        currentIndex: -1
        onCountChanged: positionViewAtIndex(count - 1, ListView.End);
    }

    ChatModel {
        id: chatModel
    }

    ScrollDecorator {
        flickableItem: chatView;
    }

    onVisibleChanged: {
        if (visible && client.isOnline) {
            chatModel.getHistory()
        }
    }

    Rectangle {
        id: chatInput;
        height: input.height + 16;
        width: parent.width;
        anchors.bottom: parent.bottom;
        color: "#C3C5C9";

        TextArea {
            id: input;
            height: Math.max (50, Math.min(implicitHeight, 340));
            anchors.verticalCenter: parent.verticalCenter;
            anchors.left: parent.left;
            anchors.leftMargin: 5;
            anchors.right: sendButton.left;
            anchors.rightMargin: 4;
            wrapMode: TextEdit.Wrap;
            clip: true;
            placeholderText: qsTr("Type your text here...");
            errorHighlight: text.length > 4096;
        }

        Button {
            id: sendButton;
            width: 100;
            anchors.bottom: input.bottom;
            anchors.right: parent.right;
            anchors.rightMargin: 6;
            text: qsTr("Send");
            onClicked: {
                chatModel.contact.sendMessage(input.text);
                input.text = "";
            }
        }
    }
}
