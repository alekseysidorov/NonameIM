#include "newsfeedmodel.h"
#include <QApplication>
#include "roster.h"
#include "client.h"
#include <QDateTime>
#include <QDebug>

NewsFeedModel::NewsFeedModel(QObject *parent) :
    QAbstractListModel(parent)
{
    auto roles = roleNames();
    roles[IdRole] = "id";
    roles[SourceRole] = "source";
    roles[DateRole] = "date";
    roles[BodyRole] = "body";
    setRoleNames(roles);
}

QObject *NewsFeedModel::client() const
{
    return m_client.data();
}

void NewsFeedModel::setClient(QObject *obj)
{
    auto client = static_cast<vk::Client*>(obj);
    m_client = client;
    if (m_newsFeed.data())
        m_newsFeed.data()->deleteLater();
    if (!client)
        return;

    auto newsFeed = new vk::NewsFeed(client);
    connect(newsFeed, SIGNAL(newsAdded(QVariantMap)), SLOT(onNewsAdded(QVariantMap)));

    m_newsFeed = newsFeed;
}

QVariant NewsFeedModel::data(const QModelIndex &index, int role) const
{
    int row = index.row();

    auto news = m_newsList.at(row);
    switch (role) {
    case IdRole:
        return news.value("post_id");
        break;
    case SourceRole: {
        int source = news.value("source_id").toInt();
        return qVariantFromValue(m_client.data()->roster()->contact(source));
    }
    case DateRole:
        return QDateTime::fromTime_t(news.value("date").toUInt());
    case BodyRole:
        return news.value("text");
    default:
        break;
    }
    return QVariant::Invalid;
}

int NewsFeedModel::rowCount(const QModelIndex &) const
{
    return count();
}

int NewsFeedModel::count() const
{
    return m_newsList.count();
}

void NewsFeedModel::getLatestNews(vk::NewsFeed::Filters filters, quint8 count)
{
    if (m_newsFeed.isNull())
        return;

    m_newsFeed.data()->getLatestNews(filters, count);
}

int NewsFeedModel::findNews(int id)
{
    for (int i = 0 ; i != count(); i++) {
        if (id == this->data(createIndex(i, 0), IdRole).toInt())
            return i;
    }
    return -1;
}

void NewsFeedModel::onNewsAdded(const QVariantMap &data)
{
    if (findNews(data.value("post_id").toInt()) != -1)
        return;

    auto last = m_newsList.count();
    beginInsertRows(QModelIndex(), last, last);
    m_newsList.append(data);
    endInsertRows();
    //qApp->processEvents(QEventLoop::ExcludeUserInputEvents);
}
