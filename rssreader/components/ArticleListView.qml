import QtQuick 2.0
import QtQuick.XmlListModel 2.0
import Ubuntu.Components 1.3

Item {
    id: root
    signal clicked(var instance)
    property alias currentIndex : listView.currentIndex
    property alias model: listView.model
    property alias listview: listView

    function reload() {
        console.log('reloading')
        model.clear();
        picoRssModel.reload()
    }

    ListModel {
        id: model
    }

    XmlListModel {
        id: picoRssModel
        source: "http://my.poco.cn/rss_gen/poco_rss_channel.photo.php?sub_icon=figure"
        query: "/rss/channel/item[child::enclosure]"

        onStatusChanged: {
            if (status === XmlListModel.Ready) {
                for (var i = 0; i < count; i++) {
                    // console.log("title: " + get(i).title);
                    // console.log("published: " + get(i).published );
                    // console.log("image: " + get(i).image);
                    // console.log("image: " + get(i).content);

                    var title = get(i).title.toLowerCase();
                    var published = get(i).published.toLowerCase();
                    var content = get(i).content.toLowerCase();
                    var word = input.text.toLowerCase();

                    if ( (title !== undefined && title.indexOf( word) > -1 )  ||
                            (published !== undefined && published.indexOf( word ) > -1) ||
                            (content !== undefined && content.indexOf( word ) > -1) ) {

                        model.append({"title": get(i).title,
                                         "published": get(i).published,
                                         "content": get(i).content,
                                         "image": get(i).image
                                     })
                    }
                }
            }
        }

        XmlRole { name: "title"; query: "title/string()" }
        XmlRole { name: "published"; query: "pubDate/string()" }
        XmlRole { name: "content"; query: "description/string()" }
        XmlRole { name: "image"; query: "enclosure/@url/string()" }
    }

    UbuntuListView {
        id: listView
        anchors.fill: parent
        clip: true
        visible: true

        model: model

        delegate: ListDelegate {}

        // Define a highlight with customized movement between items.
        Component {
            id: highlightBar
            Rectangle {
                width: 200; height: 50
                color: "#FFFF88"
                y: listView.currentItem.y;
                Behavior on y { SpringAnimation { spring: 2; damping: 0.1 } }
            }
        }

        highlightFollowsCurrentItem: true

        focus: true
        // highlight: highlightBar

        Scrollbar {
            flickableItem: listView
        }

        PullToRefresh {
            onRefresh: {
                reload()
            }
        }
    }
}
