import QtQuick 1.1
import com.nokia.meego 1.0

Page {
    id: loginPage
    property alias login: login.text
    property alias password: pass.text
    signal requestLogin;

    Rectangle {
        anchors.fill: parent;
        color: "#4e729a"
        gradient: Gradient {
             GradientStop { position: 0.0; color: "#42658c" }
             GradientStop { position: 1.0; color: "#5a7da5" }
        }
    }

    Image {
        id: logo;
        source: "images/logo_full.png";
        anchors.horizontalCenter: parent.horizontalCenter;
        anchors.bottom: column.top;
        anchors.bottomMargin: 15;
    }

    Column{
        id: column;
        width: parent.width - 40;
        anchors.centerIn: parent;
        spacing: 3;

        TextField {
            id: login;
            width: parent.width;
            placeholderText: qsTr("Email");
            inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhEmailCharactersOnly | Qt.ImhNoPredictiveText;
            platformSipAttributes: SipAttributes {
                actionKeyLabel: qsTr("Next");
            }

            Keys.onReturnPressed: {
                pass.forceActiveFocus();
            }
        }

        TextField {
            id: pass;
            width: parent.width;
            placeholderText: qsTr("Password");
            echoMode: TextInput.Password;
            inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhNoPredictiveText;
            platformSipAttributes: SipAttributes {
                actionKeyLabel: qsTr("Log In");
            }

            Keys.onReturnPressed: {
                if (login.text.length === 0){
                    login.forceActiveFocus();
                    return;
                }
                if (pass.text.length === 0){
                    pass.forceActiveFocus();
                    return;
                }
                parent.focus = true;
                requestLogin();
            }
        }
    }

    QueryDialog {
        id: joinDialog;
        icon: "images/logo.png";
        titleText: "How to Create a Profile";
        message: "You can become a VK user by receiving an invitation from one of the members.\n\n"
        + "When one of your friends invites you, a message with the login and password will be sent "
        + "to your email. No additional actions are required – you can start using your new profile "
        + "right away by entering your login and password.";
        acceptButtonText: "OK";
    }

    Text {
        anchors.top: column.bottom;
        anchors.topMargin: 12;
        anchors.horizontalCenter: parent.horizontalCenter;
        color: "white";
        text: qsTr("Sign up for VKontakte");
        font.pixelSize: login.font.pixelSize * 0.9
        MouseArea{
            anchors.fill: parent;
            onClicked: {
                joinDialog.open();
            }
        }
    }
}
