#include "dialogsmodel.h"
#include <client.h>
#include <QDebug>

DialogsModel::DialogsModel(QObject *parent) :
    vk::MessageListModel(parent)
{
}

void DialogsModel::setClient(QObject *client)
{
    m_client = static_cast<decltype(m_client.data())>(client);
    emit clientChanged(m_client.data());
}

QObject *DialogsModel::client() const
{
    return m_client.data();
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
    qDebug() << dialogs;
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
