import QtQuick 1.1
import com.nokia.meego 1.0
import "../utils.js" as Utils

ItemDelegate {
    id: itemDelegate

    function __createProfilePage()
    {        
        return
    }
    onClicked: appWindow.showProfile(model.contact)

    item: data
    imageSource: Utils.getContactPhotoSource(contact)

    Column {
        id: data

        Label {
            id: name
            text: contact.name
            width: parent.width
        }
        Label {
            id: activity
            text: contact.activity
            width: parent.width
            elide: Text.ElideRight
            color: "#777"
            font.pixelSize: name.font.pixelSize * 0.8

        }
    }
}
