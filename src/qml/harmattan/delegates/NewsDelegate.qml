// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0
import "../utils.js" as Utils

ItemDelegate {
    id: itemDelegate

    imageSource: Utils.getContactPhotoSource(source)
    item: data

    onClicked: {
        if (postId) {
            var properties = {
                "from" : source,
                "postId" : postId,
                "postBody" : body,
                "postDate" : date,
                "commentsCount" : comments.count,
                "canPost" : comments.can_post
            }
            pageStack.push(appWindow.createPage("CommentsPage.qml"), properties)
        }
    }

    Component.onCompleted: {
        console.log(attachments.length)
        for (var i = 0; i !== attachments.length; i++) {
            var attachment = attachments[i]
            console.log(attachment.type)
        }

    }

    Column {
        id: data

        Label {
            id: titleLabel
            text: source.name
            width: parent.width
            color: "#2b497a"

            font.pixelSize: appWindow.normalFontSize
        }
        Label {
            id: activityLabel

            text: Utils.format(body, 160)
            width: parent.width
            font.pixelSize: appWindow.smallFontSize

        }
        Column {
            width: parent.width
            Row {
                spacing: 9

                Label {
                    id: dateLabel
                    text: Utils.formatDate(date)
                    font.pixelSize: appWindow.tinyFontSize
                    color: "#777"
                }

                Loader {
                    id: likesLoader

                    onLoaded: {
                        item.imageSource = "../images/ic_like_up.png"
                        item.text = likes.count
                    }

                    sourceComponent: likes ? countComponent : null
                }
                Loader {
                    id: commentsLoader

                    onLoaded: {
                        item.imageSource = "../images/ic_comment_up.png"
                        item.text = comments.count
                    }

                    sourceComponent: comments ? countComponent : null
                }
            }
        }
    }

    Component {
        id: countComponent

        Row {
            property alias imageSource : likeImg.source
            property alias text : label.text

            spacing: 3

            Image {
                id: likeImg
            }
            Label {
                id: label
                font.pixelSize: appWindow.tinyFontSize
                color: "#777"
            }
        }
    }
}
