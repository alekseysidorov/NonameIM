import QtQuick 1.1
import com.nokia.meego 1.0
import com.vk.api 0.1
import QtMultimediaKit 1.1
import "delegates"
import "components"

Page {
    id: audioPage
    property QtObject owner: client.me
    property int playingIndex: -1

    property QtObject __client: client //workaround
    property Item __playingItem
    property bool __intermidate: true

    function update() {
        if (client.online)
            audioModel.getContactAudio(client.me)
    }

    onPlayingIndexChanged: {
        player.stop()
        player.source = audioModel.get(playingIndex, "url")
        player.play()
    }

    tools: commonTools
    orientationLock: PageOrientation.LockPortrait

    PageHeader {
        id: header
        text: qsTr("Audio")
    }

    ListView {
        id: audioView;
        width: parent.width;
        anchors.top: header.bottom
        anchors.bottom: parent.bottom
        highlight: HighlightDelegate{}
        highlightMoveSpeed: -1
        header: SearchBar {

        }
        model: audioModel
        delegate: AudioDelegate {
            id: audioDelegate

            onClicked: {
                playingIndex = playing ? -1 : index
            }
            playing: playingIndex === index
            position: playing ? player.position / 1000 : -1
        }
        currentIndex: -1
        cacheBuffer: 100
    }

    ScrollDecorator {
        flickableItem: audioView
    }

    UpdateIcon {
        flickableItem: audioView
        onTriggered: update()
    }

    AudioModel {
        id: audioModel
        client: __client
    }

    Audio {
        id: player

        autoLoad: true

        onStatusChanged: {
            switch (status) {
            case Audio.Stalled:
                __intermidate = true
                break
            case Audio.Buffered:
                __intermidate = false
                break
            case Audio.EndOfMedia:
                if (playingIndex === audioModel.count - 1)
                    playingIndex = 0
                else
                    playingIndex = playingIndex + 1
            }
        }
    }
}
