#include "dialogsmodel.h"
#include <client.h>
#include <longpoll.h>
#include <QDebug>

DialogsModel::DialogsModel(QObject *parent) :
    vk::MessageListModel(parent),
    m_unreadCount(0)
{
}

void DialogsModel::setClient(QObject *client)
{
    if (m_client.data())
        m_client.data()->longPoll()->disconnect(this);

    m_client = static_cast<decltype(m_client.data())>(client);

    auto longPoll = m_client.data()->longPoll();
    connect(longPoll, SIGNAL(messageAdded(const vk::Message)), SLOT(onAddMessage(vk::Message)));
    connect(longPoll, SIGNAL(messageFlagsReplaced(int, int, int)), SLOT(replaceMessageFlags(int, int, int)));
    connect(this, SIGNAL(dataChanged(QModelIndex,QModelIndex)),
            this, SLOT(onDataChanged(QModelIndex,QModelIndex)));

    emit clientChanged(m_client.data());
}

QObject *DialogsModel::client() const
{
    return m_client.data();
}

void DialogsModel::setUnreadCount(int count)
{
    m_unreadCount = count;
    emit unreadCountChanged(count);
}

//void DialogsModel::setClient(vk::Client *client)
//{
//    m_client = client;
//    emit clientChanged(client);
//}

//vk::Client *DialogsModel::client() const
//{
//    return m_client.data();
//}

void DialogsModel::getLastDialogs(int count, int previewLength)
{
    if (m_client.isNull()) {
        qWarning("Dialog model must have a client!");
        return;
    }
    auto reply = m_client.data()->getLastDialogs(count, previewLength);
    connect(reply, SIGNAL(resultReady(QVariant)), SLOT(onDialogsReceived(QVariant)));
}


void DialogsModel::onDialogsReceived(const QVariant &dialogs)
{
    auto list = dialogs.toList();
    Q_ASSERT(!list.isEmpty());
    int count = list.takeFirst().toInt(); //TODO may be can usable
    Q_UNUSED(count);
    vk::MessageList messageList;
    foreach (auto item, list) {
        vk::Message message(item.toMap(), m_client.data());
        messageList.append(message);
    }
    setMessages(messageList);
}

static vk::Contact *getContact(const vk::Message &message)
{
    return message.isIncoming() ? message.from()
                                : message.to();
}

void DialogsModel::onAddMessage(const vk::Message &message)
{
    //FIXME use declarative style
    for (int i = 0; i != count(); i++) {
        if (getContact(message) == getContact(at(i))) {
            auto message = at(i);
            if (message.isUnread())

            removeMessage(at(i));
            break;
        }
    }
    insertMessage(0, message);
}

void DialogsModel::onDataChanged(const QModelIndex &topLeft, const QModelIndex &bottomRight)
{
    qDebug() << topLeft.row() << bottomRight.row();
    for (int i = topLeft.row(); i != bottomRight.row() + 1; i++) {
        auto message = at(i);
        if (message.isIncoming()) {
            message.isUnread() ? m_unreadCount++ : m_unreadCount--;
            emit unreadCountChanged(m_unreadCount);
        }
    }
}


int DialogsModel::unreadCount() const
{
    return m_unreadCount;
}
