import QtQuick 1.1
import com.nokia.meego 1.0
import "delegates"
import "components"

Page {
    id: audioPage

    tools: commonTools
    orientationLock: PageOrientation.LockPortrait

    PageHeader {
        id: header
        text: qsTr("Audio")
    }
}
