// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0
import "../utils.js" as Utils

Item {
    id: root

    property bool playing: isCurrent && (!player.paused)
    property bool isCurrent: audioPage.audioUrl == model.url

    property int __verticalSpacing: 6
    property int __horizontalSpacing: 12

    width: parent ? parent.width : 600
    height: column.height + column.y + __verticalSpacing

    Image {
        id: playButton

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

            anchors {
                left: parent.left
                right: parent.right
            }
            text: Utils.convertSpecialChars(title)
            font.pixelSize: appWindow.normalFontSize
            elide: Text.ElideRight
            font.bold: true
        }

        Label {
            id: artistLabel

            anchors {
                left: parent.left
                right: parent.right
            }
            text: Utils.convertSpecialChars(artist)
            font.pixelSize: appWindow.smallFontSize
            color: "#505050"
            elide: Text.ElideRight
        }

        Loader {
            id: progressLoader

            sourceComponent: playing ? progress : null
            anchors {
                left: parent.left
                right: parent.right
            }
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
        anchors {
            left: parent.left
            right: parent.right
        }
        height: 1
        anchors.bottom: parent.bottom
        color: "#c0c0c0"
    }

    Image {
        id: iconAdd;
        width: visible ? 38 : 0;

        anchors.bottom: root.bottom
        anchors.bottomMargin: mm
        anchors.right: parent.right;
        anchors.rightMargin: 7;

        smooth: true;
        visible: audioPage.searchQuery ? true : false;
        source: "../images/ic_attach_add_down.png";

        MouseArea {
            anchors.fill: parent;
            onClicked: {
                iconAdd.visible = false;
            }
        }
    }

    MouseArea {
        id: area
        anchors.fill: parent
        onClicked: {
            audioView.currentIndex = index;
            audioPage.playAudio(index);
        }
    }

    Component {
        id: progress

        ProgressBar {
            id: positionBar

            minimumValue: 0
            maximumValue: duration
            value: player.position / 1000
            indeterminate: audioPage.audioIndeterminate;
        }
    }
}
