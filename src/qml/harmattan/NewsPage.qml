import QtQuick 1.1
import com.nokia.meego 1.0

Page {
    id: newsPage

    Header {
        id: header
        text: qsTr("News")
    }

    UpdateIcon {
        id: updateIcon
        y: -newsList.visibleArea.yPosition * Math.max(newsList.contentHeight, newsList.height);
        anchors.left: parent.left;
        anchors.leftMargin: 35;

        onTriggered: client.newsModel.update()
    }

    ListView {
        id: newsList
        anchors.top: header.bottom
        anchors.bottom: parent.bottom
        width: parent.width
        model: client.newsModel
        delegate: NewsDelegate {}
    }

    ScrollDecorator {
        flickableItem: newsList
    }

    tools: commonTools

    onVisibleChanged: {
        //if (visible)
        //    client.newsModel.update()
    }
}
