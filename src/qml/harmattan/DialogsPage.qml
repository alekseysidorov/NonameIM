import QtQuick 1.1
import com.nokia.meego 1.0
import com.vk.api 0.1

Page {
    id: messagesPage
    property Client __client: client //workaround
    property alias unreadCount: dialogsModel.unreadCount

    function __update() {
        if (client.online)
            dialogsModel.getLastDialogs()
    }
    function __clear() {
        if (client.online)
            dialogsModel.clear()
    }

    onStatusChanged: {
        if (status === PageStatus.Active)
            __update()
        else if (status === PageStatus.Inactive)
            __clear()
    }

    tools: commonTools

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
        cacheBuffer: 12
    }

    ScrollDecorator {
        flickableItem: rosterView;
    }

    UpdateIcon {
        flickableItem: rosterView
        onTriggered: {
            __update()
        }
    }
}