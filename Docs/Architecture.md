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
GinTonicDatabase/
├── App/
│   ├── GinTonicDatabaseApp.swift      # @main entry point, ModelContainer setup
│   ├── ContentView.swift              # Root NavigationSplitView / TabView
│   └── Resources/
│       └── Seeds/
│           ├── gins.json
│           ├── tonics.json
│           ├── garnishes.json
│           └── pairings.json
├── Models/
│   ├── Gin.swift
│   ├── Tonic.swift
│   ├── Garnish.swift
│   ├── GinTonicPairing.swift
│   ├── Recipe.swift
│   └── Enums/
│       ├── GinStyle.swift
│       ├── TonicStyle.swift
│       ├── GarnishCategory.swift
│       ├── FlavorTag.swift
│       ├── GlassType.swift
│       ├── IceType.swift
│       └── PairingSource.swift
├── Views/
│   ├── Gin/
│   │   ├── GinListView.swift
│   │   ├── GinRowView.swift
│   │   ├── GinDetailView.swift
│   │   ├── GinEditorView.swift
│   │   └── TasteProfileView.swift
│   ├── Tonic/
│   │   ├── TonicListView.swift
│   │   └── TonicDetailView.swift
│   ├── Pairing/
│   │   ├── PairingMatrixView.swift    # The key differentiator: gin × tonic grid
│   │   ├── PairingDetailView.swift
│   │   └── PairingEditorView.swift
│   ├── Recipe/
│   │   ├── RecipeListView.swift
│   │   ├── RecipeDetailView.swift
│   │   └── RecipeEditorView.swift
│   ├── Garnish/
│   │   └── GarnishPickerView.swift
│   └── Shared/
│       ├── RatingView.swift           # Star rating component
│       ├── FlavorTagView.swift        # Flavor tag chips
│       ├── VolumeSliderView.swift     # Gin/tonic volume pickers
│       └── EmptyStateView.swift
├── ViewModels/
│   ├── GinListViewModel.swift
│   ├── PairingMatrixViewModel.swift
│   └── RecipeEditorViewModel.swift
├── Services/
│   ├── SeedDataService.swift          # Parses JSON, inserts into Swift Data on first launch
│   └── ModelContainerFactory.swift    # Builds ModelContainer (local or CloudKit)
└── Docs/                              # Planning and reference (this folder)
```

## Data Flow

```
JSON seed files
      │
      ▼  (first launch only)
SeedDataService ──► Swift Data store (local SQLite)
                           │
                    CloudKit sync ◄──── iCloud account (optional)
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
├── 🍸 Gins tab       → NavigationStack → GinListView → GinDetailView → PairingDetailView
├── 🫧 Tonics tab     → NavigationStack → TonicListView → TonicDetailView
├── 🔀 Pairings tab   → NavigationStack → PairingMatrixView → PairingDetailView
├── 📋 My Recipes tab → NavigationStack → RecipeListView → RecipeDetailView
└── ⚙️ Settings tab
```

### macOS / iPad (regular width)
```
NavigationSplitView
├── Sidebar
│   ├── Gins
│   ├── Tonics
│   ├── Pairing Matrix
│   ├── My Recipes
│   └── Settings
├── Content column  (list for current section)
└── Detail column   (detail / editor view)
```

## Screen Inventory

### Gin Browser
- Filter bar: style, country, flavor tags, user-added / curated
- Sort: A–Z, ABV, country, rating
- Grid (macOS) / list (iPhone) layout
- Search bar (name, distillery, botanical)

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

## CloudKit Sync Strategy

- `ModelConfiguration` with `.cloudKitDatabase(.private)` for user data
- Seed / curated data is **read-only** and not synced (local only, re-seeded from bundle if needed)
- User-created gins, pairings, recipes, and ratings sync via CloudKit private database
- No CloudKit entitlement needed for v1 if sync is deferred; add it in a minor update

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
