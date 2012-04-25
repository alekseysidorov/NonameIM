import QtQuick 1.1
import com.nokia.meego 1.0
import "../delegates"

Page {
    id: page
    property alias model: photoView.model
    property alias currentIndex: photoView.currentIndex

    Rectangle {
        anchors.fill: parent
        color: "black"
    }

    ListView {
        id: photoView

        clip: true
        anchors.fill: parent
        highlightMoveSpeed: -1
        spacing: 15
        orientation: ListView.Horizontal
        snapMode: ListView.SnapOneItem
        cacheBuffer: page.height * 2
        delegate: PhotoDelegate {}
    }
}
