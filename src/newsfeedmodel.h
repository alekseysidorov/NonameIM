#ifndef NEWSFEEDMODEL_H
#define NEWSFEEDMODEL_H

#include <QAbstractListModel>
#include <newsfeed.h>
#include <QWeakPointer>

namespace vk {
typedef QList<QVariantMap> NewsList;
} //namespace vk

class NewsFeedModel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(QObject* client READ client WRITE setClient NOTIFY clientChanged)
public:

    enum Roles {
        PostIdRole = Qt::UserRole,
        SourceRole,
        DateRole,
        BodyRole
    };

    explicit NewsFeedModel(QObject *parent = 0);
    QObject* client() const;
    void setClient(QObject* arg);
    virtual QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const;
    virtual int rowCount(const QModelIndex &) const;
    int count() const;
public slots:
    void getLatestNews(vk::NewsFeed::Filters filters = vk::NewsFeed::FilterPost | vk::NewsFeed::FilterPhoto,
                       quint8 count = 50);
    int findNews(int id);
signals:
    void clientChanged(QObject* client);
private slots:
    void onNewsAdded(const QVariantMap &data);
private:
    QWeakPointer<vk::Client> m_client;
    QWeakPointer<vk::NewsFeed> m_newsFeed;
    vk::NewsList m_newsList;
};

#endif // NEWSFEEDMODEL_H
