import QtQuick 1.1
import com.nokia.meego 1.0
import com.vk.api 1.0
import "delegates"
import "components"

Page {
    id: friendsPage

    function update() {
        if (client.online) {
            client.roster.sync()
        }
    }

    onStatusChanged: {
        if (status === PageStatus.Active)
            update()
    }

    tools: commonTools
    orientationLock: PageOrientation.LockPortrait

    PageHeader {
        id: header
        text: qsTr("Friends")
        onClicked: rosterView.positionViewAtBeginning()
    }

    BuddyModel {
        id: contactsModel
        roster: client.roster
    }

    ItemView {
        id: rosterView
        width: parent.width
        anchors.top: header.bottom
        anchors.bottom: parent.bottom
        model: contactsModel
        highlight: HighlightDelegate {}
        delegate: ContactDelegate {}
        currentIndex: -1

        //section.property: "statusString"
        //section.delegate: Label {
        //    anchors.horizontalCenter: parent.horizontalCenter
        //    text: section
        //    color: "#777"
        //}

        header: SearchBar {
            id: searchBar

            onSearch: contactsModel.filterByName = searchBar.searchingText
            onCancel: contactsModel.filterByName = ""
        }
    }

    ScrollDecorator {
        flickableItem: rosterView
    }

    Connections {
        target: client
    }
}
