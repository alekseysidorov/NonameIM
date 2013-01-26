import QtQuick 1.1
import com.nokia.meego 1.0
import com.vk.api 1.0
import "delegates"
import "components"
import "draft"

Page {
    id: wallPage

    function update() {
        updater.getFirst();
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

    ItemView {
        id: wallView

        width: parent.width;
        anchors.top: header.bottom;
        anchors.bottom: parent.bottom;
        model: wallModel

        delegate: WallDelegate {}
        currentIndex: -1
    }

    WallModel {
        id: wallModel
        contact: client.me
    }

    Updater {
        id: updater

        canUpdate: client.online && status === PageStatus.Active

        function update(count, offset) {
            return wallModel.getPosts(count, offset);
        }

        flickableItem: wallView
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
    }

    PhotoModel {
        id: photoModel
    }

    ScrollDecorator {
        flickableItem: wallView;
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
                update()
                postSheet.text = ""
            })
        }
    }
}
