# Data Model — Gin & Tonic Database

Swift Data (`@Model`) entities for iOS 17+ / macOS 14+.

---

## Entity Overview

```
Gin ──< GinTonicPairing >── Tonic
              │
              └──< PairingGarnish >── Garnish

Gin ──< Recipe
Recipe ──< RecipeGarnish >── Garnish
Recipe ──> Tonic
```

---

## Gin

The central entity. Represents a single gin product.

```swift
@Model
final class Gin {
    @Attribute(.unique) var id: UUID
    var name: String                    // "Hendrick's Gin"
    var distillery: String              // "William Grant & Sons"
    var country: String                 // "Scotland"
    var region: String?                 // "Girvan"
    var style: GinStyle                 // .contemporary
    var abv: Double                     // 41.4
    var botanicals: [String]            // ["juniper", "coriander", "cucumber", "rose petal"]
    var tasteNose: String?              // "Floral, rose, cucumber"
    var tastePalate: String?            // "Creamy, citrus, cucumber"
    var tasteFinish: String?            // "Dry, long, floral"
    var flavorTags: [FlavorTag]         // [.floral, .cucumber, .citrus]
    var officialURL: String?            // "https://www.hendricksgin.com"
    var bottleImageURL: String?
    var cabinetStatus: CabinetStatus    // .own | .had | .wishlist  ← replaces isUserAdded
    var dateAdded: Date                 // when user added to cabinet
    var dateAcquired: Date?             // when user bought/received the bottle (optional)
    var userNotes: String?
    var userRating: Int?                // 1–5, nil = unrated
    var updatedAt: Date
    var seedId: String?                 // links back to seed JSON id for auto-fill matching

    // Relationships
    @Relationship(deleteRule: .cascade)
    var pairings: [GinTonicPairing] = []

    @Relationship(deleteRule: .cascade)
    var recipes: [Recipe] = []
}
```

### CabinetStatus enum

```swift
enum CabinetStatus: String, Codable, CaseIterable {
    case own      = "Own"       // user currently owns a bottle — green tag
    case had      = "Had"       // user has finished/tasted it — grey tag
    case wishlist = "Wishlist"  // user wants to try it — amber tag
}
```

**Status transitions:**
| From | Action | To |
|------|--------|----|
| `.wishlist` | "I bought it" | `.own` |
| `.own` | "I finished it" | `.had` |
| `.had` | "Add again" | `.wishlist` |

The transition button appears on `GinDetailView` using `cabinetStatus.nextStatus`.  
`dateAcquired` is set (to now) when transitioning into `.own`.

### GinStyle enum
```swift
enum GinStyle: String, Codable, CaseIterable {
    case londonDry       = "London Dry"
    case contemporary    = "Contemporary"
    case navy            = "Navy Strength"
    case aged            = "Aged / Barrel"
    case sloe            = "Sloe Gin"
    case oldTom          = "Old Tom"
    case genever         = "Genever"
    case american        = "American / New Western"
    case japanese        = "Japanese"
    case other           = "Other"
}
```

### FlavorTag enum
```swift
enum FlavorTag: String, Codable, CaseIterable {
    case juniper, citrus, floral, herbal, spice, earthy,
         sweet, fruity, woody, marine, cucumber, tropical,
         smoky, vegetal, anise
}
```

---

## Tonic

A specific tonic water product.

```swift
@Model
final class Tonic {
    var id: UUID
    var name: String                    // "Premium Indian Tonic Water"
    var brand: String                   // "Fever-Tree"
    var style: TonicStyle               // .indian
    var flavorDescription: String?      // "Clean, balanced quinine bitterness"
    var flavorTags: [FlavorTag]         // [.citrus, .earthy]
    var officialURL: String?
    var isUserAdded: Bool
    var createdAt: Date

    // Relationships
    @Relationship(deleteRule: .cascade)
    var pairings: [GinTonicPairing] = []
}
```

### TonicStyle enum
```swift
enum TonicStyle: String, Codable, CaseIterable {
    case indian          = "Indian"
    case mediterranean   = "Mediterranean"
    case light           = "Light / Slim"
    case aromatic        = "Aromatic"
    case elderflower     = "Elderflower"
    case citrus          = "Citrus"
    case cucumber        = "Cucumber"
    case berry           = "Berry"
    case spiced          = "Spiced"
    case other           = "Other"
}
```

**Seed tonics (minimum viable set):**
| Brand | Product | Style |
|-------|---------|-------|
| Fever-Tree | Premium Indian Tonic Water | Indian |
| Fever-Tree | Mediterranean Tonic Water | Mediterranean |
| Fever-Tree | Light Tonic Water | Light |
| Fever-Tree | Aromatic Tonic Water | Aromatic |
| Fever-Tree | Elderflower Tonic Water | Elderflower |
| Schweppes | Classic Tonic Water | Indian |
| Fentimans | Botanically Brewed Tonic | Indian |
| East Imperial | Yuzu Tonic | Citrus |
| 1724 | Tonic Water | Light |
| Artisan Drinks | Cucumber Tonic Water | Cucumber |

---

## Garnish

A garnish option. Shared across pairings and recipes.

```swift
@Model
final class Garnish {
    var id: UUID
    var name: String                    // "Cucumber ribbon"
    var category: GarnishCategory       // .vegetable
    var preparation: String?            // "Cut into long thin ribbons"
    var isUserAdded: Bool
}
```

### GarnishCategory enum
```swift
enum GarnishCategory: String, Codable, CaseIterable {
    case citrus      = "Citrus"         // lemon, lime, grapefruit, orange
    case herb        = "Herb"           // rosemary, thyme, basil, mint
    case spice       = "Spice"          // pink pepper, star anise, cardamom, cinnamon
    case floral      = "Floral"         // edible flowers, lavender, rose
    case vegetable   = "Vegetable"      // cucumber, celery
    case berry       = "Berry"          // juniper berry, strawberry, raspberry
    case other       = "Other"
}
```

