import QtQuick 1.1
import com.nokia.meego 1.0

Page {
    id: wallPage
    property QtObject contact

    Header {
        id: header
        text: qsTr("Wall")

    }

    tools: commonTools
}
