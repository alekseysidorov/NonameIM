import QtQuick 1.1
import com.vk.api 1.0
import "../delegates"

Column {
    property alias model: repeater.model

    clip: true
    spacing: mm

    Repeater {
        id: repeater

        delegate: Rectangle {
            color: "black"
            width: parent.width
            height: 60
        }
    }
}
