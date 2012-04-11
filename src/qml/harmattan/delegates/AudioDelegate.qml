// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0
import "../utils.js" as Utils

Item {
    id: root

    property bool playing: false
    property real bufferProgress
    property real position

    property int __verticalSpacing: 6
    property int __horizontalSpacing: 12

    signal clicked

    width: parent ? parent.width : 600
    height: column.height + column.y + __verticalSpacing

    Image {
        id: playButton;

        anchors.left: parent.left
        anchors.leftMargin: __horizontalSpacing
        anchors.verticalCenter: parent.verticalCenter

        source: playing ? "../images/ic_pause_list_up.png"
                        : "../images/ic_play_list_up.png"
    }

    Column {
        id: column

        anchors.top: parent.top
        anchors.topMargin: __verticalSpacing
        anchors.left: playButton.right
        anchors.leftMargin: __horizontalSpacing
        anchors.right: durationLabel.left
        anchors.rightMargin: __horizontalSpacing
        spacing: __verticalSpacing / 2

        Label {
            id: titleLabel

            width: parent.width
            text: Utils.convertSpecialChars(title)
            font.pixelSize: appWindow.normalFontSize
            elide: Text.ElideRight
            font.bold: true
        }

        Label {
            id: artistLabel

            width: parent.width
            text: Utils.convertSpecialChars(artist)
            font.pixelSize: appWindow.smallFontSize
            color: "#505050"
            elide: Text.ElideRight
        }

        ProgressBar {
            id: progressBar

            width: parent.width
            visible: playing

            minimumValue: 0
            maximumValue: duration
            indeterminate: position < 0
            value: position
        }
    }

    Label {
        id: durationLabel

        anchors.top: column.top
        anchors.right: parent.right
        anchors.rightMargin: __horizontalSpacing

        text: (duration / 60).toFixed(2)
        font.pixelSize: appWindow.smallFontSize
        color: "#505050"
    }

    Rectangle {
        width:  parent.width
        height: 1
        anchors.bottom: parent.bottom
        color: "#c0c0c0"
    }

    MouseArea {
        id: area
        anchors.fill: parent
        onClicked: root.clicked()
    }
}
