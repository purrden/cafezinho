# Cafezinho — Implementation Plan

## Step 1: Project Setup
Create a new macOS app in Xcode as an **LSUIElement** (menu bar agent — no Dock icon, no main window). Set deployment target, configure `Info.plist` with `LSUIElement = YES` to suppress the Dock presence.

## Step 2: Menu Bar Icon & Toggle
Set up `NSStatusBar` with a single `NSStatusItem`. Wire a click handler that toggles between the two states (inactive / active) and swaps the icon accordingly. This is the core interaction loop.

## Step 3: Sleep Prevention via IOKit
In the active state, call `IOPMAssertionCreateWithName` with assertion type `kIOPMAssertionTypeNoDisplaySleep` (covers both plugged-in and battery). Store the returned `IOPMAssertionID` and release it with `IOPMAssertionRelease` when deactivated.

## Step 4: Custom Icons
Create two `NSImage` assets:
- **Inactive**: outlined white cup (template image so it adapts to light/dark menu bar)
- **Active**: filled amber cup with three rising steam curves above it

Draw them as PDF/SVG vectors in Sketch or directly as SF Symbols composites, export at 18×18pt @1x and @2x.

## Step 5: Build & Package
Archive the app, strip the entitlements to the minimum required (no sandboxing needed for `IOPMAssertion`), and export as a self-contained `.app`. Optionally add a `Makefile` target for `xcodebuild` so the build is one command.
