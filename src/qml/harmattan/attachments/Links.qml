import QtQuick 1.1
import com.nokia.meego 1.0

Column {
    id: root

    property alias model: repeater.model
    width: parent ? parent.width : 600

    Repeater {
        id: repeater

        Item {
            id: delegate

            width: parent.width
            height: childrenRect.height

            Image {
                id : image
                anchors.left: parent.left
                anchors.leftMargin: 6
                source: "../images/ic_retweet_up.png"
            }

            Label {
                id: urlLabel

                anchors.left: image.right
                anchors.leftMargin: 6
                anchors.right: parent.right
                anchors.rightMargin: 6

                text: modelData.title
                font.pixelSize: appWindow.smallFontSize
                elide: Text.ElideRight
                color: "#2b497a"

                MouseArea {
                    anchors.fill: parent
                    onClicked: Qt.openUrlExternally(modelData.url)
                }
            }
        }
    }
}
