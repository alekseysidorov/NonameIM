// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0
import com.vk.api 0.1
import "../utils.js" as Utils
import "../attachments"
import "../components"

ItemDelegate {
    id: itemDelegate

    imageSource: sourcePhoto
    __minHeight: 120
    item: data

    onClicked: {
        if (postId) {
            var properties = {
                "from" : source,
                "postId" : postId,
                "postBody" : body,
                "postDate" : date,
                "commentsCount" : comments.count,
                "canPost" : comments.can_post,
                "attachments" : attachments,
                "likes" : function() { return likes },
                "reposts" : function() { return reposts },
                "wall" : newsFeedModel
            }
            pageStack.push(appWindow.createPage("subpages/CommentsPage.qml"), properties)
        }
    }

    Column {
        id: data
        spacing: 6

        Label {
            id: titleLabel
            text: sourceName
            anchors {
                left: parent.left
                right: parent.right
            }
            color: "#2b497a"

            font.pixelSize: appWindow.normalFontSize
        }

        Item {
            id: retweet

            visible: typeof(ownerName) !== "undefined"
            anchors {
                left: parent.left
                right: parent.right
            }
            height: retweetImg.height

            Image {
                id : retweetImg
                anchors.left: parent.left
                anchors.leftMargin: 6
                source: "../images/ic_retweet_up.png"
            }

            Label {
                id: retweetLabel

                anchors.left: retweetImg.right
                anchors.leftMargin: 6
                anchors.right: parent.right
                anchors.rightMargin: 6
                anchors.verticalCenter: retweetImg.verticalCenter

                text: ownerName ? ownerName : ""
                font.pixelSize: appWindow.smallFontSize
                elide: Text.ElideRight
                color: "#2b497a"
            }
        }

        Label {
            id: activityLabel

            text: Utils.format(body, 320)
            anchors {
                left: parent.left
                right: parent.right
            }
            font.pixelSize: appWindow.smallFontSize

        }

        PhotoViewer {
            anchors {
                left: parent.left
                right: parent.right
            }
            model: attachments[Attachment.Photo]
        }

        Links {
            anchors {
                left: parent.left
                right: parent.right
            }
            model: attachments[Attachment.Link]
        }

        PostInfo {
            anchors {
                left: parent.left
                right: parent.right
            }
            likes: likesCount
            comments: commentsCount
            date: model.date
        }
    }
}
