# Xcode Project Setup — The Gintastic Serve

All Swift source files are ready in `GintasticServe/`. Follow these steps to create the Xcode project and wire everything together.

---

## 1. Create the Xcode project

1. Open Xcode → **File › New › Project**
2. Choose **Multiplatform › App** → Next
3. Fill in:
   | Field | Value |
   |-------|-------|
   | Product Name | `GintasticServe` |
   | Team | Your Apple Developer account |
   | Organisation Identifier | `com.yourname.gintasticserve` |
   | Bundle Identifier | `com.yourname.GintasticServe` |
   | Storage | **None** (Swift Data added manually) |
   | Host in CloudKit | ❌ unchecked |
4. Save into `/Users/michael/Projects/Gin_Tonic_Database/`  
   → Xcode creates `GintasticServe.xcodeproj` in that folder.

---

## 2. Replace the generated source files

Xcode generates `ContentView.swift` and `<AppName>App.swift`. Replace them:

1. In the Xcode project navigator, delete the auto-generated files (**Move to Trash**).
2. Drag the entire `GintasticServe/` source folder into the project navigator.
3. In the "Add files" sheet: check **"Copy items if needed"** = ❌ (they're already in place), **Add to targets** = ✅ both iOS and macOS targets.

---

## 3. Add seed JSON files as bundle resources

1. In Finder, the JSON files are at `Seeds/*.json` (project root).  
   Create a **group** in Xcode called `Resources/Seeds` inside the `App/` group.
2. Drag the four JSON files into that group.
3. In the "Add files" sheet: **Add to targets** = ✅ both targets.
4. Verify: select each `.json` file → inspect **Target Membership** in the File Inspector — both targets should be checked.

---

## 4. Add SwiftData capability

SwiftData is a system framework — no package dependency needed.

In each target (iOS + macOS):
1. Select the target → **Signing & Capabilities**
2. No special capability needed for local-only storage.  
   (For CloudKit in v1.x: add **iCloud** capability and check **CloudKit**.)

---

## 5. Set deployment targets

| Target | Minimum |
|--------|---------|
| iOS | **17.0** |
| macOS | **14.0 (Sonoma)** |

Set these in each target's **General → Minimum Deployments**.

---

## 6. Verify the build

```
⌘B  (Build)
```

Expected: **Build Succeeded** with no errors.  
If you see "Cannot find type X": confirm all source files are added to both targets.

Common issues:
| Error | Fix |
|-------|-----|
| `Cannot find type 'SeedDataService'` | File not added to target |
| `No such module 'SwiftData'` | Deployment target < iOS 17 / macOS 14 |
| Missing seed JSON at runtime | JSON files not added as bundle resources |

---

## 7. Run the app

- **iPhone Simulator**: select any iPhone 17+ device → ▶
- **macOS**: select "My Mac" target → ▶
- On first launch: cabinet is empty → tap **Discover** → search "Hendrick's" → add to cabinet.

---

## Project structure at a glance

```
GintasticServe.xcodeproj
GintasticServe/
├── App/
│   ├── GintasticServeApp.swift
│   ├── ContentView.swift
│   └── Resources/Seeds/  ← gins.json, tonics.json, garnishes.json, pairings.json
├── Models/
│   ├── Gin.swift  Tonic.swift  Garnish.swift  GinTonicPairing.swift  Recipe.swift
│   ├── Enums/     (8 enum files)
│   └── Seed/      (4 Codable structs)
├── Views/
│   ├── Cabinet/   Discover/   Tonic/   Pairing/   Recipe/   Garnish/   Settings/   Shared/
├── ViewModels/    (4 files)
└── Services/      (2 files)
Seeds/             ← source JSON (symlinked / referenced from bundle)
Docs/              ← this file + DataModel.md + Architecture.md
```
