import QtQuick 2.0
import QtQuick.Controls 1.4
import QtGraphicalEffects 1.13

Item {
  id: loginFrame

  width: page.width
  height: page.height
  anchors.horizontalCenter: page.horizontalCenter
  anchors.verticalCenter: page.verticalCenter

  property string name
  property string realName
  property string icon
  focus: false

  Behavior on opacity {
    NumberAnimation { duration: 200; easing.type: Easing.InOutQuad }
  }

  //Functions:

  //Logins in with current details
  function login() {
    loginFrame.opacity = 0;
    sddm.login(loginFrame.name, passwordInput.text, sessionSelect.currentIndex);
  }

  //Goes back to user select
  function back() {
    page.state = "";
    listView.focus = true;
  }

  function focusPassword() {
    passwordInput.focus = true;
  }

  KeyNavigation.tab: passwordInput
  Keys.onEscapePressed: back()

  Connections {
    target: sddm
    onLoginSucceeded: {
    }

    onLoginFailed: {
      loginFrame.opacity = 1;
      passwordInput.text = ""
      passwordStatus.opacity = 1;
      passwordTimer.start();
    }
  }

  states: State {
      name: "active"
      when: passwordInput.activeFocus == true || passwordInput.text != ""

      PropertyChanges {
        target: defaultPasswordText
        opacity: 0
      }

      PropertyChanges {
        target: submitPassword
        opacity: 1
      }

      PropertyChanges {
        target: passwordUnderline
        height: 50
      }
  }

  transitions: Transition {
    from: ""
    to: "active"
    reversible: true

    PropertyAnimation {
      properties: "opacity"
      easing.type: Easing.InOutQuad
      duration: 100
    }

    PropertyAnimation {
      properties: "height"
      easing.type: Easing.InOutQuad
      duration: 100
    }
  }

  //Back Button
  Image {

    anchors {
      right: userProfile.left
      rightMargin: 30
    }
    y: parent.height / 2
    width: 32
    height: 32
    source: "Assets/Selector.png"
    transform: Rotation { origin.x : 16; origin.y: 16; angle: 270}

    MouseArea {
      anchors.fill: parent
      onClicked: {
        loginFrame.back();
      }
    }
  }


  Item {
    id: userProfile

    width: 200
    height: 350

    y:0
    anchors {
      horizontalCenter: parent.horizontalCenter
      verticalCenter: parent.verticalCenter
    }

    //User's Name
    Text {
      id: usersName

      color: (config.darkText == "true") ? "#111" : "white"
      font {
        family: config.fontFamily
        pointSize: (config.HiDPI == "true") ? 20 : 32
      }
      text: config.showGreeting ? config.greeting + ", " + loginFrame.realName.split(" ")[0] : loginFrame.realName
      anchors.horizontalCenter: parent.horizontalCenter
    }

    // Border around profile
    Rectangle {
      id: profileBorder
      width: 138
      height: 138
      radius: 69
      anchors {
        top: usersName.bottom
        topMargin: 45
        horizontalCenter: parent.horizontalCenter
      }
      color: (config.darkText == "true") ? "#111" : "white"
    }

    // User's Profile Pic
    Image {
      id: usersPic

      width: 128
      height: 128
      anchors {
        top: usersName.bottom
        topMargin: 50
        horizontalCenter: parent.horizontalCenter
      }
      source: icon
      layer.enabled: true
      layer.effect: OpacityMask {
        maskSource: profileMask
      }
    }

    // Mask for profile image
    Rectangle {
      id: profileMask
      width: 128
      height: 128
      radius: 64
      visible: false
    }

  }

  Text {
    id: passwordStatus

    text: "Incorrect Password!"
    color: (config.darkText == "true") ? "#111" : "white"
    font {
      pointSize: 8
      family: config.fontFamily
    }

    anchors {
      horizontalCenter: parent.horizontalCenter
      bottom: passwordBox.top
      bottomMargin: 20
    }

    opacity: 0

    Timer {
      id: passwordTimer
      interval: 3000
      running: false
      repeat: false
      onTriggered: {
        passwordStatus.opacity = 0
      }
    }

    Behavior on opacity {
      NumberAnimation{
        duration: 500
        easing.type: Easing.InOutQuad
      }
    }

  }

  Item {
    id: passwordBox

    width: 300
    height: 50
    anchors {
      horizontalCenter: parent.horizontalCenter
      top: userProfile.bottom
      topMargin: -75
    }

    Text {
      id: defaultPasswordText

      anchors {
        fill: parent
        topMargin: 15
        leftMargin: 15
      }
      text: "Password"
      color: (config.darkText == "true") ? "#111" : "white"
      font {
        pointSize: 10
        family: config.fontFamily
      }
      opacity: 0.3
    }

    TextInput {
      id: passwordInput

      verticalAlignment: TextInput.AlignVCenter
      anchors {
        fill: parent
        leftMargin: 15
        rightMargin: 50
      }
      font {
        pointSize: (config.HiDPI == "true") ? 8 : 16
        family: config.fontFamily
        letterSpacing: 2
      }
      color: (config.darkText == "true") ? "#111" : "white"
      echoMode:TextInput.Password
      clip: true

      onAccepted: {
        loginFrame.login()
      }

    }

    Image {
      id: submitPassword

      x: 260
      y: 10
      width: 30
      height: 30
      opacity: 0
      source: (config.darkText == "true") ? "Assets/svg/dark/arrow-right.svg" : "Assets/svg/light/arrow-right.svg"

      MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor

        onClicked: {
          loginFrame.login()
        }
      }
    }
  }

  Rectangle {
    id: passwordUnderline

    width: passwordBox.width
    height: 1
    anchors {
      bottom: passwordBox.bottom
      left: passwordBox.left
    }
    color: (config.darkText == "true") ? "#111" : "white"
    opacity: 0.3
    radius: 10
  }
}
