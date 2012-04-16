// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

//GridView {
//    id: grid

//    width: parent ? parent.width : 600
//    height: 200
//    clip: true
//    flickableDirection: Flickable.HorizontalFlick
//    highlightFollowsCurrentItem: false

//    delegate: Image {
//        id: image

//        width: grid.cellWidth; height: grid.cellHeight
//        source: modelData.src
//    }
//}

Grid {
    id: grid
    property alias model: repeater.model

    width: parent ? parent.width : 600
    clip: true
    spacing: 3
    columns: 3

    Repeater {
        id: repeater

        delegate: Image {
            id: image

            opacity: status === Image.Ready ? 1 : 0.1 //hack for constant size
            source: modelData.src
            fillMode: Image.PreserveAspectCrop
            clip: true
            width: 75
            height: width

            Behavior on opacity {
                NumberAnimation {
                    easing.type: Easing.InOutQuad;
                }
            }
        }
    }

}
