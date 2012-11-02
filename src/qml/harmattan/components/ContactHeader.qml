// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0
import com.vk.api 1.0
import "../utils.js" as Utils

TitleBar {
    id: root
    height: 110

    property QtObject contact
    property alias comment: comment.text
    property int __spacing: 6

    Avatar {
        id: avatar

        width: 80
        height: 80

        anchors.left: parent.left
        anchors.leftMargin: 12
        anchors.top: item.top
        anchors.topMargin: __spacing/2
        source: Utils.getContactPhotoSource(contact)

        MouseArea {
            anchors.fill: parent
            onClicked: {
                var properties = {
                    "source" : contact.photoSource(Contact.PhotoSizeBig)
                }
                appWindow.createPage("subpages/SinglePhotoPage.qml", properties)
            }
        }
    }

    Image {
        id: arrow;
        opacity: 0.5;
        source: "image://theme/icon-m-common-drilldown-arrow" + (theme.inverted ? "-inverse" : "")
        anchors.right: parent.right;
        anchors.rightMargin: visible ? 12 : 0;
        anchors.verticalCenter: parent.verticalCenter;
    }

    Column {
        id: item

        anchors.top: root.top
        anchors.topMargin: 12
        anchors.left: avatar.right
        anchors.leftMargin: 12
        anchors.right: arrow.left
        anchors.bottom: avatar.bottom

        spacing: __spacing

        Label {
            id: title

            width: parent.width
            text: contact ? contact.name : qsTr("Title")
            font.bold: true
            font.pixelSize: 25
            elide: Text.ElideRight
        }
        Label {
            id: comment

            width: parent.width
            text: Utils.formatDate()
            color: "#505050";
            font.pixelSize: 23;
            elide: Text.ElideRight
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: appWindow.showProfile(contact)
    }
}
