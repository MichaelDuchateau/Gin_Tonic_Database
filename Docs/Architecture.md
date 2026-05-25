# Architecture — Gin & Tonic Database

## Tech Stack

| Layer | Technology | Rationale |
|-------|-----------|-----------|
| UI | SwiftUI (multiplatform) | Single codebase for iOS + macOS; native feel; no UIKit bridges needed |
| State management | `@Observable` macro (Swift 5.9) | Simpler than ObservableObject; no `@Published` boilerplate |
| Persistence | Swift Data | Modern Core Data replacement; `@Model` macro; CloudKit-ready |
| Cloud sync | CloudKit (via Swift Data) | Free for users; seamless iPhone ↔ Mac sync; no backend to maintain |
| Navigation | `NavigationSplitView` (macOS/iPad) + `NavigationStack` (iPhone) | Adaptive to screen size; idiomatic Apple HIG |
| Seed data | Bundled JSON → parsed at first launch | Simple, auditable, version-controlled data |
| Images | AsyncImage + URL cache | Bottle images loaded lazily from brand URLs; no image hosting needed in v1 |
| Minimum OS | iOS 17 / macOS 14 (Sonoma) | Required for Swift Data and @Observable |

## Project Structure

```
GintasticServe/
├── App/
│   ├── GintasticServeApp.swift        # @main, ModelContainer + SeedDataService setup
│   ├── ContentView.swift              # Root: TabView (iPhone) / NavigationSplitView (Mac/iPad)
│   └── Resources/
│       └── Seeds/                     # Bundled JSON — reference only, never written to Swift Data
│           ├── gins.json
│           ├── tonics.json
│           ├── garnishes.json
│           └── pairings.json
├── Models/
│   ├── Gin.swift                      # @Model — cabinetStatus, dateAdded, dateAcquired, seedId
│   ├── Tonic.swift                    # @Model
│   ├── Garnish.swift                  # @Model
│   ├── GinTonicPairing.swift          # @Model — join with volumes, glass, ice, garnishes
│   ├── Recipe.swift                   # @Model — user's named G&T creations
│   ├── Enums/
│   │   ├── CabinetStatus.swift        # .own (green) | .had (grey) | .wishlist (amber)
│   │   ├── GinStyle.swift
│   │   ├── TonicStyle.swift
│   │   ├── GarnishCategory.swift
│   │   ├── FlavorTag.swift
│   │   ├── GlassType.swift
│   │   ├── IceType.swift
│   │   └── PairingSource.swift
│   └── Seed/                          # Codable structs for in-memory seed lookup (NOT @Model)
│       ├── SeedGin.swift
│       ├── SeedTonic.swift
│       ├── SeedGarnish.swift
│       └── SeedPairing.swift
├── Views/
│   ├── Cabinet/                       # My Cabinet tab — user's gins by status
│   │   ├── CabinetView.swift          # Segmented: Own / Had / Wishlist
│   │   ├── GinRowView.swift
│   │   ├── GinDetailView.swift        # Full detail + status transition button
│   │   ├── GinEditorView.swift        # Add / edit gin (pre-filled from seed)
│   │   └── TasteProfileView.swift
│   ├── Discover/                      # Discover tab — seed lookup → web fallback
│   │   ├── DiscoverView.swift         # Search bar → SeedDataService → results list
│   │   └── SeedGinPreviewView.swift   # Preview before "Add to Cabinet"
│   ├── Tonic/
│   │   ├── TonicListView.swift
│   │   └── TonicDetailView.swift
│   ├── Pairing/
│   │   ├── PairingMatrixView.swift    # gin × tonic grid — .own gins only
│   │   ├── PairingDetailView.swift
│   │   └── PairingEditorView.swift
│   ├── Recipe/
│   │   ├── RecipeListView.swift
│   │   ├── RecipeDetailView.swift
│   │   └── RecipeEditorView.swift
│   ├── Garnish/
│   │   └── GarnishPickerView.swift
│   ├── Settings/
│   │   └── SettingsView.swift
│   └── Shared/
│       ├── CabinetStatusBadge.swift   # Coloured status tag chip
│       ├── RatingView.swift           # 1–5 star rating
│       ├── FlavorTagView.swift        # Flavor tag chips
│       ├── VolumeControlView.swift    # Gin / tonic ml steppers
│       └── EmptyStateView.swift
├── ViewModels/
│   ├── CabinetViewModel.swift         # Filters gins by CabinetStatus
│   ├── DiscoverViewModel.swift        # Queries SeedDataService; handles "Add to Cabinet"
│   ├── PairingMatrixViewModel.swift   # Builds gin × tonic matrix from .own gins
│   └── RecipeEditorViewModel.swift
└── Services/
    ├── SeedDataService.swift          # @Observable — loads JSON in-memory; NO Swift Data writes
    └── ModelContainerFactory.swift    # Local-only ModelContainer (no CloudKit in v1)
```

## Data Flow

```
Seeds/gins.json ──► SeedDataService (in-memory [SeedGin])   ← NEVER writes to Swift Data
                           │
                    DiscoverViewModel.search(query:)
                           │
                    User taps "Add to Cabinet"
                           │
                    GinEditorView (pre-filled from SeedGin)
                           │
                    modelContext.insert(Gin(...))
                           │
                    Swift Data store (local SQLite)
                           │
                    @Query / @Environment(\.modelContext)
                           │
                    ViewModels (@Observable)
                           │
                    SwiftUI Views
```

