// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.extras 1.1
import "NotifyStack.js" as NotifyStack

InfoBanner {
    id: banner

    function push(text, iconSource, callback) {
        var item = {
            "iconSource" : iconSource,
            "text" : text,
            "callback" : callback
        }
        __setInfo(item)
        NotifyStack.push(item)
        banner.show()
    }

    function pop() {
        var item = NotifyStack.pop()
        if (item.callback)
            item.callback()
        item = NotifyStack.top()
        console.log(NotifyStack.deep())
        if (item)
            __setInfo(item)
        else
            banner.hide()
    }

    function __setInfo(item)
    {
        banner.text = item.text
        banner.iconSource = item.iconSource
    }

    timerEnabled: false

    MouseArea {
        anchors.fill: parent
        onClicked: {
            banner.pop()
        }
    }
}
