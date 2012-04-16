// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0
import "../utils.js" as Utils
import "../attachments"
import "../components"

ItemDelegate {
    id: itemDelegate

    imageSource: Utils.getContactPhotoSource(source)
    item: data

    onClicked: {
        if (postId) {
            var properties = {
                "from" : source,
                "postId" : postId,
                "postBody" : body,
                "postDate" : date,
                "commentsCount" : comments.count,
                "canPost" : comments.can_post
            }
            pageStack.push(appWindow.createPage("CommentsPage.qml"), properties)
        }
    }

    Column {
        id: data

        Label {
            id: titleLabel
            text: source.name
            width: parent.width
            color: "#2b497a"

            font.pixelSize: appWindow.normalFontSize
        }

        Label {
            id: activityLabel

            text: Utils.format(body, 160)
            width: parent.width
            font.pixelSize: appWindow.smallFontSize

        }

        PhotoViewer {
            model: photos
        }

        Links {
            model: links
        }

        PostInfo {
            likes: model.likes
            comments: model.comments
            date: model.date
        }
    }
}
