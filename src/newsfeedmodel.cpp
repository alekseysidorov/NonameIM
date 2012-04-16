#include "newsfeedmodel.h"
#include <QApplication>
#include <roster.h>
#include <client.h>
#include <utils.h>
#include <QDateTime>
#include <QDebug>

NewsFeedModel::NewsFeedModel(QObject *parent) :
    QAbstractListModel(parent),
    m_sortOrder(Qt::DescendingOrder)
{
    auto roles = roleNames();
    roles[TypeRole] = "type";
    roles[PostIdRole] = "postId";
    roles[SourceRole] = "source";
    roles[DateRole] = "date";
    roles[BodyRole] = "body";
    roles[AttachmentsRole] = "attachments";
    roles[LikesRole] = "likes";
    roles[RepostsRole] = "reposts";
    roles[CommentsRole] = "comments";
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
    connect(newsFeed, SIGNAL(newsAdded(vk::NewsItem)), SLOT(onNewsAdded(vk::NewsItem)));

    m_newsFeed = newsFeed;
}

QVariant NewsFeedModel::data(const QModelIndex &index, int role) const
{
    int row = index.row();

    auto news = m_newsList.at(row);
    switch (role) {
    case TypeRole:
        return news.type();
    case PostIdRole:
        return news.postId();
        break;
    case SourceRole: {
        int source = news.sourceId();
        return qVariantFromValue(m_client.data()->roster()->contact(source));
    }
    case DateRole:
        return news.date();
    case BodyRole:
        return news.body();
    case AttachmentsRole:
        return vk::Attachment::toList(news.attachments());
    case LikesRole:
        return news.property("likes");
    case RepostsRole:
        return news.property("reposts");
    case CommentsRole:
        return news.property("comments");
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

    auto reply = m_newsFeed.data()->getLatestNews(filters, count);
    connect(reply, SIGNAL(resultReady(QVariant)), SIGNAL(requestFinished()));
}

int NewsFeedModel::findNews(int id)
{
    for (int i = 0 ; i != count(); i++) {
        if (id == this->data(createIndex(i, 0), PostIdRole).toInt())
            return i;
    }
    return -1;
}

static bool newsItemLessThan(const vk::NewsItem &a, const vk::NewsItem &b)
{
    return a.date() < b.date();
}

void NewsFeedModel::onNewsAdded(const vk::NewsItem &item)
{
    if (findNews(item.postId()) != -1)
        return;

    auto index = vk::bound(m_newsList, m_sortOrder, item, newsItemLessThan);
    insertNews(index, item);
}


void NewsFeedModel::insertNews(int index, const vk::NewsItem &item)
{
    beginInsertRows(QModelIndex(), index, index);
    m_newsList.insert(index, item);
    endInsertRows();
    qApp->processEvents(QEventLoop::ExcludeUserInputEvents);
}
