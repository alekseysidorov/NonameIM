import QtQuick 1.1
import com.nokia.meego 1.0
import com.vk.api 1.0
import "delegates"
import "components"
import "ios" as Ios

Page {
    id: newsPage

    property int __offset: 0
    property int __count: 30
    property bool __isNextLoading: false
    property int __truncateCount: 100

    function update() {
        if (client.online) {
            appWindow.addTask(qsTr("Getting news..."), newsFeedModel.requestFinished)
            getNews(__count, 0)
        }
    }

    function getNews(count, offset) {
        __offset = offset
        newsFeedModel.getNews(NewsFeed.FilterPost
                              | NewsFeed.FilterPhoto,
                              __count,
                              __offset)
    }

    function getNextNews() {
        if (client.online) {
            __isNextLoading = true
            __offset += __count
            getNews(__count, __offset)
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

        onRequestFinished: {
            if (!__offset)
                truncate(__truncateCount)
            __isNextLoading = false
        }
    }

    ListView {
        id: newsList

        onAtYEndChanged: {
            if (atYEnd && !__isNextLoading)
                getNextNews()
        }

        anchors.top: header.bottom
        anchors.bottom: parent.bottom
        width: parent.width
        delegate: NewsDelegate {}
        model: newsFeedModel
        cacheBuffer: 100500
        footer: UpdateIndicator {
            visible: newsList.count
            running: __isNextLoading
        }
    }

    ScrollDecorator {
        flickableItem: newsList
    }
}
