import QtQuick 1.1
import com.nokia.meego 1.0
import com.vk.api 1.0
import "../utils.js" as Utils

ItemDelegate {
    id: itemDelegate
    property QtObject contact: getContact()

    function getContact() {
        return incoming ? from
                        : to
    }

    onVisibleChanged: {
        if (visible && contact)
            contact.update()
    }

    Component.onCompleted: contact.update();

    imageSource: Utils.getContactPhotoSource(contact)
    item: data

    Column {
        id: data
        spacing: __spacing

        Label {
            id: titleLabel
            text: contact.name
            width: parent.width
            font.pixelSize: appWindow.normalFontSize
            color: "#2b497a"
        }
        Label {
            id: activityLabel
            text: Utils.format(body, 320)
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
        opacity: unread  ? 0.2 : 0
        color: "#999999"
    }
}
