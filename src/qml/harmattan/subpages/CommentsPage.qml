import QtQuick 1.1
import com.nokia.meego 1.0
import com.vk.api 1.0
import "../utils.js" as Utils
import "../delegates"
import "../components"
import ".."

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
        updater.update(updater.count, 0);
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

        anchors {
            left: parent.left
            right: parent.right
            top: header.bottom
            bottom: comments.top
        }

        model: commentsModel
        delegate: CommentsDelegate {}
        currentIndex: -1
    }

    Updater {
        id: updater

        flickableItem: commentsView
        header: Column {
            id: column

            anchors {
                left: parent.left
                right: parent.right
            }
            spacing: 6

            ContactHeader {
                contact: from
                comment: Utils.formatDate(postDate)
            }

            Label {
                anchors {
                    left: parent.left
                    right: parent.right
                    leftMargin: appWindow.defaultMargin
                    rightMargin: appWindow.defaultMargin
                }

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

        function update(count, offset) {
            return commentsModel.getComments(count, offset);
        }
    }

    Comments {
        id: comments

        anchors.bottom: parent.bottom
        retweeted: reposts.user_reposted
        liked: likes.user_likes
        canPost: page.canPost
        canLike: liked || likes.can_like
        canRetweet: likes.can_publish

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
