import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts

Scope {
    id: root

    // ── Theme (Nix-generated) ───────────────────────────────────
    property color bg: "@bg@"
    property color fg: "@fg@"
    property color accent: "@accent@"
    property color surface: "@surface@"

    // ── Script output properties ─────────────────────────────────
    property string batteryText: ""
    property string memoryText: ""
    property string volumeText: ""
    property string networkText: ""
    property string openrouterText: ""

    // ── Battery (every 10s) ──────────────────────────────────────
    Process {
        id: batteryProc
        command: ["sh", "-c", "$HOME/.config/quickshell/scripts/battery"]
        running: true
        stdout: SplitParser {
            onRead: data => batteryText = data.trim()
        }
    }
    Timer {
        interval: 10000; running: true; repeat: true
        onTriggered: batteryProc.running = true
    }

    // ── Memory (every 5s) ────────────────────────────────────────
    Process {
        id: memoryProc
        command: ["sh", "-c", "$HOME/.config/quickshell/scripts/memory"]
        running: true
        stdout: SplitParser {
            onRead: data => memoryText = data.trim()
        }
    }
    Timer {
        interval: 5000; running: true; repeat: true
        onTriggered: memoryProc.running = true
    }

    // ── Volume (every 1s) ────────────────────────────────────────
    Process {
        id: volumeProc
        command: ["sh", "-c", "$HOME/.config/quickshell/scripts/volume"]
        running: true
        stdout: SplitParser {
            onRead: data => volumeText = data.trim()
        }
    }
    Timer {
        interval: 1000; running: true; repeat: true
        onTriggered: volumeProc.running = true
    }

    // ── Network (every 5s) ───────────────────────────────────────
    Process {
        id: networkProc
        command: ["sh", "-c", "$HOME/.config/quickshell/scripts/network"]
        running: true
        stdout: SplitParser {
            onRead: data => networkText = data.trim()
        }
    }
    Timer {
        interval: 5000; running: true; repeat: true
        onTriggered: networkProc.running = true
    }

    // ── OpenRouter (every 60s) ───────────────────────────────────
    Process {
        id: openrouterProc
        command: ["sh", "-c", "$HOME/.config/quickshell/scripts/openrouter"]
        running: true
        stdout: SplitParser {
            onRead: data => openrouterText = data.trim()
        }
    }
    Timer {
        interval: 60000; running: true; repeat: true
        onTriggered: openrouterProc.running = true
    }

    // ── OpenRouter display formatter ─────────────────────────────
    function formatOpenrouter(raw) {
        if (!raw || raw === "") return "󱚣 --";
        try {
            var data = JSON.parse(raw);
            if (data.pct === "--" || data.remaining === "--") return "󱚣 --";
            return "󱚣 " + data.pct + "% [$" + data.remaining + "]";
        } catch (e) {
            return "󱚣 --";
        }
    }

    // ── Bar window ───────────────────────────────────────────────
    PanelWindow {
        anchors {
            top: true
            left: true
            right: true
        }
        implicitHeight: 26
        color: root.bg

        RowLayout {
            anchors.fill: parent
            spacing: 0

            // ── Left: launcher + workspaces ──────────────────────
            RowLayout {
                Layout.alignment: Qt.AlignLeft
                spacing: 0

                // Launcher icon
                Rectangle {
                    color: root.surface
                    Layout.preferredHeight: 26
                    Layout.preferredWidth: launcherLabel.implicitWidth + 30
                    radius: 15

                    Text {
                        id: launcherLabel
                        anchors.centerIn: parent
                        text: ""
                        color: root.accent
                        font.family: "Fira Code Nerd Font"
                        font.pixelSize: 18
                    }
                }

                Item { Layout.preferredWidth: 20 }

                // Workspace indicators 1-10
                RowLayout {
                    spacing: 3

                    Repeater {
                        model: 10

                        Text {
                            required property int index
                            property int wsNumber: index + 1
                            property bool active: Hyprland.focusedWorkspace !== null
                                                  && Hyprland.focusedWorkspace.id === wsNumber

                            text: active ? "󱓻" : (wsNumber === 10 ? "0" : wsNumber.toString())
                            color: active ? root.accent : root.fg
                            font.family: "Fira Code Nerd Font"
                            font.pixelSize: 14
                            horizontalAlignment: Text.AlignHCenter
                            Layout.preferredWidth: 20

                            MouseArea {
                                anchors.fill: parent
                                onClicked: Hyprland.dispatch("workspace " + wsNumber)
                            }
                        }
                    }
                }
            }

            Item { Layout.fillWidth: true }

            // ── Center: clock ────────────────────────────────────
            Text {
                id: clock
                Layout.alignment: Qt.AlignCenter
                text: "  " + Qt.formatDateTime(new Date(), "ddd, MMM dd h:mm AP")
                color: root.fg
                font.family: "Fira Code Nerd Font"
                font.pixelSize: 14

                Timer {
                    interval: 30000; running: true; repeat: true
                    onTriggered: clock.text = "  " + Qt.formatDateTime(new Date(), "ddd, MMM dd h:mm AP")
                }
            }

            Item { Layout.fillWidth: true }

            // ── Right: openrouter, network, volume, memory, battery
            RowLayout {
                Layout.alignment: Qt.AlignRight
                spacing: 15

                Text {
                    text: formatOpenrouter(openrouterText)
                    color: root.accent
                    font.family: "Fira Code Nerd Font"
                    font.pixelSize: 14
                }
                Text {
                    text: networkText
                    color: root.fg
                    font.family: "Fira Code Nerd Font"
                    font.pixelSize: 14
                }
                Text {
                    text: volumeText
                    color: root.fg
                    font.family: "Fira Code Nerd Font"
                    font.pixelSize: 14
                }
                Text {
                    text: memoryText
                    color: root.fg
                    font.family: "Fira Code Nerd Font"
                    font.pixelSize: 14
                }
                Text {
                    text: batteryText
                    color: root.fg
                    font.family: "Fira Code Nerd Font"
                    font.pixelSize: 14
                }

                Item { Layout.preferredWidth: 8 }
            }
        }
    }
}
