// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0
import "../utils.js" as Utils

ItemDelegate {
    id: itemDelegate

    imageSource: Utils.getContactPhotoSource(source)
    item: data

    onClicked: {
        var properties = {
            "from" : source,
            "postId" : postId,
            "postBody" : body,
            "postDate" : date
        }
        pageStack.push(appWindow.createPage("CommentsPage.qml"), properties)
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

            onLinkActivated: Qt.openUrlExternally(link)

            text: Utils.format(body, 160)
            width: parent.width
            font.pixelSize: appWindow.smallFontSize

        }
        Row {
            width: parent.width
            Label {
                id: dateLabel
                text: Utils.formatDate(date)
                font.pixelSize: appWindow.tinyFontSize
                color: "#777";
            }

        }
    }
}
