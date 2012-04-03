#include "dialogsmodel.h"
#include <client.h>
#include <longpoll.h>
#include <QDebug>

DialogsModel::DialogsModel(QObject *parent) :
    vk::MessageListModel(parent)
{
}

void DialogsModel::setClient(QObject *client)
{
	if (m_client.data())
		m_client.data()->longPoll()->disconnect(this);

    m_client = static_cast<decltype(m_client.data())>(client);

	auto longPoll = m_client.data()->longPoll();
	connect(longPoll, SIGNAL(messageAdded(const vk::Message)), SLOT(onAddMessage(vk::Message)));

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

void DialogsModel::onAddMessage(const vk::Message &message)
{
	//FIXME use declarative style
	for (int i = 0; i != count(); i++) {
		if (message.from() == at(i).from()) {
            removeMessage(at(i));
            break;
		}
	}
    insertMessage(0, message);
}
