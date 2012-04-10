#ifndef CLIENT_H
#define CLIENT_H
#include <client.h>
#include <QWeakPointer>

class Client : public vk::Client
{
    Q_OBJECT
public:
    Client(QObject *parent = 0);
    Q_INVOKABLE QObject *request(const QString &method, const QVariantMap &args = QVariantMap());
private slots:
    void onOnlineStateChanged(bool state);
    void setOnline(bool set);
};

#endif // CLIENT_H
