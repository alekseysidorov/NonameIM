// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0
import "../utils.js" as Utils
import "../attachments"

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
        console.log(">> photos: " + photos.length)
        console.log(">> links: " + links.length)
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

        Row {
            width: parent.width
            spacing: 9

            Label {
                id: dateLabel
                text: Utils.formatDate(date)
                font.pixelSize: appWindow.tinyFontSize
                color: "#777"
            }

            Loader {
                onLoaded: {
                    item.imageSource = "../images/ic_like_up.png"
                    item.text = likes.count
                }

                sourceComponent: likes ? countComponent : null
            }
            Loader {
                onLoaded: {
                    item.imageSource = "../images/ic_comment_up.png"
                    item.text = comments.count
                }

                sourceComponent: comments ? countComponent : null
            }
        }

        Loader {
            onLoaded: {
                item.model = photos
            }

            sourceComponent: photos.length ? photoViewer : null
        }

        Loader {
            onLoaded: {
                item.model = links
            }

            sourceComponent: links.length ? linksViewer : null
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

    Component {
        id: photoViewer

        PhotoViewer {

        }
    }
    Component {
        id: linksViewer

        Links {

        }
    }
}
