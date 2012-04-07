import QtQuick 1.1
import com.nokia.meego 1.0
import com.vk.api 0.1

Page {
    id: page

    property QtObject from
    property alias postId : commentsModel.postId
    property string postBody : qsTr("Unknown post!")

    function update() {
        if (client.online)
            commentsModel.getComments()
    }

    tools: commonTools
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
        header: Label {
            width: parent.width
            text: postBody
        }
        highlight: HighlightDelegate {}
        delegate: WallDelegate {}
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
