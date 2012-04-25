import QtQuick 1.1
import com.nokia.meego 1.0
import "../ios" as Ios

Item {
    id: root

    Component.onCompleted: {
        console.log(modelData)
    }

    width: ListView.view.width
    height: ListView.view.height

    Image {
        id: photo
        anchors.fill: parent
        opacity: 0
        smooth: true
        fillMode: Image.PreserveAspectFit
        source: modelData.src_big
        Behavior on opacity {
            NumberAnimation {
                easing.type: Easing.InOutQuad
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            pageStack.pop()
        }
    }

    Ios.BusyIndicator {
        id: busyIndicator
        platformStyle: BusyIndicatorStyle {
            size: "large"
            inverted: true
        }
        anchors.centerIn: parent
        running: photo.status != Image.Ready
        visible: photo.status != Image.Ready
    }

    states: [
        State {
            name: "Show"
            when: photo.status == Image.Ready
            PropertyChanges {
                target: photo
                opacity: 1
            }
        }
    ]
}
