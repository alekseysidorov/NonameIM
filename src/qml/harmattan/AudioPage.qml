import QtQuick 1.1
import com.nokia.meego 1.0
import com.vk.api 0.1
import "delegates"
import "components"

Page {
    id: audioPage
    property QtObject owner: client.me
    property QtObject __client: client //workaround

    function update() {
        if (client.online)
            audioModel.get(client.me)
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
        delegate: AudioDelegate {}
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
}
