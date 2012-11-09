TARGET = nonameIM

CONFIG -= debug_and_release debug
CONFIG += release

QT += network

include(../vreen/vreen.pri)

VKIT_SRC_ROOT_DIR = ../vreen/src
VKIT_QML_DIR = ../vreen/src/qml
VKIT_QML_SRC_DIR = $$VKIT_QML_DIR/src
VKIT_QML_QMLDIR = $$VKIT_QML_DIR/qmldir

# Add more folders to ship with the application, here
folder_01.source = qml/harmattan
folder_01.target = qml

folder_02.source = splash
folder_02.target = share

folder_03.source = $$VKIT_QML_QMLDIR/PhotoModel.qml
folder_03.target = qml/harmattan/draft

headers_folder.source = $$VKIT_QML_SRC_DIR
headers_folder.target = include/vreen

DEPLOYMENTFOLDERS += folder_01 \
    folder_02 \
    folder_03 \
    headers_folder

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
CONFIG += qdeclarative-boostable meegotouchevents meegotouch

# Add dependency to Symbian components
# CONFIG += qt-components

INCLUDEPATH += $$VKIT_SRC_ROOT_DIR/directauth \
    $$VKIT_QML_SRC_DIR/qml/src \
    $$OUT_PWD/../vreen/include

DEFINES += VREEN_DIRECTAUTH_CLIENT_ID=\\\"1950109\\\" \
    VREEN_DIRECTAUTH_CLIENT_SECRET=\\\"bJKfYSu0LS6N52M0HnBo\\\" \
    VREEN_DIRECTAUTH_CLIENT_NAME=\\\"TitanIM\\\"

# The .cpp file which was generated for your project. Feel free to hack it.
SOURCES += main.cpp \
    $$VKIT_QML_SRC_DIR/clientimpl.cpp \
    $$VKIT_QML_SRC_DIR/buddymodel.cpp \
    $$VKIT_QML_SRC_DIR/newsfeedmodel.cpp \
    $$VKIT_QML_SRC_DIR/dialogsmodel.cpp \
    $$VKIT_QML_SRC_DIR/chatmodel.cpp \
    $$VKIT_QML_SRC_DIR/wallmodel.cpp \
    $$VKIT_QML_SRC_DIR/commentsmodel.cpp \
    $$VKIT_QML_SRC_DIR/audiomodel.cpp \
    $$VKIT_SRC_ROOT_DIR/directauth/directconnection.cpp

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

win32:CONFIG(release, debug|release): LIBS += -L$$OUT_PWD/../vreen/src/api/release/ -lvreen
else:win32:CONFIG(debug, debug|release): LIBS += -L$$OUT_PWD/../vreen/src/api/debug/ -lvreen
else:symbian: LIBS += -lvreen
else:unix: LIBS += -L$$OUT_PWD/../vreen/src/api/ -lvreen

INCLUDEPATH += $$PWD/../vreen/src/api \
    $$VKIT_QML_SRC_DIR \
    $$VKIT_SRC_ROOT_DIR
DEPENDPATH += $$PWD/../vreen/src/api

HEADERS += \
    $$VKIT_QML_SRC_DIR/clientimpl.h \
    $$VKIT_QML_SRC_DIR/buddymodel.h \
    $$VKIT_QML_SRC_DIR/newsfeedmodel.h \
    $$VKIT_QML_SRC_DIR/dialogsmodel.h \
    $$VKIT_QML_SRC_DIR/chatmodel.h \
    $$VKIT_QML_SRC_DIR/wallmodel.h \
    $$VKIT_QML_SRC_DIR/commentsmodel.h \
    $$VKIT_QML_SRC_DIR/audiomodel.h \
    $$VKIT_SRC_ROOT_DIR/directauth/directconnection_p.h

unix {
    QMAKE_CXXFLAGS += -std=c++0x -fvisibility=hidden -Wall -Wextra
}

!isEmpty(MEEGO_VERSION_MAJOR) {
    QMAKE_CXXFLAGS += -Wall \
        -Wno-cast-align \
	-O3

    QMAKE_LFLAGS += -Wl,--rpath=/opt/nonameIM/lib
}

HEADERS += \
    ../vreen/src/qml/src/vkitqmlplugin.h
