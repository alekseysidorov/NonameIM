import QtQuick 1.1
import com.nokia.meego 1.0

Column {
    id: root

    property alias model: repeater.model
    width: parent ? parent.width : 600

    Repeater {
        id: repeater

        Row {
            z: 100
            width: parent.width
            spacing: 6

            Image {
                source: "../images/ic_retweet_up.png"
            }

            Label {
                id: urlLabel

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
