import QtQuick 1.1
import com.nokia.meego 1.0

ItemDelegate {
    id: itemDelegate
    imageSource: contact.photoSource
    height: 120
    item: data

    function formatDate(date) {
        return Qt.formatDateTime(date, "dddd, hh:mm");
    }

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
                text: body
                width: parent.width
                elide: Text.ElideRight
                //wrapMode: Text.WordWrap
                color: "#777";
                font.pixelSize: titleLabel.font.pixelSize * 0.8
            }
            Label {
                id: dateLabel
                text: formatDate(date)
                font.pixelSize: activityLabel.font.pixelSize
                color: "#2b497a"
            }
        }
    }
}
