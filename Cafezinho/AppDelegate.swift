import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    private var statusItem: NSStatusItem?
    private var isActive = false

    func applicationDidFinishLaunching(_ notification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)

        if let button = statusItem?.button {
            button.action = #selector(toggleSleep)
            button.target = self
        }

        updateIcon()
    }

    @objc private func toggleSleep() {
        isActive.toggle()
        updateIcon()
        // Sleep prevention wired up in Step 3
    }

    private func updateIcon() {
        guard let button = statusItem?.button else { return }

        if isActive {
            let image = NSImage(systemSymbolName: "cup.and.saucer.fill", accessibilityDescription: "Cafezinho active")
            image?.isTemplate = false
            button.image = tinted(image, color: NSColor(red: 1.0, green: 0.75, blue: 0.1, alpha: 1.0))
        } else {
            let image = NSImage(systemSymbolName: "cup.and.saucer", accessibilityDescription: "Cafezinho inactive")
            image?.isTemplate = true
            button.image = image
        }
    }

    private func tinted(_ source: NSImage?, color: NSColor) -> NSImage? {
        guard let source else { return nil }
        let size = source.size
        let tinted = NSImage(size: size)
        tinted.lockFocus()
        color.set()
        source.draw(in: NSRect(origin: .zero, size: size),
                    from: NSRect(origin: .zero, size: size),
                    operation: .sourceAtop,
                    fraction: 1.0)
        tinted.unlockFocus()
        return tinted
    }
}
