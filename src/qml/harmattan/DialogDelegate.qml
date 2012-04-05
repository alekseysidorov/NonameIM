import QtQuick 1.1
import com.nokia.meego 1.0
import com.vk.api 0.1
import "utils.js" as Utils

ItemDelegate {
    id: itemDelegate
    property QtObject contact: getContact()

    function formatDate(date) {
        return Qt.formatDateTime(date, "dddd, hh:mm");
    }
    function getContact() {
        return incoming ? from
                        : to;
    }

    imageSource: contact.photoSource
    height: 120
    item: data

    Item {
        id: data

        Column {
            anchors.verticalCenter: data.verticalCenter
            width: parent.width

            Label {
                id: titleLabel
                text: contact.name
                width: parent.width
            }
            Label {
                id: activityLabel
                text: Utils.format(body)
                width: parent.width
                elide: Text.ElideRight
                color: "#777";
                font.pixelSize: titleLabel.font.pixelSize * 0.8

                onLinkActivated: Qt.openUrlExternally(link)
            }
            Label {
                id: dateLabel
                text: formatDate(date)
                font.pixelSize: activityLabel.font.pixelSize
                color: "#2b497a"
            }
        }
    }

    Rectangle {
        y: 1;
        anchors.fill: parent;
        opacity: unread  ? 0.2 : 0;
        color: "#999999";
    }
}
