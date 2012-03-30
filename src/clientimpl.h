#ifndef CLIENT_H
#define CLIENT_H
#include <client.h>
#include <QWeakPointer>

class Client : public vk::Client
{
    Q_OBJECT
public:
    Client(QObject *parent = 0);
private slots:
    void onOnlineStateChanged(bool state);
};

#endif // CLIENT_H
