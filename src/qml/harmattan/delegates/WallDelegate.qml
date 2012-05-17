// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0
import com.vk.api 0.1
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
            "attachments" : attachments
        }
        pageStack.push(appWindow.createPage("subpages/CommentsPage.qml"), properties)
    }

    imageSource: Utils.getContactPhotoSource(from)
    imageUrl: from.photoSourceBig
    item: data

    Column {
        id: data

        Label {
            id: titleLabel
            text: from.name
            width: parent.width
            color: "#2b497a"
            font.pixelSize: appWindow.normalFontSize
        }

        Label {
            id: activityLabel

            onLinkActivated: Qt.openUrlExternally(link)

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

        PostInfo {
            date: model.date
            comments: model.comments
            likes: model.likes
        }
    }
}
