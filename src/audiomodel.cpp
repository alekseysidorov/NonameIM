#include "audiomodel.h"
#include <contact.h>
#include <reply.h>

AudioModel::AudioModel(QObject *parent) :
    vk::AudioModel(parent)
{
}

vk::Client *AudioModel::client() const
{
    return m_client.data();
}

void AudioModel::setClient(vk::Client *client)
{
    if (m_client.data() == client)
        return;
    if (!client) {
        m_provider.data()->deleteLater();
        emit clientChanged(client);
        return;
    }

    auto provider = new vk::AudioProvider(client);
    connect(provider, SIGNAL(audioItemReceived(vk::AudioItem)), SLOT(addAudio(vk::AudioItem)));
    m_provider = provider;
    m_client = client;
    emit clientChanged(client);
}

void AudioModel::get(vk::Contact *owner, int count, int offset)
{
    if (m_provider.data()) {
        auto reply = m_provider.data()->get(owner->id(), count, offset);
        connect(reply, SIGNAL(resultReady(QVariant)),
                this, SIGNAL(getAudioFinished()));
    }
}


QObject *AudioModel::clientObj() const
{
    return client();
}

void AudioModel::setClient(QObject *client)
{
    setClient(static_cast<vk::Client*>(client));
}

