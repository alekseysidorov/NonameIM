import QtQuick 1.1
import com.nokia.meego 1.0
import com.vk.api 1.0
import "utils.js" as Utils
import "delegates"
import "components"
import "draft"

Page {
    id: profilePage
    property QtObject contact

    onContactChanged: wallModel.contact = contact //hack

    function update() {
        if (client.online) {
            contact.update();
            photoModel.getAll(contact.id);
            updater.update(updater.count, 0);
        }
    }

    PageHeader {
        id: header
        text: contact ? contact.name  : qsTr("")
        backButton: true
        onBackButtonClicked: pageStack.pop()
    }

    WallModel {
        id: wallModel
    }

    PhotoModel {
        id: photoModel
    }

    ListView {
        id: wallView;

        width: parent.width;
        anchors.top: header.bottom;
        anchors.bottom: parent.bottom;
        model: wallModel
        highlight: HighlightDelegate {}
        delegate: WallDelegate {}
        currentIndex: -1
        cacheBuffer: 100500
    }

    ScrollDecorator {
        flickableItem: wallView;
    }

    UpdateIcon {
        flickableItem: wallView
    }

    Updater {
        id: updater

        canUpdate: client.online && status === PageStatus.Active

        function update(count, offset) {
            return wallModel.getPosts(count, offset);
        }

        flickableItem: wallView
        header: Column {
            width: parent ? parent.width : 600
            TitleBar {
                id: infoBar
                width: parent.width
                height: chatButton.y + chatButton.height + 6

                Avatar {
                    id: avatar

                    onClicked: {
                        if (contact)
                            appWindow.showPhoto(contact.photoSourceBig)
                    }

                    width: 100
                    height: 100

                    anchors.top: parent.top
                    anchors.topMargin: 10
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    source: contact ? contact.photoSource : "images/user.png"
                }

                Image {
                    id: statusImage
                    anchors.horizontalCenter: avatar.horizontalCenter
                    anchors.top: avatar.bottom
                    visible: contact ? contact.status !== Contact.Offline : false
                    source: "images/ic_online_up.png"
                }

                Label {
                    id: activity

                    anchors.top: avatar.top
                    anchors.left: avatar.right
                    anchors.leftMargin: 10
                    anchors.right: parent.right

                    text: Utils.format(contact ? contact.activity : qsTr("Unknown"), 160)
                    //elide: Text.ElideRight
                    color: "#666"
                }

                Button {
                    id: chatButton
                    text: qsTr("Open chat")

                    y: avatar.y + Math.max(activity.height, 12 + avatar.height) + appWindow.defaultMargin
                    anchors.left: parent.left
                    anchors.leftMargin: 12
                    anchors.right: parent.right
                    anchors.rightMargin: 12

                    onClicked: {
                        chatPage.contact = contact
                        pageStack.push(chatPage)
                    }
                }
            }

            PhotoBar {
                model: photoModel
            }

            TitleBar {
                id: headerBar
                height: label.height + 6

                Label {
                    id: label
                    anchors.left: parent.left
                    anchors.leftMargin: 12
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width
                    color: "#505050"
                    font.pixelSize: 15
                    font.bold: true
                    text: qsTr("Wall")
                }
            }
        }
    }
}
