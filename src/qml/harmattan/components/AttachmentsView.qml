import QtQuick 1.1
import "../attachments"

Column {
    id: root
    property alias photos: photoViewer.model
    property alias links: linksViewer.model

    width: parent ? parent.width : 300

    PhotoViewer {
        id: photoViewer
        imageWidth: 100
        columns: 4
    }

    Links {
        id: linksViewer
    }
}
