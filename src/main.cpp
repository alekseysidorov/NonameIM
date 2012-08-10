#include <QApplication>
#include "qmlapplicationviewer.h"
#include <QtDeclarative>

#include "clientimpl.h"
#include <roster.h>
#include <contact.h>
#include "buddymodel.h"
#include "dialogsmodel.h"
#include "chatmodel.h"
#include "wallmodel.h"
#include "commentsmodel.h"
#include "newsfeedmodel.h"
#include "audiomodel.h"
#include <longpoll.h>
#include <attachment.h>
#include <newsfeed.h>
#include <QNetworkDiskCache>

#define VK_API_NAMESPACE "com.vk.api"

class DiskNetworkAccessManagerFactory : public QDeclarativeNetworkAccessManagerFactory
{
public:
    virtual QNetworkAccessManager *create(QObject *parent);
};
QNetworkAccessManager *DiskNetworkAccessManagerFactory::create(QObject *parent)
{
    QNetworkAccessManager *manager = new QNetworkAccessManager(parent);
    QNetworkDiskCache *cache = new QNetworkDiskCache(manager);
    cache->setCacheDirectory("nonameIM");
    cache->setMaximumCacheSize(1024 * 1024 * 100);

    qDebug() << "--NetworkCache directory " << cache->cacheDirectory();
    qDebug() << "--NetworkCache size " <<  cache->cacheSize();
    return manager;
}

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QScopedPointer<QApplication> app(createApplication(argc, argv));
    app->setApplicationName("NonameIM");
    app->setOrganizationName("Noname");
    app->setApplicationVersion("0.1");

    qmlRegisterType<Client>(VK_API_NAMESPACE, 0, 1, "Client");
    qmlRegisterType<BuddyModel>(VK_API_NAMESPACE, 0, 1, "BuddyModel");
    qmlRegisterType<DialogsModel>(VK_API_NAMESPACE, 0, 1, "DialogsModel");
    qmlRegisterType<ChatModel>(VK_API_NAMESPACE, 0, 1, "ChatModel");
    qmlRegisterType<WallModel>(VK_API_NAMESPACE, 0, 1, "WallModel");
    qmlRegisterType<NewsFeedModel>(VK_API_NAMESPACE, 0, 1, "NewsFeedModel");
    qmlRegisterType<CommentsModel>(VK_API_NAMESPACE, 0, 1, "CommentsModel");
    qmlRegisterType<AudioModel>(VK_API_NAMESPACE, 0, 1, "AudioModel");

    qmlRegisterUncreatableType<Vreen::Roster>(VK_API_NAMESPACE, 0, 1, "Roster", QObject::tr("Use client.roster instead"));
    qmlRegisterUncreatableType<Vreen::Contact>(VK_API_NAMESPACE, 0, 1, "Contact", QObject::tr("User Roster"));
    qmlRegisterUncreatableType<Vreen::Buddy>(VK_API_NAMESPACE, 0, 1, "Buddy", QObject::tr("User Roster"));
    qmlRegisterUncreatableType<Vreen::Message>(VK_API_NAMESPACE, 0, 1, "Message", QObject::tr("Only flags"));
    qmlRegisterUncreatableType<Vreen::LongPoll>(VK_API_NAMESPACE, 0, 1, "LongPoll", QObject::tr("Use client.longPoll instead"));
    qmlRegisterUncreatableType<Vreen::Attachment>(VK_API_NAMESPACE, 0, 1, "Attachment", QObject::tr("Attachment enums"));
    qmlRegisterUncreatableType<Vreen::NewsItem>(VK_API_NAMESPACE, 0, 1, "NewsItem", QObject::tr("NewsItem enums"));
    qmlRegisterUncreatableType<Vreen::NewsFeed>(VK_API_NAMESPACE, 0, 1, "NewsFeed", QObject::tr("NewsFeed enums"));

    QmlApplicationViewer viewer;
    viewer.engine()->setNetworkAccessManagerFactory(new DiskNetworkAccessManagerFactory);
    viewer.setOrientation(QmlApplicationViewer::ScreenOrientationAuto);
    viewer.setMainQmlFile(QLatin1String("qml/harmattan/main.qml"));
    viewer.showExpanded();

    return app->exec();
}
