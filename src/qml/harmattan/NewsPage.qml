import QtQuick 1.1
import com.nokia.meego 1.0
import com.vk.api 0.1
import "delegates"
import "components"
import "ios" as Ios

Page {
    id: newsPage
    property bool busy: false

    function __update() {
        if (client.online) {
            busy = true
            newsFeedModel.getLatestNews()
        }
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

    Ios.BusyIndicator {
        id: busyIndicator
        anchors.centerIn: parent
        visible: busy
        running: busy
    }

    NewsFeedModel {
        id: newsFeedModel

        onGetFinished: busy = false
    }

    ListView {
        id: newsList
        anchors.top: header.bottom
        anchors.bottom: parent.bottom
        width: parent.width
        delegate: NewsDelegate {}
        model: newsFeedModel
    }

    ScrollDecorator {
        flickableItem: newsList
    }
}
