import QtQuick 1.1
import com.nokia.meego 1.0
import com.nokia.extras 1.1
import com.vk.api 0.1
import "ios" as Ios
import "components"

PageStackWindow {
    id: appWindow

    property int bigFontSize: 25
    property int normalFontSize: 23
    property int smallFontSize: 21
    property int tinyFontSize: 19
    property bool busy: false

    function createPage(pageName, update) {
        var component = Qt.createComponent(pageName);
        var page = component.createObject(pageName);
        if (!page) {
            console.log(component.errorString())
            return
        }
        var parentPage = pageStack.currentPage
        var statusHandler = function() {
            if (page.status === PageStatus.Active) {
                if (update)
                    update()
                else if (page.update)
                    page.update()
            } else if (page.status === PageStatus.Inactive) {
                if (pageStack.currentPage == parentPage) {
                    page.destroy(1000)
                    console.log("destroy page: " + page)
                }
            }
        }

        page.statusChanged.connect(statusHandler)
        return page
    }

    function addTask(str, finish) {
        finish.connect(balloon.finished)
        busy = true
    }

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

//    AudioPage {
//        id: audioPage
//    }

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

    Balloon {
        id: balloon

        signal finished
        onFinished: busy = false

        opacity: busy
        anchors.centerIn: parent

        Ios.BusyIndicator {
            id: busyIndicator
            anchors.centerIn: parent
            running: busy

            Component.onCompleted: {
                platformStyle.inverted = true
                platformStyle.size = "large"
            }
        }
    }


    Client {
        id: client

        onOnlineStateChanged: {
            if (online) {
                if (pageStack.currentPage != newsPage)
                    pageStack.push(newsPage);

                var reply = client.request("audio.get", {"count" : 10})
                reply.resultReady.connect(function(response) {
                    console.log("response received")
                })
            } else {
                pageStack.replace(loginPage);
            }
        }
    }

    ToolBarLayout {
        id: commonTools

        Ios.TileRow {
            id: tileRow
            pageStack: appWindow.pageStack

            anchors.fill: commonTools
            anchors.leftMargin: 18
            anchors.rightMargin: 12

            spacing: 24

            Ios.TileIcon {
                id: newsIcon
                checkable: true
                page: newsPage
                text: qsTr("News")
                iconSource: checked ? "images/tile-news-down.png" :
                                      "images/tile-news-up.png"
            }
            Ios.TileIcon {
                id: wallIcon
                checkable: true
                page: wallPage
                text: qsTr("Wall")
                iconSource: checked ? "images/tile-wall-down.png" :
                                      "images/tile-wall-up.png"
            }
            Ios.TileIcon {
                id: messagesIcon
                checkable: true
                page: dialogsPage
                text: qsTr("Messages")
                iconSource: checked ? "images/tile-messages-down.png" :
                                      "images/tile-messages-up.png"
                badge: dialogsPage.unreadCount > 0 ? dialogsPage.unreadCount : ""
            }
            Ios.TileIcon {
                id: audioIcon
                checkable: true
                page: audioPage
                text: qsTr("Audio")
                iconSource: checked ? "images/tile-audio-down.png" :
                                      "images/tile-audio-up.png"
                badge: audioPage.playing ? "*" : ""
            }
            Ios.TileIcon {
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
