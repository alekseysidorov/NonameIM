TARGET = nonameIM

CONFIG -= debug_and_release debug
CONFIG += release

QT += network

# Add more folders to ship with the application, here
folder_01.source = qml/harmattan
folder_01.target = qml
DEPLOYMENTFOLDERS = folder_01

# Additional import path used to resolve QML modules in Creator's code model
QML_IMPORT_PATH =

symbian:TARGET.UID3 = 0xE3EDB021

# Smart Installer package's UID
# This UID is from the protected range and therefore the package will
# fail to install if self-signed. By default qmake uses the unprotected
# range value if unprotected UID is defined for the application and
# 0x2002CCCF value if protected UID is given to the application
#symbian:DEPLOYMENT.installer_header = 0x2002CCCF

# Allow network access on Symbian
symbian:TARGET.CAPABILITY += NetworkServices

# If your application uses the Qt Mobility libraries, uncomment the following
# lines and add the respective components to the MOBILITY variable.
# CONFIG += mobility
# MOBILITY +=

# Speed up launching on MeeGo/Harmattan when using applauncherd daemon
CONFIG += qdeclarative-boostable

# Add dependency to Symbian components
# CONFIG += qt-components

# The .cpp file which was generated for your project. Feel free to hack it.
SOURCES += main.cpp \
    clientimpl.cpp \
    contactsmodel.cpp \
    newsfeedmodel.cpp \
    dialogsmodel.cpp \
    chatmodel.cpp \
    wallmodel.cpp \
    commentsmodel.cpp \
    audiomodel.cpp

# Please do not modify the following two lines. Required for deployment.
include(qmlapplicationviewer/qmlapplicationviewer.pri)
qtcAddDeployment()

OTHER_FILES += \
    qtc_packaging/debian_harmattan/rules \
    qtc_packaging/debian_harmattan/README \
    qtc_packaging/debian_harmattan/manifest.aegis \
    qtc_packaging/debian_harmattan/copyright \
    qtc_packaging/debian_harmattan/control \
    qtc_packaging/debian_harmattan/compat \
    qtc_packaging/debian_harmattan/changelog

win32:CONFIG(release, debug|release): LIBS += -L$$OUT_PWD/../vk/src/api/release/ -lvk
else:win32:CONFIG(debug, debug|release): LIBS += -L$$OUT_PWD/../vk/src/api/debug/ -lvk
else:symbian: LIBS += -lvk
else:unix: LIBS += -L$$OUT_PWD/../vk/src/api/ -lvk

INCLUDEPATH += $$PWD/../vk/src/api
DEPENDPATH += $$PWD/../vk/src/api

HEADERS += \
    clientimpl.h \
    contactsmodel.h \
    newsfeedmodel.h \
    dialogsmodel.h \
    chatmodel.h \
    wallmodel.h \
    commentsmodel.h \
    audiomodel.h

unix {
    QMAKE_CXXFLAGS += -std=c++0x -fvisibility=hidden -Wall -Wextra
}

!isEmpty(MEEGO_VERSION_MAJOR) {
    QMAKE_LFLAGS += -Wl,--rpath=/opt/nonameIM/lib
}
