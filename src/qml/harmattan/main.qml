import QtQuick 1.1
import com.nokia.meego 1.0
import com.vk.api 0.1
import "ios" as Ios
import "components"

PageStackWindow {
    id: appWindow

    property int bigFontSize: 25
    property int normalFontSize: 23
    property int smallFontSize: 21
    property int tinyFontSize: 19
    property int defaultMargin: 12
    property int defaultSpacing: 6

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
        balloon.deep = 1
        finish.connect(balloon.finished)
    }

    function sendNotify(info) {
        infoBanner.push(info)
    }

    function connectToHost() {
        addTask(qsTr("Connecting to vk..."), client.onlineStateChanged)
        client.connectToHost()
    }

    function showProfile(contact) {
        var properties = {
            "contact" : contact
        }
        pageStack.push(appWindow.createPage("ProfilePage.qml"), properties)
    }

    function showPhoto(source) {
        var properties = {
            "source" : source
        }
        pageStack.push(appWindow.createPage("subpages/SinglePhotoPage.qml"), properties)
    }

    Component.onCompleted: {
        pageStack.toolBar.style.inverted = true //HACK
        if (client.login && client.password)
            connectToHost()
        else
            pageStack.push(loginPage)

        client.longPoll.contactTyping.connect(function(clientId) {
            var contact = client.contact(clientId)
            var item = {
                "text": qsTr("%1 is typing").arg(contact.name),
                "iconSource": "../images/tile-messages-up.png",
                "callback" : function() {
                    chatPage.contact = contact
                    pageStack.push(chatPage)
                }
            }
            sendNotify(item)
        })
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
            client.login = login
            client.password = password
            connectToHost()
        }
    }

    Balloon {
        id: balloon

        property int deep: 0
        signal finished

        onFinished: deep = 0

        opacity: deep > 0
        anchors.centerIn: parent

        Ios.BusyIndicator {
            id: busyIndicator
            anchors.centerIn: parent
            running: balloon.deep > 0

            Component.onCompleted: {
                platformStyle.inverted = true
                platformStyle.size = "large"
            }
        }
    }

    StackedInfoBanner {
        id: infoBanner

        topMargin: 120
        leftMargin: 7

        timerEnabled : true
        timerShowTime : 5000
    }

    Client {
        id: client

        invisible: true

        onOnlineStateChanged: {
            if (online) {
                pageStack.pop(loginPage)
                var page = pageStack.currentPage
                if (page.status === PageStatus.Active && page.update()) {
                    pageStack.currentPage.update()
                }
                if (page != dialogsPage)
                    dialogsPage.update()
            } else {
                pageStack.push(loginPage)
                balloon.deep = 0
                var item = {
                    "text" : qsTr("Disconnected from host")
                }
                sendNotify(item)
            }
        }

        onMessageReceived: {
            messagesIcon.alert()
            var contact = from
            var item = {
                "text": qsTr("New message recieved"),
                "iconSource": "../images/tile-messages-up.png",
                "callback" : function() {
                    chatPage.contact = contact
                    pageStack.push(chatPage)
                }
            }
            sendNotify(item)
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
                badge: dialogsPage.unreadCount ? dialogsPage.unreadCount : ""
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
}
