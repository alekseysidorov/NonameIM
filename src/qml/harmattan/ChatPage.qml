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

        Label{
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
        anchors.bottom: parent.bottom;
        model: chatModel
        highlight: HighlightDelegate {}
        delegate: DialogDelegate {}
        currentIndex: -1;
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
}
