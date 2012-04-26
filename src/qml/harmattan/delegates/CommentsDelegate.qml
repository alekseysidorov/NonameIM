// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0
import "../utils.js" as Utils
import "../components"

ItemDelegate {
    id: itemDelegate

    clickable: true
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

            text: Utils.format(body)
            width: parent.width
            font.pixelSize: appWindow.smallFontSize
        }

        PostInfo {
            date: model.date
            likes: model.likes
        }
    }

    onClicked: appWindow.showProfile(from)
}
