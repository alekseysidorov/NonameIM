// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0
import "../utils.js" as Utils
import "../components"

ItemDelegate {
    id: itemDelegate

    onClicked: {
        var properties = {
            "from" : from,
            "postId" : postId,
            "postBody" : body,
            "postDate" : date
        }
        pageStack.push(appWindow.createPage("CommentsPage.qml"), properties)
    }

    imageSource: Utils.getContactPhotoSource(from)
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

        PostInfo {
            date: model.date
            comments: model.comments
            likes: model.likes
        }
    }
}
