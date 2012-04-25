import QtQuick 1.1
import com.nokia.meego 1.0
import com.vk.api 0.1
import "delegates"
import "components"
import "draft"

Page {
    id: wallPage

    function update() {
        if (client.online) {
            wallModel.getLastPosts()
            appWindow.addTask(qsTr("Getting wall posts..."), wallModel.requestFinished)
            photoModel.getAll(client.me.id)
        }
    }
    onStatusChanged: {
        if (status === PageStatus.Active)
            update()
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

        header: Column {
            width: parent ? parent.width : 600

            PhotoBar {
                model: photoModel
            }
        }

        highlight: HighlightDelegate {}
        delegate: WallDelegate {}
        currentIndex: -1
    }

    WallModel {
        id: wallModel
        contact: client.me
    }

    PhotoModel {
        id: photoModel
    }

    ScrollDecorator {
        flickableItem: wallView;
    }

    UpdateIcon {
        flickableItem: wallView
        onTriggered: update()
    }
}
