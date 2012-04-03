/*
    Copyright (c) 2010 by Nazarov Ruslan <818151@mail.ru>

 ***************************************************************************
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 3 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 ***************************************************************************
*/

import QtQuick 1.1
import com.nokia.meego 1.0

Rectangle {
    width: parent.width
    height: parent.width < parent.height ? 72 : 46
    z: 100500
    anchors.top: parent.top

    gradient: Gradient {
         GradientStop { position: 0.0; color: "#5878A1" }
         GradientStop { position: 1.0; color: "#466392" }
    }

    Rectangle{
        width: parent.width
        height: 1
        anchors.bottom: parent.bottom
        color: "black"
    }
}
