#ifndef NEWSFEEDCLIENT_H
#define NEWSFEEDCLIENT_H

#include <libsyncpluginmgr/ClientPlugin.h>
#include <libsyncprofile/SyncResults.h>
#include <QWeakPointer>
#include <newsitem.h>
#include <newsfeed.h>

class NewsFeedClient : public Buteo::ClientPlugin
{
    Q_OBJECT
public:
    NewsFeedClient( const QString& aPluginName,
              const Buteo::SyncProfile& aProfile,
              Buteo::PluginCbInterface *aCbInterface );

    virtual ~NewsFeedClient();
    virtual bool init();
    virtual bool uninit();
    virtual bool startSync();
    virtual void abortSync(Sync::SyncStatus aStatus = Sync::SYNC_ABORTED);
    virtual Buteo::SyncResults getSyncResults() const;
    virtual bool cleanUp();
public slots:
    virtual void connectivityStateChanged(Sync::ConnectivityType aType,
                                          bool aState);

protected slots:
    void newsRecieved(const vk::NewsItemList &news);
    void connectedToHost(bool success);
    void syncSuccess();
    void syncFailed();
private:
    void updateResults(const Buteo::SyncResults &aResults);
private:
    Buteo::SyncResults          m_results;
    QWeakPointer<vk::Client> m_client;
    QWeakPointer<vk::NewsFeed> m_feed;
};

extern "C" NewsFeedClient* createPlugin(const QString& aPluginName,
                                  const Buteo::SyncProfile& aProfile,
                                  Buteo::PluginCbInterface *aCbInterface);

extern "C" void destroyPlugin(NewsFeedClient *aClient);

#endif // NEWSFEEDCLIENT_H
