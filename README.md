# ScholarSync

> An iOS app that aggregates scholarship opportunities from across the web into a single, intuitive experience — helping students spend less time searching and more time applying.


---

## Overview

Finding scholarships is a fragmented, time-consuming process. Students routinely visit dozens of websites, often encountering duplicate listings, outdated deadlines, and poor mobile experiences. **ScholarSync** solves this by building a unified scholarship discovery layer on top of publicly available data from leading providers — delivering a clean, bookmarkable, always-up-to-date feed directly on iPhone.

The project also served as a deep investigation into the real-world viability of client-side web scraping in production mobile apps: parsing heterogeneous HTML at runtime, handling site-structure drift, and maintaining a responsive UI while executing network-heavy workloads — all without a backend server.

---

## Features

| Feature | Description |
|---|---|
| **Search Aggregation** | Concurrently scrapes Fastweb, Scholarships.com, and Scholarships360 and merges results into a single deduplicated feed |
| **Bookmark Management** | Persistent local bookmarking so students can track opportunities across sessions |
| **Detailed Scholarship Views** | Name, description, award amount, deadline, and direct application link surfaced in a single tap |
| **iOS-Native Performance** | Built entirely in Swift with no cross-platform overhead; runs smoothly on any modern iPhone |

---

## Technical Architecture

```
ScholarSync/
├── MainVC.swift               # Root feed controller; orchestrates concurrent scrape tasks
├── SearchView.swift           # Search input + live-filter logic
├── SelectedScholarshipVC.swift# Detailed scholarship view + deep-link to application page
├── AboutVC.swift              # App info
├── Services/                  # Networking + HTML parsing layer (SwiftSoup)
├── TableViewCell.swift        # Custom UITableViewCell for scholarship cards
└── SceneDelegate / AppDelegate
```

**Key engineering decisions:**

- **Concurrent scraping via async/await** — each scholarship source is fetched on its own task, keeping the main thread fully free and reducing total load time.
- **SwiftSoup for robust HTML parsing** — CSS-selector–based extraction isolates the app from minor DOM changes and keeps parsing logic declarative and readable.
- **Error-resilient pipeline** — individual source failures are caught and logged without crashing the overall feed, so a single site outage never degrades the full user experience.
- **No backend required** — all aggregation happens on-device, eliminating server costs and infrastructure complexity while keeping user data fully private.

---

## Installation

```bash
git clone https://github.com/adam8687/ScholarSync.git
```

1. Open `ScholarSync.xcodeproj` in Xcode (14+).
2. Select your target device or simulator (iOS 15+).
3. Build & run (`⌘R`).

No API keys or external accounts required.

---

## Technologies

| Layer | Choice | Rationale |
|---|---|---|
| Language | Swift | Type-safe, performant, first-class iOS support |
| UI Framework | UIKit / Storyboard | Fine-grained layout control for custom card designs |
| HTML Parsing | SwiftSoup | Battle-tested CSS-selector API; pure Swift, no C deps |
| Concurrency | Swift Concurrency (async/await) | Structured, readable async code with built-in cancellation |
| Persistence | UserDefaults / Codable | Lightweight local storage suitable for bookmark payloads |

---

## Engineering Challenges

**Heterogeneous HTML structures** — each scholarship site uses a different DOM layout and class-naming convention. The scraping layer abstracts each source behind a common `ScholarshipProvider` protocol, so new sites can be added without touching existing parsing logic.

**Terms-of-service compliance** — publicly accessible, non-login-gated data only. Rate limiting and `robots.txt` are respected. No proprietary or personally identifiable data is stored or transmitted.

**Deduplication across sources** — scholarships appear on multiple aggregators. A lightweight normalization pass (name + amount + deadline fingerprint) removes duplicates before the feed is rendered.

**Performance on-device** — parsing HTML is CPU-intensive. Work is dispatched off the main thread and results are batched into UI updates to maintain 60 fps scrolling throughout.

---

## Roadmap

- [ ] **Profile-based recommendations** — match scholarships to a student's GPA, major, and demographics using on-device ML (Core ML)
- [ ] **Push notification reminders** — deadline alerts for bookmarked scholarships
- [ ] **Expanded source coverage** — modular provider architecture makes adding new scrapers straightforward
- [ ] **Android port** — Kotlin Multiplatform candidate for shared parsing logic
- [ ] **Enhanced filtering & sorting** — by amount, deadline, eligibility criteria

---

## Ethical Considerations

ScholarSync aggregates only publicly available, non-login-gated information. It does not store user data on external servers, does not circumvent paywalls, and attributes all scholarship data to its original source. The project is intended as a discoverability layer that drives traffic *to* scholarship providers, not away from them.

---

## License

MIT — see [LICENSE](LICENSE) for details.

---

## Acknowledgments

- [SwiftSoup](https://github.com/scinfu/SwiftSoup) for its excellent HTML parsing API
- Fastweb, Scholarships.com, and Scholarships360 for making scholarship data publicly accessible
