import QtQuick 2.7
import QtGraphicalEffects 1.13
import SddmComponents 2.0

Item {
  id: page
  // Set the width and height to the resolution of your screen using config
  width: config.width
  height: config.height

  //Put everything below the background or it won't be shown
  Image {
    id: background
    anchors.fill: parent
    source: config.background
    asynchronous: true  // For some very large backgrounds, this will improve responsiveness
  }

  // Blurred background
  GaussianBlur {
    id: blurredBackground
    anchors.fill: background
    cached: true
    source: background
    radius: 16
    samples: 16
    visible: false
    opacity: 0
  }

  Login {
    id: loginFrame
    visible: false
    opacity: 0
  }

  PowerFrame {
    id: powerFrame
  }

  // Session list
  Rectangle {
    id: sessionListContainer

    color: (config.darkText == "true") ? "#AA111111" : "#AAFFFFFF"

    anchors {
      bottom: powerFrame.top
      right: page.right
      rightMargin: 35
      bottomMargin: 10
    }

    visible: false
    opacity: 0

    width: sessionSelect.currentItem.width + 10
    height: sessionSelect.count * sessionSelect.currentItem.height + 10
    radius: 10

    ListView {
      id: sessionSelect
      width: currentItem.width + 10
      height: count * currentItem.height + 10
      model: sessionModel
      currentIndex: sessionModel.lastIndex
      flickableDirection: Flickable.AutoFlickIfNeeded
    
      delegate: Item {
        width: 179
        height: 50

        Image {
          width: 24
          height: 24
          anchors.left: parent.left
          anchors.verticalCenter: parent.verticalCenter
          anchors.leftMargin: 5
          source: (config.darkText == "true") ? "Assets/svg/light/check.svg" : "Assets/svg/dark/check.svg"
          opacity: sessionSelect.currentIndex == index ? 1 : 0
        }

        Text {
          width: parent.width
          height: parent.height
          text: name
          color: (config.darkText == "true") ? "white" : "#111"
          opacity: (delegateArea.containsMouse || sessionSelect.currentIndex == index) ? 1 : 0.3
          font {
            pointSize: (config.enableHiDPI == "true") ? 6 : 12
            family: config.fontFamily
          }
          wrapMode: Text.Wrap
          leftPadding: 39
          rightPadding: 5
          horizontalAlignment: Text.AlignLeft
          verticalAlignment: Text.AlignVCenter

          Behavior on opacity {
            NumberAnimation { duration: 100; easing.type: Easing.InOutQuad}
          }
        }

        MouseArea {
          id: delegateArea
          anchors.fill: parent
          hoverEnabled: true
          cursorShape: Qt.PointingHandCursor

          onClicked: {
            sessionSelect.currentIndex = index
            sessionSelect.state = ""
          }
        }
      }

      states: State {
        name: "show"
        PropertyChanges {
          target: sessionListContainer
          visible: true
          opacity: 1
        }
      }

      transitions: [
      Transition {
        from: ""
        to: "show"
        SequentialAnimation {
          PropertyAnimation {
            target: sessionListContainer
            properties: "visible"
            duration: 0
          }
          PropertyAnimation {
            target: sessionListContainer
            properties: "opacity"
            duration: 200
          }
        }
      },
      Transition {
        from: "show"
        to: ""
        SequentialAnimation {
          PropertyAnimation {
            target: sessionListContainer
            properties: "opacity"
            duration: 200
          }
          PropertyAnimation {
            target: sessionListContainer
            properties: "visible"
            duration: 0
          }
        }
      }
      ]
    }
  }
  

  ChooseUser {
    id: listView
    visible: true
    opacity: 1
  }

  states: State {
    name: "login"
    PropertyChanges {
      target: listView
      visible: false
      opacity: 0
    }

    PropertyChanges {
      target: loginFrame
      visible: true
      opacity: 1
    }
    
    PropertyChanges {
        target: blurredBackground
        visible: config.backgroundBlur
        opacity: 1
    }
  }

  transitions: [
  Transition {
    from: ""
    to: "login"
    reversible: false

    SequentialAnimation {
      PropertyAnimation {
        target: listView
        properties: "opacity"
        duration: 200
      }
      PropertyAnimation {
        target: listView
        properties: "visible"
        duration: 0
      }
      PropertyAnimation {
        target: loginFrame
        properties: "visible"
        duration: 0
      }
      PropertyAnimation {
        target: loginFrame
        properties: "opacity"
        duration: 200
      }
      PropertyAnimation {
        target: blurredBackground
        properties: "visible"
        duration: 0
      }
      PropertyAnimation {
        target: blurredBackground
        properties: "opacity"
        duration: 500
      }
    }
  },
  Transition {
    from: "login"
    to: ""
    reversible: false

    SequentialAnimation {
      PropertyAnimation {
        target: loginFrame
        properties: "opacity"
        duration: 200
      }
      PropertyAnimation {
        target: loginFrame
        properties: "visible"
        duration: 0
      }
      PropertyAnimation {
        target: listView
        properties: "visible"
        duration: 0
      }
      PropertyAnimation {
        target: listView
        properties: "opacity"
        duration: 200
      }
      PropertyAnimation {
        target: blurredBackground
        properties: "opacity"
        duration: 500
      }
      PropertyAnimation {
        target: blurredBackground
        properties: "visible"
        duration: 0
      }
    }
  }]

}
