import QtQuick 1.1
import com.nokia.meego 1.0
import "../utils.js" as Utils

Row {
    id: infoRole

    property alias likes: likeLabel.text
    property alias comments: commentsLabel.text
    property date date

    width: parent ? parent.width : 300
    height: 24
    spacing: 9

    Label {
        id: dateLabel
        text: Utils.formatDate(date)
        font.pixelSize: appWindow.tinyFontSize
        color: "#777"
    }

    Row {
        visible: likes
        spacing: 3

        Image {
            id: likeImg
            source: "../images/ic_like_up.png"
        }
        Label {
            id: likeLabel
            font.pixelSize: appWindow.tinyFontSize
            color: "#777"
        }
    }

    Row {
        visible: comments
        spacing: 3

        Image {
            id: commentsImg
            source: "../images/ic_comment_up.png"
        }
        Label {
            id: commentsLabel
            font.pixelSize: appWindow.tinyFontSize
            color: "#777"
        }
    }
}
