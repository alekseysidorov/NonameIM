import QtQuick 1.1
import com.nokia.meego 1.0
import com.vk.api 0.1
import "delegates"
import "components"

Page {
    id: messagesPage
    property Client __client: client //workaround
    property alias unreadCount: dialogsModel.unreadCount

    function update() {
        if (client.online) {
            dialogsModel.getLastDialogs()
            appWindow.addTask(qsTr("Getting dialogs..."), dialogsModel.requestFinished)
        }
    }
    function clear() {
        if (client.online)
            dialogsModel.clear()
    }

    onStatusChanged: {
        if (status === PageStatus.Active)
            update()
    }

    tools: commonTools
    orientationLock: PageOrientation.LockPortrait

    PageHeader {
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
                chatPage.contact = contact;
                pageStack.push(chatPage)
            }
        }
        currentIndex: -1
        cacheBuffer: 100500
    }

    ScrollDecorator {
        flickableItem: rosterView
    }

    UpdateIcon {
        flickableItem: rosterView
        onTriggered: {
            update()
        }
    }
}