## Navigation Architecture

### iPhone (compact width)
```
TabView
├── 🗄 My Cabinet tab  → NavigationStack → CabinetView (Own/Had/Wishlist segments)
│                                        → GinDetailView → PairingDetailView
├── 🔍 Discover tab    → NavigationStack → DiscoverView (search seed + web fallback)
│                                        → SeedGinPreviewView → GinEditorView
├── 🫧 Tonics tab      → NavigationStack → TonicListView → TonicDetailView
├── 🔀 Pairings tab    → NavigationStack → PairingMatrixView (.own gins only)
│                                        → PairingDetailView / PairingEditorView
├── 📋 My Recipes tab  → NavigationStack → RecipeListView → RecipeDetailView
└── ⚙️ Settings tab
```

### macOS / iPad (regular width)
```
NavigationSplitView
├── Sidebar
│   ├── My Cabinet
│   │   ├── Own  (n)          ← count badge
│   │   ├── Had  (n)
│   │   └── Wishlist  (n)
│   ├── Discover
│   ├── Tonics
│   ├── Pairing Matrix
│   ├── My Recipes
│   └── Settings
├── Content column  (list for current section)
└── Detail column   (detail / editor view)
```

## Screen Inventory

### My Cabinet
- Segmented control: Own / Had / Wishlist (with counts)
- List of gins matching current segment, sorted A–Z (default) or by dateAdded
- Each row: name, distillery, country, ABV, CabinetStatusBadge, star rating
- Swipe actions: transition status, delete
- Toolbar: + button → GinEditorView (blank), search icon

### Discover
- Search bar: queries SeedDataService in-memory by name/distillery/botanical
- Results list: SeedGin rows (not yet in cabinet)
- Tap row → SeedGinPreviewView (read-only seed data: taste profile, botanicals, pairings)
- "Add to Cabinet" sheet → status picker (.wishlist or .own) → GinEditorView pre-filled
- Empty state when no seed match: "Search the web" fallback (v2)

### Gin Detail
- Hero: bottle image (if available), name, distillery, country, ABV badge, style tag
- Taste Profile: nose / palate / finish + flavor tag chips
- Botanicals: scrollable tag list
- Official Site: tappable link chip → opens in-app browser
- Pairings section: cards for each GinTonicPairing (tonic name, garnishes, volumes)
- User section: personal rating, notes, "Add to My Recipes" button

### Pairing Matrix (key differentiator)
- Grid: gins on Y-axis, tonics on X-axis
- Cell shows: ✓ (pairing exists), garnish emoji, or empty
- Tap cell → PairingDetailView (volumes, garnishes, source badge, notes)
- Filter: by gin style, by tonic style
- Color-coded by source (distillery / editorial / user)

### Pairing Detail / Editor
- Gin + Tonic shown as header
- Volumes: stepper or slider (gin ml, tonic ml)
- Glass type picker
- Ice type picker
- Garnish multi-picker (from seed list + user-added)
- Notes text field
- Source badge

### My Recipes
- User's saved named G&T recipes
- Sortable by date, rating, gin name
- Swipe to delete / favorite

### Recipe Editor
- Name field
- Gin picker (searchable)
- Tonic picker (searchable)
- Volume controls
- Garnish picker
- Glass + ice type
- Preparation notes
- Rating

## Storage Strategy — v1

v1 uses a **local-only** Swift Data store. No iCloud entitlement, no CloudKit container.

```swift
// ModelContainerFactory.swift
static func makeContainer() throws -> ModelContainer {
    let config = ModelConfiguration(isStoredInMemoryOnly: false)
    return try ModelContainer(for: Gin.self, Tonic.self, Garnish.self,
                              GinTonicPairing.self, Recipe.self,
                              configurations: config)
}
```

CloudKit sync is a planned v1.x update: swap `ModelConfiguration` for one with `.cloudKitDatabase(.private)` and add the iCloud entitlement — no model changes required.

## Windows v2 Path

| Option | Pros | Cons | Verdict |
|--------|------|------|---------|
| Flutter | True cross-platform; shares JSON data format; good iOS/Android/Windows | Dart, not Swift; separate UI codebase | **Recommended for v2** |
| Progressive Web App (PWA) | One codebase works everywhere; installable on Windows | No native feel; limited local storage APIs | Good fallback if Windows scope is limited |
| Swift on Windows | Familiar language | Not production-ready; no SwiftUI runtime | Not viable yet |
| MAUI (.NET) | Windows-native | Separate language + ecosystem; no Apple advantage | Not recommended |

**Decision: defer Windows to v2 using Flutter.** The JSON seed data format is shared between SwiftUI and Flutter apps, making the data layer portable.

## Open Questions for User (before Phase 4)

1. **CloudKit sync in v1?** (adds iCloud entitlement, TestFlight complexity)
2. **Visual style preference?** Options:
   - Dark, moody lifestyle (rich botanical photography, dark backgrounds)
   - Clean, minimal (white/grey, botanical illustration accents)
   - Vintage / craft label aesthetic
3. **App name?** "Gin Cabinet", "The Serve", "Botanical", "G&T Guide", or your own
4. **User account / community features?** (share pairings, see others' recipes) or purely personal?
