import QtQuick
import Quickshell
import Quickshell.Io
import qs.Ui
import qs.Commons

BarWidget {
  id: root
  moduleName: "katt.input-method"

  // fcitx5 has no D-Bus signal for input method changes, so poll its
  // current one. Polling also catches switches made with CTRL + SPACE.
  property string inputMethod: ""
  readonly property var labels: ({ "keyboard-us": "EN", "bamboo": "VI" })
  readonly property string label: labels[inputMethod] || inputMethod.toUpperCase()

  function toggle() {
    if (!root.bar) return
    root.bar.run("fcitx5-remote -t")
    pollTimer.restart()
    queryProc.running = true
  }

  Process {
    id: queryProc
    command: ["fcitx5-remote", "-n"]
    stdout: StdioCollector {
      waitForEnd: true
      onStreamFinished: root.inputMethod = (text || "").trim()
    }
  }

  Timer {
    id: pollTimer
    interval: 500
    running: true
    repeat: true
    triggeredOnStart: true
    onTriggered: if (!queryProc.running) queryProc.running = true
  }

  visible: label !== ""
  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  WidgetButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    text: root.label
    fontSize: Style.font.caption
    horizontalMargin: 6
    tooltipText: "Input method: " + root.inputMethod
    onPressed: function() { root.toggle() }
  }
}
