var notifyStack = []

function push(info)
{
    notifyStack.push(info)
}

function pop()
{
    return notifyStack.pop()
}

function top()
{
    return notifyStack[0]
}

function deep()
{
    return notifyStack.length
}

function clear()
{
    notifyStack = []
}
