.pragma library

function replaceURLWithHTMLLinks(text) {
    var exp = /(\b(https?|ftp|file):\/\/([-A-Z0-9+&@#%?=~_|!:,.;]*)([-A-Z0-9+&@#%?\/=~_|!:,.;]*)[-A-Z0-9+&@#\/%=~_|])/ig;
    return text ? text.replace(exp, "<a href='$1' target='_blank'>$3</a>")
                : "";
}

function convertSpecialChars(str)
{
    //TODO use normal function
    str = str.replace(/&quot;/g,'"');
    str = str.replace(/&amp;/g,"&");
    str = str.replace(/&lt;/g,"<");
    str =  str.replace(/&gt;/g,">");
    str =  str.replace(/&#33;/g,"!");
    return str
}

function format(str, maxCharCount) {   
    var tmp = convertSpecialChars(str)    
    if (maxCharCount) {
        tmp = clip(tmp, maxCharCount)
        tmp = tmp.replace("<br>"," ")
    } else
        tmp = replaceURLWithHTMLLinks(tmp)
    return tmp
}

function getContactPhotoSource(contact) {
    return (contact && contact.photoSource) ? contact.photoSource
                                            : "../images/user.png"
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

function checkProperty(value, def) {
    if (def === undefined)
        def = null;
    return value === undefined ? def : value;
}

