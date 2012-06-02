// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.extras 1.1
import "NotifyStack.js" as NotifyStack

InfoBanner {
    id: banner
    visible: scale !== 0 //hack

    function push(item) {
        NotifyStack.push(item)
        __setInfo(item)
        banner.show()
    }

    function pop() {
        var item = __popItem()
        if (item.callback)
            item.callback()
    }

    function __setInfo(item)
    {
        banner.text = item.text
        banner.iconSource = item.iconSource ? item.iconSource : ""
    }

    function __popItem()
    {
        var item = NotifyStack.pop()
        var top = NotifyStack.top()
        if (top)
            __setInfo(top)
        else
            banner.hide()
        return item
    }

    onVisibleChanged: {
        if (!visible)
            NotifyStack.clear()
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            banner.pop()
        }
    }
}
