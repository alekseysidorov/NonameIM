// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0
import com.vk.api 1.0
import "../utils.js" as Utils
import "../attachments" as Attach
import "../components"

ImageItemDelegate {
    id: root

    property bool previewMode: true

    //wall post fields
    property QtObject from: model.from
    property QtObject owner: Utils.checkProperty(model.owner)
    property string body: model.body
    property string copyText: Utils.checkProperty(model.copyText, '')
    property variant attachments: model.attachments
    property date date: model.date
    property variant likes: Utils.checkProperty(model.likes)
    property variant comments: Utils.checkProperty(model.comments)

    width: parent ? parent.width : 600
    clickable: previewMode
    alternate: previewMode

    Component.onCompleted: {
        if (from)
            from.update();
        if (owner)
            owner.update();
    }

    onClicked: {
        if (postId) {
            var properties = {
                "from" : from,
                "postId" : postId,
                "postBody" : body,
                "postDate" : date,
                "commentsCount" : comments.count,
                "canPost" : comments.can_post,
                "attachments" : attachments,
                "likes" : function() { return likes },
                "reposts" : function() { return reposts },
                "wall" : ListView.view.model
            }
            pageStack.push(appWindow.createPage("subpages/CommentsPage.qml"), properties)
        }
    }
    imageSource: from.photoSource

    Component {
        id: textComponent
        Label {
            id: copyLabel
            width: parent.width
            elide: Text.ElideRight
            wrapMode: Text.Wrap
            font.pixelSize: appWindow.smallFontSize
        }
    }

    Component {
        id: retweetComponent

        Item {
            id: retweet

            anchors {
                left: parent.left
                right: parent.right
            }
            height: retweetImg.height

            Image {
                id : retweetImg
                anchors.left: parent.left
                anchors.leftMargin: 6
                source: "../images/ic_retweet_up.png"
            }

            Label {
                id: retweetLabel

                anchors.left: retweetImg.right
                anchors.leftMargin: 6
                anchors.right: parent.right
                anchors.rightMargin: 6
                anchors.verticalCenter: retweetImg.verticalCenter

                text: owner.name
                font.pixelSize: appWindow.normalFontSize
                elide: Text.ElideRight
                color: "#2b497a"
            }
        }
    }

    Loader {
        width: parent.width

        onLoaded: {
            item.text = function() { return from.name; }
            item.maximumLineCount = 2;
            item.color = "#2b497a";
        }

        sourceComponent: previewMode ? textComponent : null
    }

    Loader {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: 2 * mm

        onLoaded: {
            item.text = function() { return copyText }
            item.maximumLineCount = previewMode ? 3 : 0;
        }

        sourceComponent: copyText ? textComponent : null
    }

    Loader {
        width: parent.width
        sourceComponent: root.owner ? retweetComponent : null
    }

    Label {
        id: descriptionLabel
        width: parent.width
        text: body
        elide: Text.ElideRight
        wrapMode: Text.Wrap
        maximumLineCount: previewMode ? 6 : 0
        font.pixelSize: appWindow.smallFontSize
    }

    Attach.View {
        model: attachments
    }

    Loader {
        sourceComponent: previewMode ? likeIndicator : null

        onLoaded: {
            item.parent = parent;
        }
    }

    Component {
        id: likeIndicator
        PostInfo {
            anchors {
                left: parent.left
                right: parent.right
            }
            likes: root.likes ? root.likes.count : 0
            comments: root.comments ? root.comments.count : 0
            date: model.date
        }
    }
}
