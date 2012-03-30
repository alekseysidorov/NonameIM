import QtQuick 1.1
import com.nokia.meego 1.0

ItemDelegate {
    id: itemDelegate
    item: data

    Item {
        id: data

        Column {
            anchors.verticalCenter: data.verticalCenter
            width: parent.width

            Label {
                id: name
                text: contact.name
                width: parent.width
            }
            Label {
                id: activity
                text: contact.activity
                width: parent.width
                elide: Text.ElideRight
                color: "#777";
                font.pixelSize: name.font.pixelSize * 0.8
            }
        }
    }
}
