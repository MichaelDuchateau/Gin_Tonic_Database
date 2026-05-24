# Findings & Decisions

## Requirements
- **Platforms:** iOS (primary), macOS (primary), Windows (future v2)
- **Core entities:** Gin, Tonic, Garnish, Pairing (Gin × Tonic × Garnish), Recipe
- **Per-gin data fields:**
  - Name, distillery, country/region
  - Taste profile (botanical notes, flavor keywords)
  - Recommended tonic(s) with rationale
  - Recommended garnish(es)
  - Suggested volumes (ml of gin, ml of tonic, glass type)
  - Official distillery/brand URL
  - Optional: ABV, botanicals list, bottle image URL, user rating
- **Cross-pairing:** Many-to-many between Gin and Tonic, each pairing can carry its own garnish suggestions and volume ratios
- **User input:** CRUD for recipes; possibly community or personal notes on pairings
- **Research goal for Phase 1:** Identify existing web sources, apps, or databases that already document gin × tonic × garnish pairings so we can assess data availability

## Research Findings — Sources to Investigate

### Priority Tier 1 — Dedicated Gin Databases / Apps
| Source | URL | Coverage | Notes |
|--------|-----|----------|-------|
| Flaviar | https://flaviar.com | Spirits database, taste notes, distillery info | Strong taste profiles; tonic pairing unclear |
| Difford's Guide | https://www.diffordsguide.com/gin | Gin reviews, cocktail recipes, taste notes | Very strong — includes botanicals, taste profile, cocktail ratios |
| Gin Foundry | https://www.ginfoundry.com | UK-focused gin reviews, tasting notes, garnish tips | Excellent garnish + tonic pairing content |
| Master of Malt | https://www.masterofmalt.com | Spirits retail + tasting notes | Good taste profiles; less pairing-specific |
| The Gin Guide | https://www.thegineguide.com | Gin reviews + G&T recommendations | Dedicated G&T format; may include tonic + garnish |
| Gin Monkey | https://ginmonkey.co.uk | Independent gin blog + reviews | Good narrative pairing content |
| Gin Magazine | https://ginmagazine.co.uk | Editorial gin coverage | Less structured data |

### Priority Tier 2 — Tonic Brand Resources
| Source | URL | Coverage | Notes |
|--------|-----|----------|-------|
| Fever-Tree | https://fever-tree.com/en_GB/cocktails | Recipes with gin + tonic pairings, garnishes, volumes | **Gold standard** — official volumes (50ml gin : 150ml tonic), garnish per gin |
| Schweppes | https://www.schweppes.com | Classic G&T references | Less granular |
| Fentimans | https://fentimans.com | Tonic water range with pairing suggestions | Some gin × tonic pairings |
| East Imperial | https://eastimperial.com | Premium tonic; pairing guides | Good pairing notes per tonic variety |
| 1724 Tonic | https://1724tonic.com | Patagonian tonic; brand pairing recs | Some structured pairing content |
| Artisan Drinks | https://artisandrinkco.com | Tonic range + pairing guides | — |

### Priority Tier 3 — Gin Brand Official Sites (sample)
| Gin | Official URL | Expected Data |
|-----|-------------|---------------|
| Hendrick's | https://www.hendricksgin.com | Signature serve: cucumber garnish, specific tonic, volumes |
| Tanqueray | https://www.tanqueray.com | Serve recommendations |
| Monkey 47 | https://www.monkey47.com | Complex botanical profile, serve suggestions |
| The Botanist | https://www.thebotanist.com | Islay botanical profile, serve suggestions |
| Beefeater | https://www.beefeatersgin.com | Classic London Dry serve |
| Roku | https://www.beamsuntory.com/brands/roku-gin | Japanese botanical profile |
| Bombay Sapphire | https://www.bombaysapphire.com | Serve, garnish |
| Aviation | https://aviationgin.com | Modern American gin serves |

### Priority Tier 4 — Structured Data / APIs
| Source | URL | Notes |
|--------|-----|-------|
| Open Food Facts | https://world.openfoodfacts.org | May have some spirits entries; inconsistent |
| TheCocktailDB | https://www.thecocktaildb.com | Cocktail API — gin cocktails but not G&T specific pairing data |
| Untappd equivalent for spirits? | — | No clear equivalent found yet |

## Key Data Fields — Availability Assessment
| Field | Best Source |
|-------|-------------|
| Taste profile / botanicals | Difford's Guide, Gin Foundry, Flaviar |
| Recommended tonic | Fever-Tree, Gin Foundry, The Gin Guide |
| Garnish recommendation | Fever-Tree, Gin Foundry, official brand sites |
| Volumes (gin ml : tonic ml) | Fever-Tree (50:150 standard), brand sites |
| Official site URL | Curated manually per gin |
| ABV | Master of Malt, Difford's |
| Bottle image | Brand sites, Master of Malt |

## Technical Decisions
| Decision | Rationale |
|----------|-----------|
| SwiftUI multiplatform (iOS + macOS) | Single codebase, native feel, Apple-first |
| Swift Data (or Core Data) for persistence | First-party, works with CloudKit |
| JSON seed files for initial gin data | Easy to curate manually; importable at first launch |
| Defer Windows to v2 | No SwiftUI on Windows; reduces scope complexity |

## Issues Encountered
| Issue | Resolution |
|-------|------------|
| — | — |

## Resources
- Difford's Guide gin section: https://www.diffordsguide.com/gin
- Gin Foundry: https://www.ginfoundry.com
- Fever-Tree cocktail recipes: https://fever-tree.com/en_GB/cocktails
- TheCocktailDB API: https://www.thecocktaildb.com/api.php

## Visual/Browser Findings
<!-- To be populated after web research in Phase 1 -->
- Fever-Tree uses a standard 50ml gin : 150ml tonic ratio as their "perfect serve" baseline
- Most sources recommend a 1:3 ratio (gin:tonic) by volume
- Garnish categories seen across sources: citrus (lemon/lime/grapefruit), cucumber, herbs (rosemary/thyme/basil), berries, spices (pepper, cardamom), edible flowers

---
*Update this file after every 2 view/browser/search operations*
