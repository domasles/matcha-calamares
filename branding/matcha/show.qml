import QtQuick 2.0;
import calamares.slideshow 1.0

Presentation {
    id: presentation

    Slide {
        anchors.fill: parent

        Image {
            source: "slide.png"
            anchors.fill: parent
            fillMode: Image.PreserveAspectCrop
        }
    }
}
