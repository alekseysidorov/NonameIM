import QtQuick 1.1
import com.nokia.meego 1.0
import "../utils.js" as Utils

SimpleImageItemDelegate {
    id: itemDelegate

    onClicked: appWindow.showProfile(model.contact)

    clickable: true
    imageSource: photo

    Label {
        id: nameLabel
        text: name
        width: parent.width
    }
    Label {
        id: activityLabel
        text: activity
        width: parent.width
        elide: Text.ElideRight
        color: "#777"
        font.pixelSize: nameLabel.font.pixelSize * 0.8

    }
}
