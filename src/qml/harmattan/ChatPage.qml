import QtQuick 1.1
import com.nokia.meego 1.0
import com.vk.api 1.0
import "delegates"
import "components"

Page {
    id: chatPage
    property QtObject contact

    function update() {
        if (client.online) {
            chatModel.setContact(chatPage.contact);
            chatModel.getHistory();
            appWindow.addTask(qsTr("Getting chat history..."), chatModel.requestFinished);
        }
    }

    onStatusChanged: {
        if (status === PageStatus.Active)
            update()
    }

    PageHeader {
        id: header

        onBackButtonClicked: pageStack.pop()

        text: chatModel.title
        backButton: true
    }

    ListView {
        id: chatView

        function __lastItemPos() {
            return positionViewAtIndex(count - 1, ListView.End)
        }

        onCountChanged: __lastItemPos()
        onHeightChanged: __lastItemPos()

        width: parent.width
        anchors.top: header.bottom
        anchors.bottom: chatInput.top
        model: chatModel
        highlight: HighlightDelegate {}
        delegate: ChatDelegate {}
        currentIndex: -1
        cacheBuffer: 100500
    }

    Updater {
        id: updater
        flickableItem: chatView

        count: 50

        function update(count, offset) {
            return chatModel.getHistory(count, offset);
        }
    }

    ChatModel {
        id: chatModel
    }

    ScrollDecorator {
        flickableItem: chatView;
    }

    Rectangle {
        id: chatInput
        height: input.height + 16
        width: parent.width
        anchors.bottom: parent.bottom
        color: "#C3C5C9"

        TextArea {
            id: input;
            height: Math.max (50, Math.min(implicitHeight, 340))
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 5
            anchors.right: sendButton.left
            anchors.rightMargin: 4
            wrapMode: TextEdit.Wrap
            clip: true
            placeholderText: qsTr("Type your text here...")
            errorHighlight: text.length > 4096
        }

        Button {
            id: sendButton
            width: 100
            anchors.bottom: input.bottom
            anchors.right: parent.right
            anchors.rightMargin: 6
            text: qsTr("Send")
            onClicked: {
                chatModel.contact.sendMessage(input.text)
                input.text = ""
            }
        }
    }
}
