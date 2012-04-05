import QtQuick 1.1
import com.nokia.meego 1.0

Page {
    id: newsPage
    tools: commonTools

    onVisibleChanged: {
        //if (visible)
        //    client.newsModel.update()
    }

    Header {
        id: header
        text: qsTr("News")
    }

    UpdateIcon {
        id: updateIcon
        flickableItem: newsList
    }

    ListView {
        id: newsList
        anchors.top: header.bottom
        anchors.bottom: parent.bottom
        width: parent.width
        delegate: NewsDelegate {}
    }

    ScrollDecorator {
        flickableItem: newsList
    }
}
