import QtQuick 1.1
import com.nokia.meego 1.0

Sheet {
    id: root

    property alias text: inputArea.text

    property variant attachments
    property bool canAttach: false

    onStatusChanged: {
        if (status === DialogStatus.Open)
            inputArea.focus = true
    }

    acceptButtonText: qsTr("Post")
    rejectButtonText: qsTr("Cancel")
    content: Flickable {
        id: flickable

        anchors.fill: parent
        contentHeight: column.height
        contentWidth: column.width
        flickableDirection: Flickable.VerticalFlick

        Column {
            id: column
            width: flickable.width
            spacing: appWindow.defaultSpacing

            TextArea {
                id: inputArea

                width: parent.width
                placeholderText: qsTr("Enter Text Here")
                focus: root.visible
            }

            Label {
                text: qsTr("Attachments:")
                visible: canAttach
            }

            Label {
                text: "TODO"
                visible: canAttach
            }
        }
    }
}
