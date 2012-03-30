import QtQuick 1.1
import com.nokia.meego 1.0
import com.vk.api 0.1

Page {
    id: friendsPage

    Header {
        id: header
        text: qsTr("Friends")
    }

    tools: commonTools

    ContactsModel {
        id: contactsModel
        roster: client.roster
    }

    ListView {
        id: rosterView;
        width: parent.width;
        anchors.top: header.bottom;
        anchors.bottom: parent.bottom;
        model: contactsModel
        highlight: HighlightDelegate {}
        delegate: ContactDelegate {}
        currentIndex: -1;
        header: SearchBar {
            id: searchBar

            onSearch: contactsModel.filterByName = searchBar.searchingText;
            onCancel: contactsModel.filterByName = ""
        }
    }



    ScrollDecorator {
        flickableItem: rosterView;
    }

    Connections {
        target: client
        onIsOnlineChanged: {
            if (client.isOnline)
                client.roster.sync()
        }
    }

    onVisibleChanged: {
        if (visible && client.isOnline)
            client.roster.sync()
    }
}
