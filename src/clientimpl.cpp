#include "clientimpl.h"
#include <QSettings>

Client::Client(QObject *parent) :
    vk::Client(parent)
{
    connect(this, SIGNAL(onlineStateChanged(bool)), this,
            SLOT(onOnlineStateChanged(bool)));

    QSettings settings;
    settings.beginGroup("connection");
    setLogin(settings.value("login").toString());
    setPassword(settings.value("password").toString());
    settings.endGroup();
}

void Client::onOnlineStateChanged(bool isOnline)
{
    if (isOnline) {
        //save settings (TODO use crypto backend as possible)
        QSettings settings;
        settings.beginGroup("connection");
        settings.setValue("login", login());
        settings.setValue("password", password());
        settings.endGroup();
    }
}
