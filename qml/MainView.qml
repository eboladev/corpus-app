import QtQuick 2.0
import "material"

Item {
    id: view
    anchors.fill: parent

    property bool loading: false

    ActionBar {
        id: actionBar
        raised: posts.contentY > height
        color: "#00796b"
        text: "Corpus"
        z: 2

        MouseArea {
            anchors.fill: parent
            onDoubleClicked: scrollToTopAnimation.start()
        }

        IconButton {
            id: menuButton
            anchors.left: parent.left
            anchors.leftMargin: 16 * dp
            anchors.verticalCenter: parent.verticalCenter

            iconSource: "qrc:/assets/icon_menu"
        }

        RefreshButton {
            id: refreshButton
            anchors.right: parent.right
            anchors.rightMargin: 16 * dp
            anchors.verticalCenter: parent.verticalCenter

            loading: view.loading
            onClicked: load()
        }
    }

    ListView {
        id: posts
        anchors.fill: parent
        anchors.topMargin: actionBar.height
        cacheBuffer: height * 4

        topMargin: 8 * dp
        bottomMargin: 8 * dp
        leftMargin: 8 * dp
        rightMargin: 8 * dp
        spacing: 8 * dp

        interactive: !postView.visible

        model: ListModel {}

        delegate: Component {
            Card {
                id: __postCard
                width: parent.width - 16 * dp
                height: __postCardLayout.height

                PostCardLayout {
                    id: __postCardLayout
                    post: model
                }

                onClicked: {
                    postView.post = model
                    postView.postId = model.postId
                    postView.cardY = __postCard.y - posts.contentY
                    postView.show()
                }
            }
        }

        NumberAnimation on contentY {
            id: scrollToTopAnimation
            to: posts.originY
            duration: 300
            easing.type: Easing.OutCubic
            onStopped: posts.returnToBounds()
        }
    }

    FloatingActionButton {
        id: addButton
        anchors {
            right: parent.right
            bottom: parent.bottom
            margins: 16 * dp
        }

        color: "#795548"
        iconSource: "qrc:/assets/icon_add"

        onClicked: postDialog.open()
    }

    function load() {
        view.loading = true
        api.posts(function(e) {
            e = JSON.parse(e)
            posts.model.clear()
            for (var i in e)
                posts.model.append(e[i])
            view.loading = false
        })
    }

    Component.onCompleted: load()
}
