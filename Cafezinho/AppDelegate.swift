import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    private var statusItem: NSStatusItem?

    func applicationDidFinishLaunching(_ notification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)

        if let button = statusItem?.button {
            button.title = "☕"
            button.action = #selector(toggleSleep)
            button.target = self
        }
    }

    @objc private func toggleSleep() {
        // Placeholder — wired up in Step 3
        print("toggle")
    }
}
