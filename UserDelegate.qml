import QtQuick 2.0
import QtGraphicalEffects 1.13

Item {

  width: 250
  height: 250

  property string name: model.name
  property string realName: (model.realName === "") ? model.name : model.realName
  property string icon: model.icon

  //User's Name
  Text {
    id: usersName

    color: config.darkText ? "#111" : "white"
    font {
      family: config.fontFamily
      pointSize: 16
    }
    text: realName
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
    color: config.darkText ? "#111" : "white"
  }

  //User's Profile Pic
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

  MouseArea {
    anchors.fill: parent
    onClicked: {
      listView.currentIndex = index;
      page.state = "login";
      loginFrame.name = name
      loginFrame.realName = realName
      loginFrame.icon = icon
      listView.focus = false

	  if (config.autoFocusPassword == "true")
		focusDelay.start();
	  else
        loginFrame.focus = true;
    }
  }

}
