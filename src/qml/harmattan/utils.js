.pragma library

function replaceURLWithHTMLLinks(text) {
    var exp = /(\b(https?|ftp|file):\/\/([-A-Z0-9+&@#%?=~_|!:,.;]*)([-A-Z0-9+&@#%?\/=~_|!:,.;]*)[-A-Z0-9+&@#\/%=~_|])/ig;
    return text ? text.replace(exp, "<a href='$1' target='_blank'>$3</a>")
                : "";
}

function format(str, maxCharCount) {
    var tmp = clip(str)
    tmp = replaceURLWithHTMLLinks(tmp);
    //if (maxCharCount)
    //    tmp = clip(tmp, maxCharCount)
    return tmp.replace("<br>"," ")
}

function getContactPhotoSource(contact) {
    return (contact && contact.photoSource) ? contact.photoSource
                                            : "images/user.png"
}

function formatDate(date)
{
    //TODO add year and mounth format for old and future dates!
    return Qt.formatDateTime(date, "dddd in hh:mm");
}

function clip(str, maxCharCount)
{
    if (!maxCharCount)
        maxCharCount = 160 //standart sms format
    if (!str || str.length < maxCharCount)
        return str
    maxCharCount = maxCharCount - 3
    var index = -1;
    do {
        index = str.indexOf(" ", index + 1)
    } while (index < maxCharCount && index != -1)
    if (index === -1)
        str = str.substring(0, maxCharCount)
    else
        str = str.substring(0, index)
    str = str.concat("...")
    return str;
}
