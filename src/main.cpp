#include <QApplication>
#include "qmlapplicationviewer.h"
#include <QtDeclarative>

#include "clientimpl.h"
#include <roster.h>
#include <contact.h>
#include "buddymodel.h"
#include "dialogsmodel.h"
#include "chatmodel.h"
#include "wallmodel.h"
#include "commentsmodel.h"
#include "newsfeedmodel.h"
#include "audiomodel.h"
#include <longpoll.h>
#include <attachment.h>
#include <newsfeed.h>
#include <vkitqmlplugin.h>
#include <directconnection_p.h>
#include <QNetworkDiskCache>
#include <QtOpenGL>

class DiskNetworkAccessManagerFactory : public QDeclarativeNetworkAccessManagerFactory
{
public:
    virtual QNetworkAccessManager *create(QObject *parent);
};
QNetworkAccessManager *DiskNetworkAccessManagerFactory::create(QObject *parent)
{
    QNetworkAccessManager *manager = new QNetworkAccessManager(parent);
    QNetworkDiskCache *cache = new QNetworkDiskCache(manager);
    cache->setCacheDirectory("nonameIM");
    cache->setMaximumCacheSize(1024 * 1024 * 100);

    qDebug() << "--NetworkCache directory " << cache->cacheDirectory();
    qDebug() << "--NetworkCache size " <<  cache->cacheSize();
    return manager;
}

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QScopedPointer<QApplication> app(createApplication(argc, argv));
    app->setApplicationName("NonameIM");
    app->setOrganizationName("Noname");
    app->setApplicationVersion("0.1");

    qmlRegisterType<Vreen::DirectConnection>("com.vk.api", 1, 0, "DirectConnection");
    registerVreenTypes("com.vk.api");

    QGLFormat format = QGLFormat::defaultFormat();
    format.setSampleBuffers(false);
    format.setSwapInterval(1);
    QGLWidget* glWidget = new QGLWidget(format);
    glWidget->setAutoFillBackground(false);

    QmlApplicationViewer viewer;
    viewer.engine()->setNetworkAccessManagerFactory(new DiskNetworkAccessManagerFactory);
    viewer.setOrientation(QmlApplicationViewer::ScreenOrientationAuto);
    viewer.setMainQmlFile(QLatin1String("qml/harmattan/main.qml"));
    viewer.setViewport(glWidget);
    viewer.setViewportUpdateMode(QGraphicsView::FullViewportUpdate);
    viewer.showExpanded();

    return app->exec();
}
