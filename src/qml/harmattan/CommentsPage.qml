import QtQuick 1.1
import com.nokia.meego 1.0
import com.vk.api 0.1
import "utils.js" as Utils

Page {
    id: page

    property QtObject from
    property alias postId : commentsModel.postId
    property string postBody : qsTr("Unknown post!")
    property date postDate

    function update() {
        if (client.online)
            commentsModel.getComments()
    }

    orientationLock: PageOrientation.LockPortrait

    PageHeader {
        id: header
        text: qsTr("Comments")
        backButton: true
        onBackButtonClicked: pageStack.pop()

    }

    ListView {
        id: commentsView;

        function __firstItemPos() {
            return positionViewAtIndex(0, ListView.End)
        }

        onCountChanged: __firstItemPos()
        onHeightChanged: __firstItemPos()

        width: parent.width;
        anchors.top: header.bottom;
        anchors.bottom: parent.bottom;
        model: commentsModel
        header: Column {
            width: parent.width
            ContactHeader {
                contact: from
                comment: Utils.formatDate(postDate)
            }
            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                width:  parent.width - 24;
                text: postBody.concat("<br />")
                textFormat: Text.RichText
                font.pixelSize: appWindow.smallFontSize
                Rectangle {
                    width: parent.width
                    anchors.bottom: parent.bottom
                    height: 1;
                    color: "#c0c0c0";
                }
            }
        }
        highlight: HighlightDelegate {}
        delegate: CommentsDelegate {}
        currentIndex: -1
    }

    CommentsModel {
        id: commentsModel
        contact: from
    }

    ScrollDecorator {
        flickableItem: commentsView;
    }

    UpdateIcon {
        flickableItem: commentsView
        onTriggered: update()
    }
}
