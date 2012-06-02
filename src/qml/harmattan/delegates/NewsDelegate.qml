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
    item: data
    __minHeight: 120

    onClicked: {
        if (postId) {
            var properties = {
                "from" : source,
                "postId" : postId,
                "postBody" : body,
                "postDate" : date,
                "commentsCount" : comments.count,
                "canPost" : comments.can_post,
                "attachments" : attachments
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
            width: parent.width
            color: "#2b497a"

            font.pixelSize: appWindow.normalFontSize
        }

        Item {
            id: retweet

            visible: typeof(ownerName) !== "undefined"
            width: parent.width
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

            text: Utils.format(body, 160)
            width: parent.width
            font.pixelSize: appWindow.smallFontSize

        }

        PhotoViewer {
            model: attachments[Attachment.Photo]
        }

        Links {
            model: attachments[Attachment.Link]
        }


        //Row {
        //    id: infoRole

        //    width: parent ? parent.width : 300
        //    height: 24
        //    spacing: 9

        //    Label {
        //        id: dateLabel
        //        text: Utils.formatDate(model.date)
        //        font.pixelSize: appWindow.tinyFontSize
        //        color: "#777"
        //    }

        //    Image {
        //        id: likeImg
        //        source: "../images/ic_like_up.png"
        //    }
        //    Label {
        //        id: likeLabel
        //        font.pixelSize: appWindow.tinyFontSize
        //        color: "#777"
        //        text: typeof(model.likes.count !== "undefined") ? model.likes.count : 0
        //    }

        //    Image {
        //        id: commentsImg
        //        source: "../images/ic_comment_up.png"
        //    }
        //    Label {
        //        id: commentsLabel
        //        font.pixelSize: appWindow.tinyFontSize
        //        color: "#777"
        //        text: typeof(model.comments.count !== "undefined") ? model.comments.count : 0
        //    }
        //}

        PostInfo {
            likes: model.likes ? model.likes.count : 0
            comments: model.comments ? model.comments.count : 0
            date: model.date
        }
    }
}