**Seed garnishes (minimum viable set):**
Lemon wedge, Lemon twist, Lime wedge, Grapefruit slice, Orange wheel, Orange twist, Cucumber ribbon, Cucumber slice, Rosemary sprig, Thyme sprig, Basil leaf, Mint sprig, Pink peppercorns, Black pepper, Star anise, Cinnamon stick, Cardamom pod, Edible flower, Lavender sprig, Rose petal, Juniper berries, Strawberry, Raspberry, Elderflower sprig

---

## GinTonicPairing

The core join entity — a specific gin + tonic combination with serve details.  
One `Gin` can have many pairings (one per tonic, potentially several variants).

```swift
@Model
final class GinTonicPairing {
    var id: UUID
    var gin: Gin
    var tonic: Tonic
    var ginVolumeMl: Int                // default: 50
    var tonicVolumeMl: Int              // default: 150
    var glassType: GlassType            // .copa
    var iceType: IceType                // .cubed
    var notes: String?                  // "Best with a slice of lime for extra brightness"
    var source: PairingSource           // .distilleryRecommended
    var isUserFavorite: Bool
    var createdAt: Date

    // Relationships
    @Relationship(deleteRule: .cascade)
    var garnishes: [Garnish] = []       // ordered by preference
}
```

### Supporting enums
```swift
enum GlassType: String, Codable, CaseIterable {
    case copa      = "Copa / Balloon"
    case highball  = "Highball"
    case rocks     = "Rocks / Old Fashioned"
    case flute     = "Flute"
}

enum IceType: String, Codable, CaseIterable {
    case cubed     = "Ice cubes"
    case crushed   = "Crushed ice"
    case sphere    = "Ice sphere"
    case large     = "Large block"
    case none      = "No ice"
}

enum PairingSource: String, Codable, CaseIterable {
    case distilleryRecommended = "Distillery recommended"
    case editorial             = "Editorial / curated"
    case userCreated           = "User created"
}
```

---

## Recipe

A user's saved named G&T creation. Looser than a pairing — free-form, personal.

```swift
@Model
final class Recipe {
    var id: UUID
    var name: String                    // "Sunday Morning G&T"
    var gin: Gin
    var tonic: Tonic
    var ginVolumeMl: Int                // 50
    var tonicVolumeMl: Int             // 150
    var glassType: GlassType
    var iceType: IceType
    var preparationNotes: String?       // "Add gin first, tonic down a spoon, stir once"
    var userRating: Int?                // 1–5
    var isFavorite: Bool
    var createdAt: Date
    var updatedAt: Date

    // Relationships
    @Relationship(deleteRule: .cascade)
    var garnishes: [Garnish] = []
}
```

---

## Seed Data — Reference Layer Only

Seed JSON files are **never imported into Swift Data**. They serve as an in-memory lookup catalogue:

- `SeedDataService` loads all four JSON files into memory at app launch (using `Codable` structs, not `@Model`).
- When a user adds a gin via the **Discover** tab, the app pre-fills the editor from the matching `SeedGin`.
- A `seedId: String?` on the `Gin` model tracks which seed entry it was populated from.
- No `SeedDataService` method ever calls `modelContext.insert(...)`.

```
Seeds/gins.json  ──► SeedDataService (in-memory [SeedGin])
                            │
                     Discover search
                            │
                     User taps "Add to Cabinet"
                            │
                     GinEditorView (pre-filled)
                            │
                     modelContext.insert(Gin(...))  ← only write to Swift Data
```

### gins.json (reference format)
```json
[
  {
    "id": "a1b2c3d4-...",
    "name": "Hendrick's Gin",
    "distillery": "William Grant & Sons",
    "country": "Scotland",
    "region": "Girvan",
    "style": "contemporary",
    "abv": 41.4,
    "botanicals": ["juniper", "coriander seed", "angelica root", "orris root",
                   "cubeb berries", "caraway seeds", "elderflower", "chamomile",
                   "rose petal", "cucumber"],
    "tasteNose": "Floral and sweet with fresh cucumber and rose.",
    "tastePalate": "Creamy body, cucumber, citrus zest, floral notes.",
    "tasteFinish": "Dry, lingering floral and juniper.",
    "flavorTags": ["floral", "cucumber", "citrus", "herbal"],
    "officialURL": "https://www.hendricksgin.com",
    "bottleImageURL": null
  }
]
```

### pairings.json
```json
[
  {
    "id": "...",
    "ginId": "a1b2c3d4-...",
    "tonicId": "...",
    "ginVolumeMl": 50,
    "tonicVolumeMl": 150,
    "glassType": "copa",
    "iceType": "cubed",
    "garnishIds": ["...cucumber-ribbon-id...", "...lime-wedge-id..."],
    "notes": "Hendrick's signature serve. Cucumber ribbon draped inside the copa glass.",
    "source": "distilleryRecommended"
  }
]
```

---

## Minimum iOS/macOS Version Requirements

| Feature | Minimum |
|---------|---------|
| Swift Data (`@Model`) | iOS 17.0 / macOS 14.0 |
| `@Observable` macro | iOS 17.0 / macOS 14.0 |
| NavigationSplitView | iOS 16.0 / macOS 13.0 |
| CloudKit + Swift Data | iOS 17.0 / macOS 14.0 |

**Decision: target iOS 17+ / macOS 14+ (Sonoma).** This covers ~85%+ of active iOS devices as of 2026.
