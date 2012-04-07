import QtQuick 1.1
import com.nokia.meego 1.0
import com.vk.api 0.1

Page {
    id: newsPage

    function __update() {
        if (client.online)
            newsFeedModel.getLatestNews()
    }
    onStatusChanged: {
        if (status === PageStatus.Active)
            __update()
    }

    Component.onCompleted: {
        newsFeedModel.client = client; //HACK
    }

    tools: commonTools
    orientationLock: PageOrientation.LockPortrait

    PageHeader {
        id: header
        text: qsTr("News")
    }

    UpdateIcon {
        id: updateIcon
        flickableItem: newsList
        onTriggered: __update()
    }

    NewsFeedModel {
        id: newsFeedModel
    }

    ListView {
        id: newsList
        anchors.top: header.bottom
        anchors.bottom: parent.bottom
        width: parent.width
        delegate: NewsDelegate {
            onClicked: {
                profilePage.contact = source
                pageStack.push(profilePage)
            }
        }
        model: newsFeedModel
    }

    ScrollDecorator {
        flickableItem: newsList
    }
}
