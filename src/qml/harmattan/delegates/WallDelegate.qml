// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0
import com.vk.api 1.0
import "../utils.js" as Utils
import "../components"
import "../attachments"

ImageItemDelegate {
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

    clickable: true
    imageSource: Utils.getContactPhotoSource(from)
    imageUrl: from.photoSourceBig

    Label {
        id: titleLabel
        text: from.name
        width: parent.width

        color: "#2b497a"
        font.pixelSize: appWindow.normalFontSize
    }

    Label {
        id: activityLabel
        width: parent.width

        onLinkActivated: Qt.openUrlExternally(link)

        text: Utils.format(body, 160)
        font.pixelSize: appWindow.smallFontSize

    }

    PhotoViewer {
        width: parent.width

        model: attachments[Attachment.Photo]
    }

    Links {
        width: parent.width

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
