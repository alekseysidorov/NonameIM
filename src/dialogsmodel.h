#ifndef DIALOGSMODEL_H
#define DIALOGSMODEL_H
#include <messagemodel.h>
#include <roster.h>
#include <QWeakPointer>

class DialogsModel : public vk::MessageListModel
{
    Q_OBJECT

    Q_PROPERTY(QObject* client READ client WRITE setClient NOTIFY clientChanged)
public:
    explicit DialogsModel(QObject *parent = 0);

    //HACK workaround about "Unable to assign QObject* to void"
    void setClient(QObject *client);
    //void setClient(vk::Client *client);
    //vk::Client *client() const;
    QObject *client() const;
public slots:
    void getLastDialogs(int count = 16, int previewLength = -1);
signals:
    //void clientChanged(vk::Client*);
    void clientChanged(QObject*); //HACK
private slots:
    void onDialogsReceived(const QVariant &dialogs);
	void onAddMessage(const vk::Message &message);
private:
    QWeakPointer<vk::Client> m_client;
};

#endif // DIALOGSMODEL_H
