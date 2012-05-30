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
    roles[OwnerNameRole] = "ownerName";
    roles[SourcePhotoRole] = "sourcePhoto";
    roles[SourceNameRole] = "sourceName";
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
        return qVariantFromValue(findContact(source));
    }
    case DateRole:
        return news.date();
    case BodyRole:
        return news.body();
    case AttachmentsRole:
        return vk::Attachment::toVariantMap(news.attachments());
    case LikesRole:
        return news.property("likes");
    case RepostsRole:
        return news.property("reposts");
    case CommentsRole:
        return news.property("comments");
    case OwnerNameRole: {
        int ownerId = news.property("copy_owner_id").toInt();
        if (ownerId) {
            auto contact = m_client.data()->roster()->contact(ownerId);
            return contact->name();
        }
        return QVariant();
    }
    case SourcePhotoRole: {
        if (auto contact = findContact(news.sourceId()))
            return contact->photoSource();
        break;
    }
    case SourceNameRole: {
        if (auto contact = findContact(news.sourceId()))
            return contact->name();
        break;
    }
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

void NewsFeedModel::getNews(int filters, quint8 count, int offset)
{
    if (m_newsFeed.isNull())
        return;

    qDebug() << Q_FUNC_INFO << filters << count << offset;
    auto reply = m_newsFeed.data()->getNews(static_cast<vk::NewsFeed::Filters>(filters), count, offset);
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

void NewsFeedModel::clear()
{
    beginRemoveRows(QModelIndex(), 0, m_newsList.count());
    m_newsList.clear();
    endRemoveRows();
}

void NewsFeedModel::truncate(int count)
{
    if (count >= m_newsList.count())
        count = m_newsList.count() - 1;

    beginRemoveRows(QModelIndex(), count, m_newsList.count() - 1);
    m_newsList.erase(m_newsList.begin() + count - 1, m_newsList.end());
    endRemoveRows();
}

static bool newsItemMoreThan(const vk::NewsItem &a, const vk::NewsItem &b)
{
    return a.date() > b.date();
}

void NewsFeedModel::onNewsAdded(const vk::NewsItem &item)
{
    if (findNews(item.postId()) != -1)
        return;

    auto index = vk::lowerBound(m_newsList, item, newsItemMoreThan);
    insertNews(index, item);
}


void NewsFeedModel::insertNews(int index, const vk::NewsItem &item)
{
    beginInsertRows(QModelIndex(), index, index);
    m_newsList.insert(index, item);
    endInsertRows();
    qApp->processEvents(QEventLoop::ExcludeUserInputEvents);
}

vk::Contact *NewsFeedModel::findContact(int id) const
{
    return m_client.data()->roster()->contact(id);
}
