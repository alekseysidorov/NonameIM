#include "newsfeed_client.h"
#include <QSettings>
#include <client.h>
#include <gconfitem.h>
#include <meventfeed.h>
#include <roster.h>
#include <attachment.h>

extern "C" NewsFeedClient* createPlugin(const QString& aPluginName,
                                        const Buteo::SyncProfile& aProfile,
                                        Buteo::PluginCbInterface *aCbInterface)
{
    return new NewsFeedClient(aPluginName, aProfile, aCbInterface);
}

extern "C" void destroyPlugin(NewsFeedClient *aClient)
{
    delete aClient;
}

NewsFeedClient::NewsFeedClient(const QString &aPluginName, const Buteo::SyncProfile &aProfile, Buteo::PluginCbInterface *aCbInterface) :
    Buteo::ClientPlugin(aPluginName, aProfile, aCbInterface)
{
}

NewsFeedClient::~NewsFeedClient()
{
}

bool NewsFeedClient::init()
{
    m_client = new vk::Client(this);
    m_feed = new vk::NewsFeed(m_client.data());

    connect(m_feed.data(), SIGNAL(newsRecieved(vk::NewsItemList)), SLOT(newsRecieved(vk::NewsItemList)));
    connect(m_client.data(), SIGNAL(onlineStateChanged(bool)), SLOT(connectedToHost(bool)));
    return true;
}

bool NewsFeedClient::uninit()
{
    m_client.data()->deleteLater();
    return true;
}

bool NewsFeedClient::startSync()
{
    //GConfItem enabledConfItem("/apps/ControlPanel/NonameIM/EnableFeed");
    //QVariant enabledVariant = enabledConfItem.value();

    //if (enabledVariant.isValid()) {
    //    bool enabled = enabledVariant.toBool();
    //    if (!enabled) {
    //        MEventFeed::instance()->removeItemsBySourceName("SyncFW-nonameim");
    //        return false;
    //    }
    //} else {
    //    enabledConfItem.set(true);
    //}

    QSettings settings("noname", "nonameIM");
    settings.beginGroup("connection");
    QString login = settings.value("login").toString();
    QString password = settings.value("password").toString();
    settings.endGroup();
    if (login.isEmpty() || password.isEmpty())
        return false;

    m_client.data()->setPassword(password);
    m_client.data()->setLogin(login);
    return true;
}

void NewsFeedClient::abortSync(Sync::SyncStatus aStatus)
{
    Q_UNUSED(aStatus);
}

Buteo::SyncResults NewsFeedClient::getSyncResults() const
{
    return m_results;
}

bool NewsFeedClient::cleanUp()
{
    return true;
}

void NewsFeedClient::connectivityStateChanged(Sync::ConnectivityType aType, bool aState)
{
    Q_UNUSED(aType);
    if (aState)
        m_client.data()->connectToHost();
}

void NewsFeedClient::newsRecieved(const vk::NewsItemList &news)
{
    foreach (vk::NewsItem item, news) {
        vk::Contact *from = m_client.data()->roster()->contact(item.sourceId());
        vk::Attachment::List attachments = item.attachments(vk::Attachment::Photo);
        QStringList list;
        foreach (vk::Attachment attach, attachments)
            list.append(attach.property("src").toString());

        MEventFeed::instance()->addItem(from->photoSource(),
                                        from->name(),
                                        item.body(),
                                        list,
                                        item.date(),
                                        QString(),
                                        false,
                                        QUrl(),
                                        QString("SyncFW-nonameim"),
                                        QString("NonameIM")
                                        );
    }
    MEventFeed::instance()->removeItemsBySourceName("SyncFW-nonameim");
}

void NewsFeedClient::connectedToHost(bool success)
{
    if (success) {
        m_feed.data()->getNews(vk::NewsFeed::FilterPost | vk::NewsFeed::FilterPhoto); //TODO add offset check and others
    }
}

void NewsFeedClient::syncSuccess()
{
    updateResults(Buteo::SyncResults(QDateTime::currentDateTime(), Buteo::SyncResults::SYNC_RESULT_SUCCESS, Buteo::SyncResults::NO_ERROR));
    emit success(getProfileName(), "Success!!");
}

void NewsFeedClient::syncFailed()
{
    updateResults(Buteo::SyncResults(QDateTime::currentDateTime(),
                                     Buteo::SyncResults::SYNC_RESULT_FAILED, Buteo::SyncResults::ABORTED));
    emit error(getProfileName(), "Error!!", Buteo::SyncResults::SYNC_RESULT_FAILED);
}

void NewsFeedClient::updateResults(const Buteo::SyncResults &aResults)
{
    m_results = aResults;
    m_results.setScheduled(true);
}
