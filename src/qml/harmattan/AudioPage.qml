import QtQuick 1.1
import com.nokia.meego 1.0
import com.vk.api 1.0
import QtMultimediaKit 1.1
import "delegates"
import "components"

Page {
    id: audioPage
    property QtObject owner: client.me
    property int playingIndex: -1
    property bool playing: player.playing && !player.paused

    property QtObject __client: client //workaround
    property Item __playingItem
    property bool __intermidate: true
    property string query

    function update() {
        if (client.online) {
            if (query === "")
                audioModel.getContactAudio(client.me)
            else
                audioModel.searchAudio(query)
        }
    }

    onPlayingIndexChanged: {
        if (playingIndex === -1)
            player.pause()
        else {
            player.stop()
            player.source = audioModel.get(playingIndex, "url")
            player.play()
        }
    }
    onStatusChanged: {
        if (status === PageStatus.Active)
            update()
    }

    onQueryChanged: {
        audioModel.clear()
        update()
    }

    tools: commonTools
    orientationLock: PageOrientation.LockPortrait

    PageHeader {
        id: header
        text: qsTr("Audio")
    }

    ListView {
        id: audioView
        width: parent.width
        anchors.top: header.bottom
        anchors.bottom: parent.bottom
        highlight: HighlightDelegate{}
        highlightMoveSpeed: -1
        header: SearchBar {
            id: searchBar

            onSearch: query = searchingText
            onCancel: query = ""
        }
        model: audioModel
        delegate: AudioDelegate {
            id: audioDelegate

            onClicked: {
                playingIndex = playing ? -1 : index
            }

            onPlayingChanged: {
                if (playing) {
                    position = function() { return player.position/1000 }
                    bufferProgress = function() { return player.bufferProgress }
                    indeterminate = function() { return __intermidate }
                } else {
                    position = 0
                    bufferProgress = 0
                    indeterminate = true
                }
            }

            playing: playingIndex === index

        }
        currentIndex: -1
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
