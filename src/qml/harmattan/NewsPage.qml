import QtQuick 1.1
import com.nokia.meego 1.0
import com.vk.api 1.0
import "delegates"
import "components"
import "ios" as Ios

Page {
    id: newsPage

    function update() {
        updater.getFirst();
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

        onClicked: newsList.positionViewAtBeginning()

        text: qsTr("News")
    }

    NewsFeedModel {
        id: newsFeedModel
    }

    ItemView {
        id: newsList

        anchors.top: header.bottom
        anchors.bottom: parent.bottom
        width: parent.width
        delegate: WallDelegate {}
        model: newsFeedModel
    }

    ScrollDecorator {
        flickableItem: newsList
    }

    Updater {
        id: updater
        flickableItem: newsList

        canUpdate: client.online && status === PageStatus.Active

        function update(count, offset) {
            return newsFeedModel.getNews(NewsFeed.FilterNone, count, offset);
        }

        function truncate(count) {
            newsFeedModel.truncate(count);
        }
    }
}
