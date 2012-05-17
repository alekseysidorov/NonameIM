import QtQuick 1.1
import com.nokia.meego 1.0

TitleBar {
    id: photoBar
    property QtObject model : photoModel

    //visible: model.count
    height: photoRow.height + 12    

    Row {
        id: photoRow
        height: 80

        anchors.left: parent.left
        anchors.leftMargin: 12
        anchors.right: parent.right
        anchors.rightMargin: 12

        spacing: 12
        anchors.verticalCenter: parent.verticalCenter

        Repeater {
            id: repeater
            model: Math.min(photoBar.model.count, 5)

            Image {
                fillMode: Image.PreserveAspectCrop

                clip: true
                width: 75
                height: 75
                source: photoBar.model.get(index).src
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            var properties = {
                "model" : photoBar.model,
                "title" : qsTr("Album")
            }
            appWindow.pageStack.push(appWindow.createPage("subpages/PhotoAlbumPage.qml"), properties)
        }
    }
}
