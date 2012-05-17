// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0
import com.vk.api 0.1
import "../utils.js" as Utils
import "../attachments"
import "../components"

Item {
    id: root

    function getMinHeight() {
        var avatarHeight = avatar.y + avatar.height + appWindow.defaultSpacing
        var itemHeight = item ? item.y + item.height + appWindow.defaultSpacing : 0
        return Math.max(avatarHeight, itemHeight, 200)
    }

    width: parent ? parent.width : 600
    height: getMinHeight()

    Avatar {
        id: avatar

        onClicked: {
            if (imageUrl)
                appWindow.showPhoto(imageUrl)
        }

        anchors.left: parent.left
        anchors.leftMargin: 12
        anchors.top: item.top
        anchors.topMargin: appWindow.defaultSpacing/2
    }

    Column {
        id: item

        anchors.top: root.top
        anchors.topMargin: 12
        anchors.left: avatar.right
        anchors.leftMargin: 12
        anchors.right: arrow.left

        spacing: 6

        Label {
            id: titleLabel
            text: source.name
            width: parent.width
            color: "#2b497a"

            font.pixelSize: appWindow.normalFontSize
        }

        Item {
            id: retweet

            visible: typeof(ownerName) !== "undefined"
            width: parent.width
            height: childrenRect.height

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

                text: ownerName ? ownerName : ""
                font.pixelSize: appWindow.smallFontSize
                elide: Text.ElideRight
                color: "#2b497a"
            }
        }

        Label {
            id: activityLabel

            text: Utils.format(body, 160)
            width: parent.width
            font.pixelSize: appWindow.smallFontSize

        }

        PhotoViewer {
            model: attachments[Attachment.Photo]
        }

        Links {
            model: attachments[Attachment.Link]
        }

        PostInfo {
            likes: model.likes
            comments: model.comments
            date: model.date
        }
    }

    Image {
        id: arrow
        opacity: 0.5
        source: "image://theme/icon-m-common-drilldown-arrow" + (theme.inverted ? "-inverse" : "")
        anchors.right: parent.right
        anchors.rightMargin: visible ? 12 : 0
        anchors.verticalCenter: parent.verticalCenter
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            if (postId) {
                var properties = {
                    "from" : source,
                    "postId" : postId,
                    "postBody" : body,
                    "postDate" : date,
                    "commentsCount" : comments.count,
                    "canPost" : comments.can_post,
                    "attachments" : attachments
                }
                pageStack.push(appWindow.createPage("subpages/CommentsPage.qml"), properties)
            }
        }
    }

    Rectangle {
        id: hr

        anchors.bottom: root.bottom
        width:  parent.width
        height: 1
        color: "#c0c0c0"
    }
}

//ItemDelegate {
//    id: itemDelegate

//    imageSource: Utils.getContactPhotoSource(source)
//    item: data

//    onClicked: {
//        if (postId) {
//            var properties = {
//                "from" : source,
//                "postId" : postId,
//                "postBody" : body,
//                "postDate" : date,
//                "commentsCount" : comments.count,
//                "canPost" : comments.can_post,
//                "attachments" : attachments
//            }
//            pageStack.push(appWindow.createPage("subpages/CommentsPage.qml"), properties)
//        }
//    }

//    Column {
//        id: data
//        spacing: 6

//        Label {
//            id: titleLabel
//            text: source.name
//            width: parent.width
//            color: "#2b497a"

//            font.pixelSize: appWindow.normalFontSize
//        }

//        Item {
//            id: retweet

//            visible: typeof(ownerName) !== "undefined"
//            width: parent.width
//            height: childrenRect.height

//            Image {
//                id : retweetImg
//                anchors.left: parent.left
//                anchors.leftMargin: 6
//                source: "../images/ic_retweet_up.png"
//            }

//            Label {
//                id: retweetLabel

//                anchors.left: retweetImg.right
//                anchors.leftMargin: 6
//                anchors.right: parent.right
//                anchors.rightMargin: 6
//                anchors.verticalCenter: retweetImg.verticalCenter

//                text: ownerName ? ownerName : ""
//                font.pixelSize: appWindow.smallFontSize
//                elide: Text.ElideRight
//                color: "#2b497a"
//            }
//        }

//        Label {
//            id: activityLabel

//            text: Utils.format(body, 160)
//            width: parent.width
//            font.pixelSize: appWindow.smallFontSize

//        }

//        PhotoViewer {
//            model: attachments[Attachment.Photo]
//        }

//        Links {
//            model: attachments[Attachment.Link]
//        }

//        PostInfo {
//            likes: model.likes
//            comments: model.comments
//            date: model.date
//        }
//    }
//}
