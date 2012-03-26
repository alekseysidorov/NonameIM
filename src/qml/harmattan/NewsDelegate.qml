// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0

Item {
    id: delegate
    width: parent ? parent.width : 600
    height: 150

    Label {
        anchors.left: parent.left
        anchors.right: arrow.left
        anchors.rightMargin: 6
        anchors.top: parent.top
        anchors.bottom: hr.top
        text: item.text.substr(0, 160) + "..."
        wrapMode: Text.WordWrap
        elide: Text.ElideRight
    }

    Image {
        id: arrow;
        opacity: 0.5;
        source: "image://theme/icon-m-common-drilldown-arrow" + (theme.inverted ? "-inverse" : "")
        anchors.right: parent.right;
        anchors.rightMargin: 10;
        anchors.verticalCenter: parent.verticalCenter;
    }

    Rectangle {
        id: hr
        anchors.bottom: delegate.bottom
        anchors.bottomMargin: 1
        width:  parent.width;
        height: 1;
        color: "#c0c0c0";
    }
}
