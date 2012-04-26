import QtQuick 1.1
import com.nokia.meego 1.0
import com.vk.api 0.1
import "utils.js" as Utils
import "delegates"
import "components"
import "draft"

Page {
    id: profilePage
    property QtObject contact

    function update() {
        if (client.online) {
            wallModel.contact = contact //hack
            wallModel.getLastPosts()
            contact.update()
            appWindow.addTask(qsTr("Getting profile..."), wallModel.requestFinished)
            photoModel.getAll(contact.id)
        }
    }

    PageHeader {
        id: header
        text: contact ? contact.name  : qsTr("")
        backButton: true
        onBackButtonClicked: pageStack.pop()
    }

    Component {
        id: heading
        Column {
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

    WallModel {
        id: wallModel
        contact: contact
    }

    PhotoModel {
        id: photoModel
    }

    ListView {
        id: wallView;

        function __firstItemPos() {
            return positionViewAtIndex(0, ListView.End)
        }

        onCountChanged: __firstItemPos()
        onHeightChanged: __firstItemPos()

        width: parent.width;
        anchors.top: header.bottom;
        anchors.bottom: parent.bottom;
        model: wallModel
        header: heading
        highlight: HighlightDelegate {}
        delegate: WallDelegate {}
        currentIndex: -1
        cacheBuffer: 24
    }

    ScrollDecorator {
        flickableItem: wallView;
    }

    UpdateIcon {
        flickableItem: wallView
        onTriggered: update()
    }
}
