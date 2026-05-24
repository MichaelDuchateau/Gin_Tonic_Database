# Task Plan: Gin & Tonic Database App

## Goal
Build a native cross-platform app (iOS + macOS, future Windows) where users can browse and enter Gin & Tonic recipes, including per-gin tonic pairings, garnish combinations, volumes, taste profiles, and links to official distillery sites.

## Current Phase
Phase 4

## Phases

### Phase 1: Research & Source Discovery
- [x] Define app requirements and data model
- [x] Identify existing databases/sources covering gin tonic pairings, garnishes, taste profiles
- [x] Evaluate licensing/scraping viability for each source
- [x] Document all findings in findings.md
- **Status:** complete

**Key Phase 1 Outcomes:**
- Two direct competitor apps found: GINferno (13K gins) and Ginventory (6.5K gins) — neither has a public API
- Best seed data source: The Gin Guide Garnish Guide (315 gins, HTML-parseable)
- Volume standard: 50ml gin : 150ml tonic (Fever-Tree / industry)
- No public structured API exists for gin pairing data — manual curation required for seed data
- Differentiation: macOS-native, curated quality, user-editable personal pairings, interactive pairing matrix

### Phase 2: Data Model & Architecture Design
- [x] Define the core data schema (Gin, Tonic, Garnish, GinTonicPairing, Recipe)
- [x] Decide on local vs cloud storage strategy (Swift Data + optional CloudKit)
- [x] Choose framework/tech stack (SwiftUI + Swift Data, iOS 17+ / macOS 14+)
- [x] Decide on Windows path (Flutter for v2; defer)
- [x] Design app information architecture (screens, navigation)
- **Status:** complete

**Key Phase 2 Outputs:**
- `Docs/DataModel.md` — full Swift Data schema with all entities, enums, JSON seed format
- `Docs/Architecture.md` — project structure, navigation, data flow, screen inventory
- Key differentiator confirmed: **Pairing Matrix view** (gin × tonic grid) unique to this app
- Target: iOS 17 / macOS 14 (Sonoma) for Swift Data + @Observable support

### Phase 3: Data Seeding Plan
- [x] Identify which gins to seed initially — 15 curated gins chosen
- [x] Define import format — 4 JSON seed files in `Seeds/`
- [x] Create garnishes.json — 30 garnishes across 7 categories
- [x] Create tonics.json — 15 tonics across 7 brands
- [x] Create gins.json — 15 gins (London Dry, contemporary, Japanese, American, etc.)
- [x] Create pairings.json — 30 pairings (gin × tonic × garnish × volumes × source)
- **Status:** complete

**Seed data stats:**
- 15 gins · 15 tonics · 30 garnishes · 30 pairings
- All pairings carry: ginVolumeMl, tonicVolumeMl, glassType, iceType, garnishIds[], notes, source
- Sources split: distilleryRecommended and editorial
- App name confirmed: **"The Gintastic Serve"**

### Phase 4: App Implementation
- [ ] Scaffold SwiftUI project (multiplatform target: iOS + macOS)
- [ ] Implement data layer (Swift Data models)
- [ ] Build browse/search screens
- [ ] Build gin detail screen (taste profile, pairings, garnishes, volumes, official link)
- [ ] Build recipe entry / cross-pairing editor
- [ ] Basic CloudKit sync (optional v1)
- **Status:** pending

### Phase 5: Testing & Delivery
- [ ] Test on iOS Simulator and macOS
- [ ] Verify all data fields display correctly
- [ ] Polish UI and navigation
- [ ] Document build and run instructions
- **Status:** pending

## Key Questions
1. Should the app be read-only (curated database) or fully user-editable (CRUD)?
2. Is CloudKit sync required for v1, or is local-only acceptable?
3. Which gins should be seeded first — well-known global brands or a curated niche list?
4. What is the minimum viable garnish/tonic pairing count per gin for launch?
5. Is there a preferred visual style (minimal/clinical vs. rich/lifestyle)?
6. Should official gin site links be verified/curated or auto-generated from distillery name?
7. Windows path: Flutter cross-compile vs. defer Windows entirely to v2?

## Decisions Made
| Decision | Rationale |
|----------|-----------|
| SwiftUI multiplatform for iOS + macOS v1 | Native performance, shared codebase, best iOS/macOS design fidelity |
| Swift Data over Core Data | Modern @Model macro API; CloudKit-ready; no .xcdatamodel file needed |
| iOS 17 / macOS 14 minimum | Required for Swift Data + @Observable; covers ~85%+ of active devices in 2026 |
| @Observable over ObservableObject | Simpler syntax; no @Published boilerplate; better performance |
| NavigationSplitView (Mac/iPad) + TabView (iPhone) | Adapts correctly to each form factor per Apple HIG |
| No CloudKit in v1 | User decision: keep v1 simple; local-only Swift Data store |
| Flutter for Windows v2 | Best cross-platform option; shares JSON seed data format with SwiftUI app |
| Pairing Matrix as key differentiator | No competitor app has an interactive gin × tonic grid; validates the app's unique value |
| App name: "The Gintastic Serve" | User decision |
| Visual style: clean/minimal | White/light backgrounds, botanical illustration accents, no dark lifestyle photography in v1 |
| Community/sharing deferred to v2 | User decision; v1 is personal-collection only |
| Defer Windows to v2 | SwiftUI does not run on Windows; Flutter or MAUI are viable but add complexity |

## Errors Encountered
| Error | Attempt | Resolution |
|-------|---------|------------|
| — | — | — |

## Notes
- Update phase status as you progress: pending → in_progress → complete
- Re-read this plan before major decisions
- Log ALL errors — they help avoid repetition
- Key constraint: data richness (taste profile, garnish pairings) depends heavily on what sources exist
