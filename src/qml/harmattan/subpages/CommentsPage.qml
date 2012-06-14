import QtQuick 1.1
import com.nokia.meego 1.0
import com.vk.api 0.1
import "../utils.js" as Utils
import "../delegates"
import "../components"

Page {
    id: page

    property QtObject wall
    property QtObject from
    property alias postId : commentsModel.postId
    property string postBody : qsTr("Unknown post!")
    property date postDate
    property int commentsCount
    property bool canPost : true
    property variant likes
    property variant reposts
    property variant attachments

    function update() {
        if (client.online) {
            commentsModel.getComments()
            appWindow.addTask(qsTr("Getting comments..."), commentsModel.requestFinished)
        }
    }

    orientationLock: PageOrientation.LockPortrait

    PageHeader {
        id: header
        text: qsTr("Comments")
        backButton: true
        onBackButtonClicked: pageStack.pop()
    }

    ListView {
        id: commentsView

        function __firstItemPos() {
            return positionViewAtIndex(0, ListView.End)
        }

        onCountChanged: __firstItemPos()
        onHeightChanged: __firstItemPos()

        width: parent.width;
        anchors.top: header.bottom
        anchors.bottom: comments.top
        model: commentsModel
        header: Column {
            width: parent.width
            spacing: 6

            ContactHeader {
                contact: from
                comment: Utils.formatDate(postDate)
            }

            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                width:  parent.width - 24
                text: Utils.format(postBody.concat("<br />"))
                font.pixelSize: appWindow.smallFontSize
                onLinkActivated: Qt.openUrlExternally(link)
            }

            AttachmentsView {
                anchors.horizontalCenter: parent.horizontalCenter
                width:  parent.width - 24

                photos: attachments[Attachment.Photo]
                links: attachments[Attachment.Link]
            }

            Rectangle {
                width: parent.width
                height: 1
                color: "#c0c0c0"
            }
        }
        highlight: HighlightDelegate {}
        delegate: CommentsDelegate {}
        currentIndex: -1
    }

    Comments {
        id: comments

        anchors.bottom: parent.bottom
        retweeted: reposts.user_reposted
        liked: likes.user_likes

        function addLike(repost)
        {
            wall.addLike(postId, repost)
        }

        function deleteLike()
        {
            wall.deleteLike(postId)
        }

        onPost: {
            postSheet.open()
        }

        onLike: {
            if (!liked)
                addLike(false)
            else
                deleteLike()
        }
        onRetweet: {
            if (!liked)
                addLike(true)
            else
                deleteLike()
        }

        canPost: page.canPost
    }

    CommentsModel {
        id: commentsModel
        contact: from
    }

    ScrollDecorator {
        flickableItem: commentsView
    }

    UpdateIcon {
        flickableItem: commentsView
        onTriggered: update()
    }

    PostSheet {
        id: postSheet

        onAccepted: {
            //TODO move to C++ code
            var args = {
                "owner_id"  : from.id,
                "post_id"    : postId,
                "text": text
            }
            var reply = client.request("wall.addComment", args)
            reply.resultReady.connect(function(response) {
                console.log(response.cid)
                update()
                postSheet.text = ""
            })
        }
    }
}
