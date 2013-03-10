import QtQuick 1.1
import com.vk.api 1.0

Loader {
    property int type
    property Component component

    enabled: allowedTypes.indexOf(type) !== -1

    onLoaded: {
        item.model = function() { return model[type]; };
    }

    sourceComponent: enabled && model[type] ? component : null
}
