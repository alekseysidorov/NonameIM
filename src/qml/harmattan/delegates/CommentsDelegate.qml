// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0
import "../utils.js" as Utils
import "../components"

SimpleImageItemDelegate {
    id: itemDelegate

    Component.onCompleted: from.update()
    onClicked: appWindow.showProfile(from)

    clickable: true
    imageSource: Utils.getContactPhotoSource(from)

    Label {
        id: titleLabel
        text: from.name

        color: "#2b497a"
        width: parent.width

        font.pixelSize: appWindow.normalFontSize
    }

    Label {
        id: activityLabel

        onLinkActivated: Qt.openUrlExternally(link)

        width: parent.width
        text: Utils.format(body)

        font.pixelSize: appWindow.smallFontSize
    }

    PostInfo {
        width: parent.width

        date: model.date
        likes: model.likes ? model.likes.count : 0
    }
}
