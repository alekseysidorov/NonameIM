import QtQuick 1.1
import com.nokia.meego 1.0
import com.vk.api 0.1
import "../utils.js" as Utils

ItemDelegate {
    id: itemDelegate

    Component.onCompleted: {
        if (unread)
            chatModel.markAsRead(mid)
    }

    clickable: false
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

            text: Utils.replaceURLWithHTMLLinks(body)
            width: parent.width

            font.pixelSize: appWindow.smallFontSize
        }
        Label {
            id: dateLabel
            text: Utils.formatDate(date)
            font.pixelSize: appWindow.tinyFontSize
            color: "#777"
        }
    }

    Rectangle {
        y: 1
        anchors.fill: parent
        opacity: unread ? 0.2 : 0
        color: "#999999"
    }
}
