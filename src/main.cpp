#include <QApplication>
#include "qmlapplicationviewer.h"
#include <QtDeclarative>

#include "clientimpl.h"
#include <roster.h>
#include <buddy.h>
#include "contactsmodel.h"
#include "dialogsmodel.h"
#include "chatmodel.h"
#include "wallmodel.h"
#include "newsfeedmodel.h"
#include <longpoll.h>

#define VK_API_NAMESPACE "com.vk.api"

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QScopedPointer<QApplication> app(createApplication(argc, argv));
    app->setApplicationName("NonameIM");
    app->setOrganizationName("Noname");
    app->setApplicationVersion("0.1");

    qmlRegisterType<Client>(VK_API_NAMESPACE, 0, 1, "Client");
    qmlRegisterType<ContactsModel>(VK_API_NAMESPACE, 0, 1, "ContactsModel");
    qmlRegisterType<DialogsModel>(VK_API_NAMESPACE, 0, 1, "DialogsModel");
    qmlRegisterType<ChatModel>(VK_API_NAMESPACE, 0, 1, "ChatModel");
    qmlRegisterType<WallModel>(VK_API_NAMESPACE, 0, 1, "WallModel");
    qmlRegisterType<NewsFeedModel>(VK_API_NAMESPACE, 0, 1, "NewsFeedModel");

    qmlRegisterUncreatableType<vk::Roster>(VK_API_NAMESPACE, 0, 1, "Roster", QObject::tr("Use client.roster instead"));
    qmlRegisterUncreatableType<vk::Contact>(VK_API_NAMESPACE, 0, 1, "Contact", QObject::tr("User Roster"));
    qmlRegisterUncreatableType<vk::Message>(VK_API_NAMESPACE, 0, 1, "Message", QObject::tr("Only flags"));
    qmlRegisterUncreatableType<vk::LongPoll>(VK_API_NAMESPACE, 0, 1, "LongPoll", QObject::tr("Use client.longPoll instead"));

    QmlApplicationViewer viewer;
    viewer.setOrientation(QmlApplicationViewer::ScreenOrientationAuto);
    viewer.setMainQmlFile(QLatin1String("qml/harmattan/main.qml"));
    viewer.showExpanded();

    return app->exec();
}
