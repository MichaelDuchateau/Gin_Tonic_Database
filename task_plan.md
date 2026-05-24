# Task Plan: Gin & Tonic Database App

## Goal
Build a native cross-platform app (iOS + macOS, future Windows) where users can browse and enter Gin & Tonic recipes, including per-gin tonic pairings, garnish combinations, volumes, taste profiles, and links to official distillery sites.

## Current Phase
Phase 2

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
- [ ] Define the core data schema (Gin, Tonic, Garnish, Pairing, Recipe)
- [ ] Decide on local vs cloud storage strategy
- [ ] Choose framework/tech stack (SwiftUI + Swift Data / Core Data / CloudKit)
- [ ] Decide on Windows path (Electron / Flutter / MAUI / SwiftUI on Windows someday)
- [ ] Design app information architecture (screens, navigation)
- **Status:** pending

### Phase 3: Data Seeding Plan
- [ ] Identify which gins to seed initially (curated list)
- [ ] Plan scraping or manual entry workflow
- [ ] Define import format (JSON/CSV seed files)
- [ ] Create sample data for at least 10 gins
- **Status:** pending

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
| Defer Windows to v2 | SwiftUI does not run on Windows; Flutter or MAUI are viable but add complexity |
| Phase 1 = research only, no code yet | Need to understand data landscape before designing the schema |

## Errors Encountered
| Error | Attempt | Resolution |
|-------|---------|------------|
| — | — | — |

## Notes
- Update phase status as you progress: pending → in_progress → complete
- Re-read this plan before major decisions
- Log ALL errors — they help avoid repetition
- Key constraint: data richness (taste profile, garnish pairings) depends heavily on what sources exist
