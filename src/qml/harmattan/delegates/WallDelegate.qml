// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0
import com.vk.api 1.0
import "../utils.js" as Utils
import "../components"
import "../attachments"

ItemDelegate {
    id: itemDelegate

    onClicked: {
        var properties = {
            "from" : from,
            "postId" : postId,
            "postBody" : body,
            "postDate" : date,
            "attachments" : attachments,
            "likes" : function() { return likes },
            "reposts" : function() { return reposts },
            "wall" : wallModel
        }
        pageStack.push(appWindow.createPage("subpages/CommentsPage.qml"), properties)
    }

    Component.onCompleted: from.update();

    onVisibleChanged: {
        if (visible)
            from.update()
    }

    imageSource: Utils.getContactPhotoSource(from)
    imageUrl: from.photoSourceBig
    item: data

    Column {
        id: data

        Label {
            id: titleLabel
            text: from.name
            anchors {
                left: parent.left
                right: parent.right
            }
            color: "#2b497a"
            font.pixelSize: appWindow.normalFontSize
        }

        Label {
            id: activityLabel

            onLinkActivated: Qt.openUrlExternally(link)

            text: Utils.format(body, 160)
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
            date: model.date
            comments: model.comments ? model.comments.count : 0
            likes: model.likes ? model.likes.count : 0
        }
    }
}
