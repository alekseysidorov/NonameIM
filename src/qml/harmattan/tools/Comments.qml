import QtQuick 1.1
import com.nokia.meego 1.0

ToolBarLayout {

    id: root

    property bool isLiked: false
    property bool isRetweet: false
    property bool canPost: true

    Row {
        anchors.centerIn: parent
        spacing: parent.width / 3 - appWindow.defaultMargin

        Image {
            id: likeImg
            source: isLiked ? "images/ic_post_like_down.png" : "images/ic_post_like_up.png"
            MouseArea {
                anchors.fill: parent
                onClicked: {
                }
            }
        }

        Image {
            id: retweetImg
            source: isRetweet && isLiked ? "images/ic_post_retweet_done.png" : "images/ic_post_retweet_up.png"
            MouseArea {
                anchors.fill: parent
                onClicked: {
                }
            }
        }

        Image {
            id: commentImg
            source: canPost ? "images/ic_post_comment_up.png" : "images/ic_post_comment_disabled.png"
            enabled: canPost
            MouseArea {
                anchors.fill: parent
                onClicked: {
                }
            }
        }
    }
}
