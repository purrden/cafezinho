import Cocoa

enum Icons {
    static let amber = NSColor(red: 1.0, green: 0.75, blue: 0.1, alpha: 1.0)
    private static let size = CGSize(width: 18, height: 18)

    // Outlined white cup — template so it adapts to light/dark menu bar
    static func inactive() -> NSImage {
        let image = NSImage(size: size)
        image.lockFocus()

        NSColor.black.setStroke()
        let body = bodyPath()
        body.lineWidth = 1.4
        body.stroke()

        let handle = handlePath()
        handle.lineWidth = 1.4
        handle.stroke()

        image.unlockFocus()
        image.isTemplate = true
        return image
    }

    // Filled amber cup with three rising steam curves
    static func active() -> NSImage {
        let image = NSImage(size: size)
        image.lockFocus()

        amber.setFill()
        amber.setStroke()

        bodyPath().fill()

        let handle = handlePath()
        handle.lineWidth = 1.4
        handle.stroke()

        for path in steamPaths() {
            path.stroke()
        }

        image.unlockFocus()
        image.isTemplate = false
        return image
    }

    // Cup body: trapezoid, wider at top (opening), narrower at bottom
    private static func bodyPath() -> NSBezierPath {
        let p = NSBezierPath()
        p.move(to: CGPoint(x: 1.5, y: 10.5))   // top-left
        p.line(to: CGPoint(x: 13.5, y: 10.5))  // top-right (inset for handle)
        p.line(to: CGPoint(x: 11.5, y: 2))      // bottom-right
        p.line(to: CGPoint(x: 3.5, y: 2))       // bottom-left
        p.close()
        return p
    }

    // D-shaped handle on the right side of the cup
    private static func handlePath() -> NSBezierPath {
        let p = NSBezierPath()
        p.move(to: CGPoint(x: 13, y: 9))
        p.curve(to: CGPoint(x: 13, y: 4.5),
                controlPoint1: CGPoint(x: 17.5, y: 9),
                controlPoint2: CGPoint(x: 17.5, y: 4.5))
        return p
    }

    // Three S-curve steam lines rising above the cup
    private static func steamPaths() -> [NSBezierPath] {
        func squiggle(x: CGFloat, yBottom: CGFloat, yTop: CGFloat) -> NSBezierPath {
            let p = NSBezierPath()
            p.lineWidth = 1.1
            p.lineCapStyle = .round
            let yMid = (yBottom + yTop) / 2
            p.move(to: CGPoint(x: x, y: yBottom))
            p.curve(to: CGPoint(x: x, y: yTop),
                    controlPoint1: CGPoint(x: x + 2, y: yMid - 1),
                    controlPoint2: CGPoint(x: x - 2, y: yMid + 1))
            return p
        }
        return [
            squiggle(x: 4,   yBottom: 12, yTop: 16.5),
            squiggle(x: 7.5, yBottom: 12.5, yTop: 17),
            squiggle(x: 11,  yBottom: 12, yTop: 16.5),
        ]
    }
}
