import QtQuick 1.1
import com.nokia.meego 1.0
import com.vk.api 0.1
import "delegates"
import "components"

Page {
    id: wallPage

    function __update() {
        if (client.online) {
            wallModel.getLastPosts()
            appWindow.addTask(qsTr("Getting wall posts..."), wallModel.requestFinished)
        }
    }
    onStatusChanged: {
        if (status === PageStatus.Active)
            __update()
    }

    tools: commonTools
    orientationLock: PageOrientation.LockPortrait

    PageHeader {
        id: header
        text: qsTr("Wall")
    }

    ListView {
        id: wallView;

        function __firstItemPos() {
            return positionViewAtIndex(0, ListView.End)
        }

        onCountChanged: __firstItemPos()
        onHeightChanged: __firstItemPos()

        width: parent.width;
        anchors.top: header.bottom;
        anchors.bottom: parent.bottom;
        model: wallModel
        highlight: HighlightDelegate {}
        delegate: WallDelegate {}
        currentIndex: -1
    }

    WallModel {
        id: wallModel
        contact: client.me
    }

    ScrollDecorator {
        flickableItem: wallView;
    }

    UpdateIcon {
        flickableItem: wallView
        onTriggered: __update()
    }
}
