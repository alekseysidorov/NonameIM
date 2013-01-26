import QtQuick 1.1
import com.nokia.meego 1.0
import com.vk.api 1.0
import "../utils.js" as Utils
import "../components"
import com.vk.api 1.0

ImageItemDelegate {
    id: itemDelegate

    Component.onCompleted: {
        if (unread)
            chatModel.markAsRead(mid)
    }

    clickable: false
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

        onLinkActivated: Qt.openUrlExternally(link)

        text: Utils.replaceURLWithHTMLLinks(body)
        width: parent.width

        font.pixelSize: appWindow.smallFontSize
    }
    AttachmentsView {
        photos: attachments[Attachment.Photo]
        links: attachments[Attachment.Link]
    }
    Label {
        id: dateLabel
        text: Utils.formatDate(date)
        font.pixelSize: appWindow.tinyFontSize
        color: "#777"
    }

    Rectangle {
        parent: itemDelegate
        anchors.fill: parent
        y: 1
        opacity: unread ? 0.2 : 0
        color: "#999999"
    }
}
