import QtQuick 1.1
import com.nokia.meego 1.0
import com.vk.api 0.1

Page {
    id: messagesPage
    property Client __client: client //workaround
    property alias unreadCount: dialogsModel.unreadCount

    Header {
        id: header
        text: qsTr("Messages")
    }

    DialogsModel {
        id: dialogsModel
        client: __client
    }

    ListView {
        id: rosterView;
        width: parent.width;
        anchors.top: header.bottom;
        anchors.bottom: parent.bottom;
        model: dialogsModel
        highlight: HighlightDelegate {}
        delegate: DialogDelegate {
            id: delegate
            onClicked: {
                chatPage.model.contact = contact;
                pageStack.push(chatPage)
            }
        }
        currentIndex: -1;
    }

    ScrollDecorator {
        flickableItem: rosterView;
    }

    Connections {
        target: client
        onIsOnlineChanged: {
            if (client.isOnline)
                client.roster.sync()
        }
    }

    tools: commonTools

    onVisibleChanged: {
        if (visible && client.isOnline)
            dialogsModel.getLastDialogs()
    }
}
