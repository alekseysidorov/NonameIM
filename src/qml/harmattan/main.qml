import QtQuick 1.1
import com.nokia.meego 1.0
import com.vk.api 0.1
import "components"

PageStackWindow {
    id: appWindow

    Component.onCompleted: {
        pageStack.toolBar.style.inverted = true //HACK
        client.connectToHost()
    }

    initialPage: newsPage

    NewsPage {
        id: newsPage
    }

    WallPage {
        id: wallPage
    }

    DialogsPage {
        id: dialogsPage
    }

    AudioPage {
        id: audioPage
    }

    RosterPage {
        id: rosterPage
    }

    ChatPage {
        id: chatPage
    }

    LoginPage {
        id: loginPage
        password: client.password
        login: client.login

        onRequestLogin: {
            client.connectToHost(login, password)
        }
    }

    Client {
        id: client

        onOnlineStateChanged: {
            if (online) {
                //pageStack.push(newsPage);
            } else {
                //pageStack.push(loginPage);
            }
        }
    }

    ToolBarLayout {
        id: commonTools

        TileRow {
            id: tileRow
            pageStack: appWindow.pageStack

            anchors.fill: commonTools
            anchors.leftMargin: 18
            anchors.rightMargin: 12

            spacing: 24

            TileIcon {
                id: newsIcon
                checkable: true
                page: newsPage
                text: qsTr("News")
                iconSource: checked ? "images/tile-news-down.png" :
                                      "images/tile-news-up.png"
            }
            TileIcon {
                id: wallIcon
                checkable: true
                page: wallPage
                text: qsTr("Wall")
                iconSource: checked ? "images/tile-wall-down.png" :
                                      "images/tile-wall-up.png"
            }
            TileIcon {
                id: messagesIcon
                checkable: true
                page: dialogsPage
                text: qsTr("Messages")
                iconSource: checked ? "images/tile-messages-down.png" :
                                      "images/tile-messages-up.png"
                badge: dialogsPage.unreadCount > 0 ? dialogsPage.unreadCount : ""
            }
            TileIcon {
                id: audioIcon
                checkable: true
                page: audioPage
                text: qsTr("Audio")
                iconSource: checked ? "images/tile-audio-down.png" :
                                      "images/tile-audio-up.png"
            }
            TileIcon {
                id: friendsIcon
                checkable: true
                page: rosterPage
                text: qsTr("Friends")
                iconSource: checked ? "images/tile-friends-down.png" :
                                      "images/tile-friends-up.png"
            }

        }
    }

    Connections {
        target: client.longPoll ? client.longPoll : parent
        onMessageAdded: {
            messagesIcon.alert();
        }
    }
}
