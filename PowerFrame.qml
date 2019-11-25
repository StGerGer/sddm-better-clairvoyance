import QtQuick 2.0
import QtGraphicalEffects 1.12
import SddmComponents 2.0

Row {
  id: powerFrame

  spacing: 15

  anchors {
      bottom: page.bottom
      right: page.right
      rightMargin: 50
      bottomMargin: 50
  }

  // Shutdown button
  Item {

    width: 32
    height: 32

    //Hover Effect
    DropShadow {
      id: shutdownHover
      anchors.fill: shutdownButton
      source: shutdownButton
      opacity: shutdownArea.containsMouse ? 0.3 : 0
      color: "#111"
      verticalOffset: 3
      horizontalOffset:3
      cached: true
      radius: 6
      samples: 8

      Behavior on opacity {
        NumberAnimation { duration: 350; easing.type: Easing.InOutQuad}
      }
    }

    Image {
      id: shutdownButton
      width: 32
      height: 32
      source: config.darkText ? "Assets/svg/dark/power.svg" : "Assets/svg/light/power.svg"

      MouseArea {
        id: shutdownArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onClicked: sddm.powerOff();
      }
    }
  }

  // Restart button
  Item {

    width: 32
    height: 32

    // Restart hover shadow
    DropShadow {
      id: restartHover
      anchors.fill: restartButton
      source: restartButton
      opacity: restartArea.containsMouse ? 0.3 : 0
      color: "#111"
      verticalOffset: 3
      horizontalOffset:3
      cached: true
      radius: 6
      samples: 8

      Behavior on opacity {
        NumberAnimation { duration: 350; easing.type: Easing.InOutQuad}
      }
    }
    
    Image {
      id: restartButton
      width: 32
      height: 32
      source: config.darkText ? "Assets/svg/dark/refresh-cw.svg" : "Assets/svg/light/refresh-cw.svg"

      MouseArea {
        id: restartArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onClicked: sddm.reboot();
      }
    }
  }
  
  Item {

    width: 32
    height: 32

    // Hover shadow
    DropShadow {
      id: sessionHover
      anchors.fill: sessionButton
      source: sessionButton
      opacity: sessionArea.containsMouse ? 0.3 : 0
      color: "#111"
      verticalOffset: 3
      horizontalOffset:3
      cached: true
      radius: 6
      samples: 8

      Behavior on opacity {
        NumberAnimation { duration: 350; easing.type: Easing.InOutQuad}
      }
    }

    Image {
      id: sessionButton
      width: 32
      height: 32
      source: config.darkText ? "Assets/svg/dark/settings.svg" : "Assets/svg/light/settings.svg"

      MouseArea {
        id: sessionArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onClicked: {
          if (sessionSelect.state == "show")
            sessionSelect.state = "";
          else if (sessionSelect.state == "")
            sessionSelect.state = "show";
        }
      }
    }
  }
  

}
