#ifndef CLIENT_H
#define CLIENT_H
#include <client.h>
#include <QWeakPointer>
#include <QtDeclarative>

class Client : public vk::Client
{
    Q_OBJECT
public:
    Client(QObject *parent = 0);
    Q_INVOKABLE QObject *request(const QString &method, const QVariantMap &args = QVariantMap());
signals:
    void messageReceived(vk::Contact *from);
private slots:
    void onOnlineStateChanged(bool state);
    void setOnline(bool set);
    void onMessageAdded(const vk::Message &msg);
};

#endif // CLIENT_H
