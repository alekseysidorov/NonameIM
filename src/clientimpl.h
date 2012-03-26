#ifndef CLIENT_H
#define CLIENT_H
#include <client.h>
#include <newsmodel.h>
#include <QWeakPointer>

class Client : public vk::Client
{
    Q_OBJECT

    Q_PROPERTY(vk::NewsModel* newsModel READ newsModel NOTIFY newsModelChanged)
public:
    Client(QObject *parent = 0);
    vk::NewsModel *newsModel();
signals:
    void newsModelChanged(vk::NewsModel*);
private slots:
    void onOnlineStateChanged(bool state);
private:
    QWeakPointer<vk::NewsModel> m_newsModel;
};

#endif // CLIENT_H
