import QtQuick 2.0

Item {
    width: ListView.view.width
    height: units.gu(14)

    Row {
        spacing: units.gu(1)
        width: parent.width
        height: parent.height
        x: units.gu(0.2)

        Image {
            id: img
            property int borderLength: 2
            source: image
            height: parent.height *.9
            width: height
            anchors.verticalCenter: parent.verticalCenter
        }

        Column {
            id: right
            y: units.gu(1)
            anchors.leftMargin: units.gu(0.1)
            width: parent.width - img.width - parent.spacing
            spacing: units.gu(0.2)


            Text {
                text: {
                    var txt = published.replace("GMT", "");
                    return txt;
                }
                font.pixelSize: units.gu(2)
                font.bold: true
            }

            Text {
                width: parent.width * .9
                text: {
                    var tmp = title.replace("[POCO摄影 - 人像]：", "");

                    if ( tmp.length > 35)
                        return tmp.substring(0, 35) + "...";
                    else
                        return tmp;
                }
                //                wrapMode: Text.Wrap
                clip: true
                font.pixelSize: units.gu(2)
            }
        }
    }

    Image {
        source: "images/arrow.png"
        height: units.gu(1)
        width: height
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.rightMargin: units.gu(1)
        rotation: -90
    }

    MouseArea {
        anchors.fill: parent

        onClicked: {
            console.log("it is clicked");
            console.log("currentidex: " + listView.currentIndex);
            console.log("index: " + index);
            listView.currentIndex = index;
            root.clicked(model);
        }
    }

    Keys.onReturnPressed: {
        console.log("Enter is pressed!");
        listView.currentIndex = index;
        root.clicked(model);
    }
}
