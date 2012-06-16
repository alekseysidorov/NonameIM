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
        id: wallView

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

            TitleBar {

                ToolIcon {
                    id: optsImg
                    anchors {
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                        leftMargin: appWindow.defaultMargin
                    }
                    platformIconId: "toolbar-view-menu"

                    onClicked: {
                    }
                }

                ToolIcon {
                    id: postImg
                    anchors {
                        right: parent.right
                        verticalCenter: parent.verticalCenter
                        rightMargin: appWindow.defaultMargin
                    }
                    iconSource: "images/ic_post_comment_up.png"
                    onClicked: postSheet.open()
                }

            }

            //PhotoBar {
            //    model: photoModel
            //}
        }

        highlight: HighlightDelegate {}
        delegate: WallDelegate {}
        currentIndex: -1
        cacheBuffer: 100500
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

    PostSheet {
        id: postSheet
        canAttach: true
        onAccepted: {
            //TODO move to C++ code
            var args = {
                "owner_id"  : client.me.id,
                "message"    : text,
            }
            var reply = client.request("wall.post", args)
            reply.resultReady.connect(function(response) {
                console.log(response.cid)
                update()
                postSheet.text = ""
            })
        }
    }
}
