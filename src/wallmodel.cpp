#include "wallmodel.h"
#include <QApplication>
#include <roster.h>
#include <wallpost.h>
#include <QDateTime>
#include <QDebug>
#include <QNetworkReply>

WallModel::WallModel(QObject *parent) :
    QAbstractListModel(parent)
{
    auto roles = roleNames();
    roles[BodyRole] = "body";
    roles[FromRole] = "from";
    roles[ToRole] = "to";
    roles[DateRole] = "date";
    roles[IdRole] = "postId";
    setRoleNames(roles);
}

vk::Contact *WallModel::contact() const
{
    return m_contact.data();
}

void WallModel::setContact(vk::Contact *contact)
{
    if (!m_session.isNull()) {
        clear();
        m_session.data()->deleteLater();
    }
    if (!contact)
        return;
    auto session = new vk::WallSession(contact);
    connect(session, SIGNAL(postAdded(vk::WallPost)), SLOT(addPost(vk::WallPost)));

    m_contact = contact;
    m_session = session;
    emit contactChanged(contact);
}

QVariant WallModel::data(const QModelIndex &index, int role) const
{
    int row = index.row();
    auto post = m_posts.at(row);
    switch (role) {
    case IdRole:
        return post.id();
    case FromRole:
        return qVariantFromValue(post.from());
    case ToRole:
        return qVariantFromValue(post.to());
    case BodyRole:
        return post.body();
    case DateRole:
        return post.date();
    default:
        break;
    }
    return QVariant::Invalid;
}

int WallModel::rowCount(const QModelIndex &) const
{
    return count();
}

int WallModel::count() const
{
    return m_posts.count();
}

void WallModel::getLastPosts(int count, vk::WallSession::Filter filter)
{
    if (m_session.isNull()) {
        qWarning("WallModel: contact is null! Please set a contact!");
        return;
    }
    auto reply = m_session.data()->getPosts(filter, count, 0, false);
    connect(reply, SIGNAL(resultReady(QVariant)), SIGNAL(requestFinished()));
}

void WallModel::clear()
{
    beginRemoveRows(QModelIndex(), 0, m_posts.count());
    m_posts.clear();
    endRemoveRows();
    qApp->processEvents(QEventLoop::ExcludeUserInputEvents);
}

int WallModel::findPost(int id)
{
    for (int i = 0; i != m_posts.count(); i++) {
        if (data(createIndex(i, 0), IdRole).toInt() == id)
            return i;
    }
    return -1;
}


static bool postLessThan(const vk::WallPost &a, const vk::WallPost &b)
{
    return a.id() < b.id();
}


void WallModel::addPost(const vk::WallPost &post)
{
    if (findPost(post.id()) != -1)
        return;

    auto it = qLowerBound(m_posts.end(), m_posts.begin(), post , postLessThan);
    auto last = it - m_posts.begin();
    beginInsertRows(QModelIndex(), last, last);
    m_posts.insert(it, post);
    endInsertRows();
    qApp->processEvents(QEventLoop::ExcludeUserInputEvents);
}

vk::Roster *WallModel::roster() const
{
    return m_contact.data()->client()->roster();
}
