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
    property int imageWidth: 75

    //width: parent ? parent.width : 600
    clip: true
    spacing: 3
    columns: 3

    Repeater {
        id: repeater

        delegate: Image {
            id: image

            opacity: status === Image.Ready ? 1 : 0.1 //hack for constant size
            source: modelData.src_small ? modelData.src_small : modelData.src
            fillMode: Image.PreserveAspectCrop
            clip: true
            //width: status === Image.Ready ? imageWidth : 0
            width: imageWidth
            height: width

            //Behavior on opacity {
            //    NumberAnimation {
            //        easing.type: Easing.InOutQuad
            //    }
            //}

            MouseArea {

                onClicked: {
                    var properties = {
                        "model" : repeater.model,
                        "currentIndex" : index
                    }
                    appWindow.pageStack.push(appWindow.createPage("subpages/PhotoPage.qml"), properties)
                }

                anchors.fill: parent
            }
        }
    }

}
