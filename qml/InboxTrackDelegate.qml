/****************************************************************************
**
** Copyright (c) 2011 Nokia Corporation and/or its subsidiary(-ies).
** All rights reserved.
** Contact: Yoann Lopes (yoann.lopes@nokia.com)
**
** This file is part of the MeeSpot project.
**
** Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions
** are met:
**
** Redistributions of source code must retain the above copyright notice,
** this list of conditions and the following disclaimer.
**
** Redistributions in binary form must reproduce the above copyright
** notice, this list of conditions and the following disclaimer in the
** documentation and/or other materials provided with the distribution.
**
** Neither the name of Nokia Corporation and its Subsidiary(-ies) nor the names of its
** contributors may be used to endorse or promote products derived from
** this software without specific prior written permission.
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
** FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
** TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
** PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
** LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
** NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
** SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**
** If you have questions regarding the use of this file, please contact
** Nokia at qt-info@nokia.com.
**
****************************************************************************/


import QtQuick 2.0
import Ubuntu.Components 0.1
import "UIConstants.js" as UI

Item {
    id: listItem

    signal clicked
    signal pressAndHold
    property alias pressed: mouseArea.pressed
    property alias name: mainText.text
    property alias artistAndAlbum: subText.text
    property alias creatorAndDate: thirdText.text
    property alias duration: timing.text
    property bool highlighted: false
    property bool starred: false
    property bool available: true
    property bool seen: true
    property bool pressAndHoldEnabled: true

    property color highlightColor: UI.SPOTIFY_COLOR

    property int titleSize: units.gu(UI.LIST_TILE_SIZE)
    property string titleFont: UI.FONT_FAMILY_BOLD
    property color titleColor: UI.LIST_TITLE_COLOR

    property int subtitleSize: units.gu(UI.LIST_SUBTILE_SIZE)
    property string subtitleFont: UI.FONT_FAMILY_LIGHT
    property color subtitleColor: UI.LIST_SUBTITLE_COLOR

    property real backgroundOpacity: 0.0

    property real defaultHeight: units.gu(UI.LIST_ITEM_HEIGHT) + thirdText.height

    height: defaultHeight
    width: parent.width

    SequentialAnimation {
        id: backAnimation
        property bool animEnded: false
        running: mouseArea.pressed && listItem.pressAndHoldEnabled

        ScriptAction { script: backAnimation.animEnded = false }
        PauseAnimation { duration: 200 }
        ParallelAnimation {
            NumberAnimation { target: background; property: "opacity"; to: 0.4; duration: 300 }
            ColorAnimation { target: mainText; property: "color"; to: "#DDDDDD"; duration: 300 }
            ColorAnimation { target: subText; property: "color"; to: "#DDDDDD"; duration: 300 }
            ColorAnimation { target: thirdText; property: "color"; to: "#DDDDDD"; duration: 300 }
            ColorAnimation { target: timing; property: "color"; to: "#DDDDDD"; duration: 300 }
            ColorAnimation { target: seenMarker; property: "color"; to: "black"; duration: 300 }
            NumberAnimation { target: iconItem; property: "opacity"; to: 0.2; duration: 300 }
        }
        PauseAnimation { duration: 100 }
        ScriptAction { script: { backAnimation.animEnded = true; listItem.pressAndHold(); } }
        onRunningChanged: {
            if (!running) {
                iconItem.opacity = 1.0
                mainText.color = highlighted ? listItem.highlightColor : listItem.titleColor
                subText.color = highlighted ? listItem.highlightColor : listItem.subtitleColor
                thirdText.color = highlighted ? listItem.highlightColor : listItem.subtitleColor
                timing.color = highlighted ? listItem.highlightColor : listItem.subtitleColor
                seenMarker.color = UI.SPOTIFY_COLOR
            }
        }
    }

    onHighlightedChanged: {
        mainText.color = highlighted ? listItem.highlightColor : listItem.titleColor
        subText.color = highlighted ? listItem.highlightColor : listItem.subtitleColor
        timing.color = highlighted ? listItem.highlightColor : listItem.subtitleColor
        thirdText.color = highlighted ? listItem.highlightColor : listItem.subtitleColor
    }

    Rectangle {
        id: background
        anchors.fill: parent
        // Fill page porders
        anchors.leftMargin: -units.gu(UI.MARGIN_XLARGE)
        anchors.rightMargin: -units.gu(UI.MARGIN_XLARGE)
        opacity: mouseArea.pressed ? 1.0 : backgroundOpacity
        color: "#15000000"
    }

    Rectangle {
        id: seenMarker
        visible: !listItem.seen
        anchors.verticalCenter: parent.verticalCenter
        height: listItem.height - units.gu(UI.MARGIN_XLARGE) - 8
        width: 6
        color: UI.SPOTIFY_COLOR
        anchors.left: parent.left
        anchors.leftMargin: -units.gu(UI.MARGIN_XLARGE) / 2 - width / 2 - 1
    }

    Column {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        opacity: listItem.available ? 1.0 : 0.3

        Item {
            height: mainText.height
            anchors.left: parent.left
            anchors.right: parent.right
            Label {
                id: mainText
                height: 34
                anchors.left: parent.left
                anchors.right: iconItem.left
                anchors.rightMargin: units.gu(UI.MARGIN_XLARGE)
                font.family: listItem.titleFont
                font.weight: Font.Bold
                font.pixelSize: listItem.titleSize
                color: highlighted ? listItem.highlightColor : listItem.titleColor
                elide: Text.ElideRight
                clip: true
                Behavior on color { ColorAnimation { duration: 200 } }
            }
            Icon {
                id: iconItem
                anchors.right: parent.right
                anchors.bottom: mainText.bottom
                anchors.bottomMargin: 2
                width: 34; height: width
                color: "black"
                visible: listItem.starred
                name: "starred"
            }
        }

        Item {
            height: subText.height
            anchors.left: parent.left
            anchors.right: parent.right
            Label {
                id: subText
                height: 29
                anchors.left: parent.left
                anchors.right: timing.left
                anchors.rightMargin: units.gu(UI.MARGIN_XLARGE)
                font.family: listItem.subtitleFont
                font.pixelSize: listItem.subtitleSize
                font.weight: Font.Light
                color: highlighted ? listItem.highlightColor : listItem.subtitleColor
                elide: Text.ElideRight
                clip: true
                visible: text != ""
                Behavior on color { ColorAnimation { duration: 200 } }
            }
            Label {
                id: timing
                font.family: listItem.subtitleFont
                font.weight: Font.Light
                font.pixelSize: listItem.subtitleSize
                color: highlighted ? listItem.highlightColor : listItem.subtitleColor
                anchors.right: parent.right
                visible: text != ""
                Behavior on color { ColorAnimation { duration: 200 } }
            }
        }

        Label {
            id: thirdText
            anchors.left: parent.left
            anchors.right: parent.right
            height: 30
            verticalAlignment: Text.AlignBottom
            font.family: listItem.subtitleFont
            font.pixelSize: units.gu(UI.FONT_SMALL)
            font.weight: Font.Light
            color: highlighted ? listItem.highlightColor : listItem.subtitleColor
            elide: Text.ElideRight
            Behavior on color { ColorAnimation { duration: 200 } }
        }
    }

    MouseArea {
        id: mouseArea;
        anchors.fill: parent
        onClicked: {
            if (!backAnimation.animEnded)
                listItem.clicked();
        }
    }
}
