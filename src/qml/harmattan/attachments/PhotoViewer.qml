// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

GridView {
    id: grid

    width: parent ? parent.width : 600
    height: 200
    clip: true
    flickableDirection: Flickable.HorizontalFlick
    highlightFollowsCurrentItem: false

    delegate: Image {
        id: image

        width: grid.cellWidth; height: grid.cellHeight
        source: modelData.src
    }
}

