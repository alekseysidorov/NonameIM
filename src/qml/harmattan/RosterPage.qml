import QtQuick 1.1
import com.nokia.meego 1.0

Page {
    id: friendsPage

    Header {
        id: header
        text: qsTr("Friends")
    }

    tools: commonTools

    ListView {
        id: rosterView;
        width: parent.width;
        anchors.top: header.bottom;
        anchors.bottom: parent.bottom;
        highlight: HighlightDelegate {}
        header: SearchBar {
            id: searchBar
        }
    }

    ScrollDecorator {
        flickableItem: rosterView;
    }
}
