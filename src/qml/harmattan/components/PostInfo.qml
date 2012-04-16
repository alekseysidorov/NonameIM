import QtQuick 1.1
import com.nokia.meego 1.0
import "../utils.js" as Utils

Row {
    id: infoRole

    property variant likes
    property variant comments
    property date date

    width: parent ? parent.width : 300
    spacing: 9

    Label {
        id: dateLabel
        text: Utils.formatDate(date)
        font.pixelSize: appWindow.tinyFontSize
        color: "#777"
    }

    Row {
        visible: typeof(likes) !== "undefined"
        spacing: 3

        Image {
            id: likeImg
            source: "../images/ic_like_up.png"
        }
        Label {
            id: likeLabel
            font.pixelSize: appWindow.tinyFontSize
            color: "#777"
            text: likes ? likes.count : 0
        }
    }

    Row {
        visible: typeof(comments) !== "undefined"
        spacing: 3

        Image {
            id: commentsImg
            source: "../images/ic_comment_up.png"
        }
        Label {
            id: commentsLabel
            font.pixelSize: appWindow.tinyFontSize
            color: "#777"
            text: comments ? comments.count : 0
        }
    }
}
