import QtQuick 1.1
import com.nokia.meego 1.0
import "../components"

Rectangle {
    id: root

    property bool liked: false
    property bool retweeted: false
    property alias canPost: commentImg.enabled
    property alias canRetweet: retweetImg.enabled
    property alias canLike: likeImg.enabled


    signal retweet(bool set)
    signal like(bool set)
    signal post

    color: "#C3C5C9"
    width: parent ? parent.width : 200
    height: 65 //TODO use toolbar layouts height

    Row {
        anchors.centerIn: parent
        spacing: parent.width / 3 - appWindow.defaultMargin

        Image {
            id: likeImg
            source: liked ? "../images/ic_post_like_down.png" : "../images/ic_post_like_up.png"
            MouseArea {
                anchors.fill: parent
                onClicked: like(!liked)
            }
        }

        Image {
            id: retweetImg
            source: retweeted && liked ? "../images/ic_post_retweet_done.png" : "../images/ic_post_retweet_up.png"
            MouseArea {
                anchors.fill: parent
                onClicked: retweet(!retweeted)
            }
        }

        Image {
            id: commentImg
            source: canPost ? "../images/ic_post_comment_up.png" : "../images/ic_post_comment_disabled.png"
            enabled: canPost
            MouseArea {
                anchors.fill: parent
                onClicked: if(canPost) post()
            }
        }
    }

    Rectangle {
        width:  parent.width;
        height: 1;
        anchors.top: parent.top;
        color: "#868686"
    }
}
