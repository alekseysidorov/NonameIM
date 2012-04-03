.pragma library

function replaceURLWithHTMLLinks(text) {
    var exp = /(\b(https?|ftp|file):\/\/([-A-Z0-9+&@#%?=~_|!:,.;]*)([-A-Z0-9+&@#%?\/=~_|!:,.;]*)[-A-Z0-9+&@#\/%=~_|])/ig;
    return text.replace(exp, "<a href='$1' target='_blank'>$3</a>");
}

function format(str) {
    var tmp = replaceURLWithHTMLLinks(str);
    return tmp.replace("<br>"," ")
}
