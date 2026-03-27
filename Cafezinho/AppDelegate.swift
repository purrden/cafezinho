import Cocoa
import IOKit.pwr_mgt

class AppDelegate: NSObject, NSApplicationDelegate {

    private var statusItem: NSStatusItem?
    private var isActive = false
    private var assertionID: IOPMAssertionID = 0

    func applicationDidFinishLaunching(_ notification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        if let button = statusItem?.button {
            button.action = #selector(toggleSleep)
            button.target = self
        }

        updateIcon()
    }

    @objc private func toggleSleep() {
        isActive ? deactivate() : activate()
    }

    private func activate() {
        let result = IOPMAssertionCreateWithName(
            kIOPMAssertPreventUserIdleDisplaySleep as CFString,
            IOPMAssertionLevel(kIOPMAssertionLevelOn),
            "Cafezinho" as CFString,
            &assertionID
        )
        guard result == kIOReturnSuccess else { return }
        isActive = true
        updateIcon()
    }

    private func deactivate() {
        IOPMAssertionRelease(assertionID)
        assertionID = 0
        isActive = false
        updateIcon()
    }

    private func updateIcon() {
        guard let button = statusItem?.button else { return }

        let symbolName = isActive ? "cup.and.saucer.fill" : "cup.and.saucer"
        var config = NSImage.SymbolConfiguration(scale: .medium)
        if isActive {
            let amber = NSColor(red: 1.0, green: 0.75, blue: 0.1, alpha: 1.0)
            config = config.applying(NSImage.SymbolConfiguration(paletteColors: [amber]))
        }
        let image = NSImage(systemSymbolName: symbolName, accessibilityDescription: nil)?
            .withSymbolConfiguration(config)
        image?.isTemplate = !isActive
        button.image = image
    }
}
