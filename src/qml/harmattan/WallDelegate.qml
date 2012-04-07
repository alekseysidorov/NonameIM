// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0
import "utils.js" as Utils

ItemDelegate {
    id: itemDelegate

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
        Row {
            width: parent.width
            Label {
                id: dateLabel
                text: Utils.formatDate(date)
                font.pixelSize: activityLabel.font.pixelSize
                color: "#777";
            }

        }
    }
}
