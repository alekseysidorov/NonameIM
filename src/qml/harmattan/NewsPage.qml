import QtQuick 1.1
import com.nokia.meego 1.0
import com.vk.api 1.0
import "delegates"
import "components"
import "ios" as Ios

Page {
    id: newsPage

    function update() {
        updater.update(updater.count, 0);
        updater.truncate(updater.count * 2);
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
        cacheBuffer: 100500
    }

    ScrollDecorator {
        flickableItem: newsList
    }

    Updater {
        id: updater
        flickableItem: newsList

        count: 50

        function update(count, offset) {
            return newsFeedModel.getNews(NewsFeed.FilterNone, count, offset);
        }

        function truncate(count) {
            newsFeedModel.truncate(count);
        }
    }
}
