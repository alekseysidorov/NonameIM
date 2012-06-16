TEMPLATE = lib
TARGET = nonameim-client
DEPENDPATH += .
INCLUDEPATH += . \
                /usr/include/libsynccommon \
                /usr/include/libsyncprofile \
                /usr/include/gq \
                $$PWD/../vk/src/api
DEPENDPATH += $$PWD/../vk/src/api
LIBS += -lsyncpluginmgr -lsyncprofile -lgq-gconf -L$$OUT_PWD/../vk/src/api/ -lvk

CONFIG += debug plugin meegotouchevents

QT += dbus network
QT -= gui

QMAKE_CXXFLAGS = -Wall \
    -g \
    -Wno-cast-align \
    -O2 -finline-functions

#install
target.path = /usr/lib/sync/

client.path = /etc/sync/profiles/client
client.files = client/nonameim.xml

sync.path = /etc/sync/profiles/sync
sync.files = sync/*

service.path = /etc/sync/profiles/service
service.files = service/*

settingsdesktop.path = /usr/share/duicontrolpanel/desktops
settingsdesktop.files = settings/nonameim.desktop

settingsxml.path = /usr/share/duicontrolpanel/uidescriptions
settingsxml.files = settings/nonameim.xml

INSTALLS += target client sync service settingsdesktop settingsxml

HEADERS += \
    newsfeed_client.h

SOURCES += \
    newsfeed_client.cpp

!isEmpty(MEEGO_VERSION_MAJOR) {
    QMAKE_LFLAGS += -Wl,--rpath=/opt/nonameIM/lib
}
