import QtQuick 1.1
import com.nokia.meego 1.0
import com.vk.api 0.1
import "utils.js" as Utils

Page {
    id: profilePage
    property QtObject contact

    function update() {
        if (client.online) {
            wallModel.contact = contact //hack
            wallModel.getLastPosts()
            contact.update();
        }
    }

    PageHeader {
        id: header
        text: contact ? contact.name : qsTr("")
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
                    id: avatar;
                    width: 100
                    height: 100

                    anchors.top: parent.top;
                    anchors.topMargin: 10;
                    anchors.left: parent.left;
                    anchors.leftMargin: 10;
                    source: contact ? contact.photoSource : "images/user.png";
                }

                Label {
                    id: activity

                    anchors.top: avatar.top;
                    anchors.left: avatar.right;
                    anchors.leftMargin: 10;
                    anchors.right: parent.right
                    anchors.bottom: status.bottom

                    text: Utils.format(contact ? contact.activity : qsTr("Unknown"))
                    textFormat: Text.RichText
                    elide: Text.ElideRight
                    color: "#666";
                }

                Label {
                    id: status

                    anchors.top: avatar.bottom
                    anchors.horizontalCenter: avatar.horizontalCenter

                    function __statusStr(status) {
                        switch (status) {
                        case Contact.Online:
                            return qsTr("Online")
                        case Contact.Offline:
                            return qsTr("Offline")
                        case Contact.Away:
                            return qsTr("away")
                        default:
                            return qsTr("Unknown")
                        }
                    }

                    text: __statusStr(contact ? contact.status : -1)
                    font.pixelSize: 0.8 * activity.font.pixelSize
                    color: "#2b497a"
                }

                Button {
                    id: chatButton
                    text: qsTr("Open chat")

                    anchors.left: parent.left;
                    anchors.leftMargin: 12;
                    anchors.right: parent.right;
                    anchors.rightMargin: 12;
                    anchors.top: status.bottom;

                    onClicked: {
                        chatPage.contact = contact;
                        pageStack.push(chatPage)
                    }
                }
            }
            TitleBar {
                id: photoBar
                height: 0
                visible: false
            }
            TitleBar {
                id: headerBar
                height: label.height + 6

                Label {
                    id: label
                    anchors.left: parent.left;
                    anchors.leftMargin: 12;
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width
                    color: "#505050";
                    font.pixelSize: 15;
                    font.bold: true;
                    text: qsTr("Wall");
                }
            }

        }
    }

    WallModel {
        id: wallModel
        contact: contact
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
