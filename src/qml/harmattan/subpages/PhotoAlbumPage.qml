import QtQuick 1.1
import com.nokia.meego 1.0
import "../delegates"
import "../components"

Page {
    id: page
    property alias model: photoView.model
    property alias title: header.text

    PageHeader {
        id: header
        text: qsTr("Photos")
        backButton: true
        onBackButtonClicked: pageStack.pop()
    }

    GridView {
        id: photoView
        //opacity: page.status === PageStatus.Active

        cellWidth: 106
        cellHeight: 106

        clip: true
        anchors.top: header.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right

        anchors.leftMargin: 12
        anchors.rightMargin: 12
        anchors.topMargin: 12
        anchors.bottomMargin: 12

        cacheBuffer: page.height * 2
        delegate: Image {
            source: src
            width: 100
            height: 100
            fillMode: Image.PreserveAspectCrop
            clip: true

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    //simple hack
                    var photos = []
                    for (var i = 0; i !== page.model.count; i++)
                        photos.push(page.model.get(i))

                    var properties = {
                        "model" : photos,
                        "currentIndex" : index
                    }
                    appWindow.pageStack.push(appWindow.createPage("subpages/PhotoPage.qml"), properties)
                }
            }
        }
    }
}
