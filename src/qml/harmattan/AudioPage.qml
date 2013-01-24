import QtQuick 1.1
import com.nokia.meego 1.0
import com.vk.api 1.0
import QtMultimediaKit 1.1
import "delegates"
import "components"

Page {
    id: audioPage
    property QtObject owner: client.me

    property int audioIndex: -1;
    property bool audioIndeterminate: false;
    property string audioUrl
    property string searchQuery
    property bool audioAutoPlay: false;
    property alias musicPlaying: player.playing;

    function update() {
        updater.update(updater.count, 0);
    }

    function playAudio(index){
        if (!audioView.count)
            return;
        if (index >= audioView.count || index < 0)
            index = 0;
        audioIndex = index;
        if (audioModel.get(audioIndex).url === audioUrl){
            if (player.paused)
                player.play();
            else
                player.pause();
        } else {
            audioUrl = audioModel.get(audioIndex).url;
            player.source = audioUrl;
            player.play();
        }
    }

    function playUrlAudio(url){
        if (url === audioUrl){
            if (player.paused)
                player.play();
            else
                player.pause();
        } else {
            audioUrl = url;
            player.source = audioUrl;
            player.play();
        }
    }

    function playNext(){
        var idx;
        idx = audioIndex + 1;
        if (idx >= audioView.count)
            idx = 0;
        audioView.currentIndex = idx;
        playAudio(idx);
    }

    function playPrevious(){
        var idx;
        idx = audioIndex - 1;
        if (idx < 0)
            idx = audioView.count - 1;
        audioView.currentIndex = idx;
        playAudio(idx);
    }

    onStatusChanged: {
        audioModel.client = client;
        if (status === PageStatus.Active)
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
        model: audioModel
        delegate: AudioDelegate {}
        currentIndex: -1
        cacheBuffer: 100500
    }

    ScrollDecorator {
        flickableItem: audioView
    }

    UpdateIcon {
        flickableItem: audioView
        onTriggered: update()
    }

    Updater {
        id: updater

        canUpdate: client.online && status === PageStatus.Active
        count: 50

        function update(count, offset) {
            //TODO add support for audio searching
            if (searchQuery)
                return audioModel.searchAudio(searchQuery, count, offset);
            return audioModel.getAudio(owner.id, count, offset);
        }

        flickableItem: audioView
        header: SearchBar {
            id: searchBar

            onSearch: {
                audioModel.clear();
                searchQuery = searchingText;
                update();
            }
            onCancel: { searchQuery = ''; update(); }
        }
    }

    AudioModel {
        id: audioModel
    }

    Audio {
        id: player

        onStatusChanged:{
            if (player.status == Audio.Stalled){
                audioIndeterminate = true;
            }
            if (player.status == Audio.Buffered){
                audioIndeterminate = false;
            }
            if (player.status == Audio.EndOfMedia){
                playNext();
            }
        }
    }
}
