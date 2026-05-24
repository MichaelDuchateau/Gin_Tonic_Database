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

## Research Findings — Sources Investigated (Phase 1)

### MAJOR FINDING: Direct Competitor Apps Already Exist

| App | Scale | Public API | Key Data |
|-----|-------|-----------|----------|
| **GINferno** (iOS + Android) | 13,000+ gins, 1,200 mixers, 130,000 recipes | ❌ Proprietary | Gin × tonic × garnish pairings, "perfect serves", ratings. Internal CDN at `web.ginferno.app/api/cdn/`. [App Store](https://apps.apple.com/us/app/ginferno-perfect-gin-tonic/id1511467045) |
| **Ginventory** (iOS + Android) | 6,500+ gins | ❌ No public API | Distillery-recommended pairings, tonic + garnish per gin, most-downloaded gin app globally. [ginventory.co](https://www.ginventory.co/en) |

**Implication:** Both apps are well-established. Our app must differentiate — see Differentiation section below.

### Priority Tier 1 — Best Data Sources (Verified)

| Source | URL | Fields Covered | Scraped/Usable? |
|--------|-----|---------------|-----------------|
| **The Gin Guide** | https://www.theginguide.com | 315+ gins: garnish (1-3 options per gin), tasting notes, botanicals, style, ABV, price. Dedicated [Garnish Guide](https://www.theginguide.com/gin-garnish-guide.html) | ✅ HTML parseable; garnish per gin A-Z |
| **Gin Foundry** | https://www.ginfoundry.com | Published "a little book on gins, tonics & garnishes" (47 gins, £4.95). G&T recipe pages exist per gin. | ✅ Individual recipe pages (e.g. `/gin/gin-sul/gin-sul-tonic-web/`) |
| **Difford's Guide** | https://www.diffordsguide.com | Encyclopaedic gin entries; taste profile, botanicals, ABV, cocktail ratios. Strong editorial depth. | ⚠️ 404 on some paths; login may be required for full data |
| **gin.directory** | https://www.gin.directory | Hybrid editorial + database. Gin filtering by type (London Dry, Navy, etc.), comparison tools, price tracking, community tasting journals. Volume standard cited: 50ml gin : 150ml tonic | ✅ Web-accessible |

### Priority Tier 2 — Tonic Brand Resources (Verified)

| Source | URL | Coverage | Usability |
|--------|-----|----------|-----------|
| **Fever-Tree** | https://fever-tree.com | Sets the volume standard: **50ml gin : 150ml tonic** (1:3). Cocktails section exists but gin-specific pages require navigation. | ⚠️ Content JS-rendered, not directly parseable |
| Fentimans | https://fentimans.com | Tonic range + pairing suggestions | Editorial only |
| East Imperial | https://eastimperial.com | Pairing notes per tonic variety | Editorial only |

### Priority Tier 3 — Gin Brand Official Sites

Each official site is the authoritative source for "perfect serve" data for that gin. Manual curation required.

| Gin | Official URL | Confirmed Serve Data |
|-----|-------------|----------------------|
| Hendrick's | https://www.hendricksgin.com | Cucumber garnish, serves confirmed |
| Tanqueray | https://www.tanqueray.com | Classic serve |
| Monkey 47 | https://www.monkey47.com | 47 botanicals, complex profile |
| The Botanist | https://www.thebotanist.com | Islay botanicals |
| Beefeater | https://www.beefeatersgin.com | London Dry classic |
| Roku | https://www.suntory.com/brands/roku/ | Japanese botanicals (sakura, yuzu, etc.) |
| Bombay Sapphire | https://www.bombaysapphire.com | Serve + garnish |

### Priority Tier 4 — Structured Data / APIs

| Source | URL | Notes |
|--------|-----|-------|
| TheCocktailDB | https://www.thecocktaildb.com/api.php | Gin cocktails but **no G&T-specific pairing data**. Not suitable for our use case. |
| Open Food Facts | https://world.openfoodfacts.org | Inconsistent spirits data. Not suitable. |

### Garnish Pattern Taxonomy (from research)

Based on cross-source analysis, garnishes map to gin style:

| Gin Style | Common Garnish | Common Tonic |
|-----------|---------------|-------------|
| London Dry | Lemon slice or wedge | Standard / Indian |
| Contemporary / floral | Edible flowers, elderflower | Light / elderflower |
| Cucumber-noted (Hendrick's) | Cucumber ribbon or slice | Light / cucumber |
| Citrus-forward | Grapefruit slice, orange wheel | Mediterranean / citrus |
| Herbal | Rosemary sprig, thyme | Mediterranean |
| Spice-forward | Pink peppercorns, star anise, cinnamon | Aromatic / spiced |
| Japanese | Yuzu peel, shiso leaf, green tea | Light / neutral |
| Navy Strength | Lemon, juniper berries | Full-flavour Indian |

## Key Data Fields — Availability Assessment (Updated)
| Field | Best Source | Availability |
|-------|-------------|-------------|
| Taste profile / botanicals | Difford's Guide, The Gin Guide, Gin Foundry | ✅ Web + editorial |
| Recommended tonic (brand) | Ginventory (distillery-endorsed), Fever-Tree | ⚠️ App-locked or editorial |
| Garnish recommendation | The Gin Guide Garnish Guide (315 gins A-Z) | ✅ Web-parseable |
| Volumes (gin ml : tonic ml) | Fever-Tree standard: **50ml : 150ml** | ✅ Industry standard |
| Official distillery URL | Manual curation per gin | ✅ Always available |
| ABV | The Gin Guide, Difford's | ✅ Web |
| Bottle image | Brand sites, Difford's | ✅ Per brand |
| Style classification | gin.directory, The Gin Guide | ✅ Web |

## Differentiation Strategy vs. GINferno / Ginventory
| Dimension | GINferno / Ginventory | Our App |
|-----------|-----------------------|---------|
| Platform | iOS + Android (cross-platform native) | iOS + macOS native (SwiftUI), Windows v2 |
| Scale | 6,500–13,000 gins | Curated quality-first (start 50–200 gins) |
| Data entry | Proprietary / closed | User-editable, personal collection |
| Cross-pairing UI | Recipe suggestions | Interactive **pairing matrix** (gin × tonic) |
| Mac experience | No dedicated macOS app | First-class macOS app via SwiftUI |
| Personal recipes | Limited | Core feature — save your own G&T recipes |
| Official links | Unknown | Verified official distillery URL per gin |

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
