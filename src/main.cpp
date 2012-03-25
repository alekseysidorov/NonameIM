#include <QApplication>
#include "qmlapplicationviewer.h"
#include <QtDeclarative>

#include "clientimpl.h"

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QScopedPointer<QApplication> app(createApplication(argc, argv));
    app->setApplicationName("NonameIM");
    app->setOrganizationName("Noname");
    app->setApplicationVersion("0.1");

    qmlRegisterType<Client>("com.vk.api", 0, 1, "Client");

    QmlApplicationViewer viewer;
    viewer.setOrientation(QmlApplicationViewer::ScreenOrientationAuto);
    viewer.setMainQmlFile(QLatin1String("qml/harmattan/main.qml"));
    viewer.showExpanded();

    return app->exec();
}
