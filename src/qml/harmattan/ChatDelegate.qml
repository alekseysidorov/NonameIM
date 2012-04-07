import QtQuick 1.1
import com.nokia.meego 1.0
import com.vk.api 0.1
import "utils.js" as Utils

ItemDelegate {
    id: itemDelegate
    clickable: false

    imageSource: Utils.getContactPhotoSource(from)
    item: data

    Column {
        id: data

        Label {
            id: titleLabel
            text: from.name
            width: parent.width
            color: "#2b497a"
        }
        Label {
            id: activityLabel

            onLinkActivated: Qt.openUrlExternally(link)

            text: Utils.replaceURLWithHTMLLinks(body)
            width: parent.width
            font.pixelSize: titleLabel.font.pixelSize * 0.8
            textFormat: Text.RichText
        }
        Label {
            id: dateLabel
            text: Utils.formatDate(date)
            font.pixelSize: activityLabel.font.pixelSize * 0.9
            color: "#777";
        }
    }

    Rectangle {
        y: 1;
        anchors.fill: parent;
        opacity: unread ? 0.2 : 0;
        color: "#999999";
    }
}
