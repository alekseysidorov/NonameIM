import QtQuick 1.1
import com.nokia.meego 1.0
import com.vk.api 0.1
import "delegates"
import "components"
import "ios" as Ios

Page {
    id: newsPage

    function update() {
        if (client.online) {
            appWindow.addTask(qsTr("Getting news..."), newsFeedModel.requestFinished)
            newsFeedModel.getLatestNews()
        }
    }
    onStatusChanged: {
        if (status === PageStatus.Active)
            update()
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
        onTriggered: update()
    }

    NewsFeedModel {
        id: newsFeedModel
    }

    ListView {
        id: newsList
        anchors.top: header.bottom
        anchors.bottom: parent.bottom
        width: parent.width
        delegate: NewsDelegate {}
        model: newsFeedModel
        cacheBuffer: parent.height
    }

    ScrollDecorator {
        flickableItem: newsList
    }
}
