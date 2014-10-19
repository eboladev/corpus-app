TEMPLATE = app

TARGET = Corpus

QT += qml quick network sql

SOURCES += src/main.cpp

RESOURCES += qml/assets.qrc

OTHER_FILES += qml/*.qml \
    qml/material/*.qml

mac {
    QMAKE_INFO_PLIST = platform/mac/Info.plist
    ICON = platform/mac/icon.icns
    #QMAKE_POST_LINK += macdeployqt Terrarium.app/ -qmldir=qml/ -verbose=1 -dmg
    QMAKE_MAC_SDK = macosx10.9
}
