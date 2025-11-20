# DDD und CDD kombinieren

## Warum das zusammenpasst

* **Getrennte Verantwortungen:**

  * **Backend (DDD):** Bounded Contexts, Aggregate, Domain Events, Ubiquitous Language, fachliche Invarianten.
  * **Frontend (CDD):** Design System, UI-Komponenten, Zustandsmodelle, Storybook-getriebene Entwicklung, visuelle/Interaktions-Tests.
* **Gleiche Idee, andere Ebene:** Beide sind “Domain/Component first” und fördern klare Grenzen, explizite Verträge und Testbarkeit.

## Architektur-Empfehlungen für die Kopplung

1. **API an Use-Cases ausrichten, nicht an Entitäten**

   * REST: Endpunkte pro Use-Case (Commands/Queries).
   * GraphQL/BFF: Schemas/BFFs pro Frontend-Surface (App/Team), damit das UI nur das holt, was es braucht.
2. **BFF (Backend-for-Frontend) erwägen**

   * Entkoppelt DDD-Modelle von UI-Schnittstellen, orchestriert mehrere Bounded Contexts für eine Seite/Ansicht.
3. **Domain Events ↔ UI-Zustände**

   * Domain Events triggern UI-Aktualisierungen (WebSockets/SSE), Frontend modelliert daraus klare View-States (loading/empty/error/success).
4. **DTOs klar von Domain-Objekten trennen**

   * Anti-Corruption Layer/BFF mappt Domain → DTO. Verhindert “Domain-Leakage” ins Frontend.
5. **Versionierung & Evolution**

   * API versionieren, Komponenten im Design-System semver’n; Breaking Changes vermeiden (Deprecation Pfad).
6. **Fehler- & Invarianten-Handhabung**

   * Backend validiert Regeln (DDD-Invarianten), Frontend spiegelt sie nutzerfreundlich wider (Form-States, Inline-Feedback).

## Typische Technik-Patterns

* **Backend (DDD):** Hexagonale Architektur, Aggregate Roots, Domain Services, CQRS (optional), Event-Sourcing (nur wenn’s echten Mehrwert bringt), AC-Layer zwischen Kontexten.
* **Frontend (CDD):** Storybook, Design-Tokens, Presentational vs. Container Components, State Machines (z. B. XState) für komplexe Interaktionen, UI-Tests (Playwright) + visuelle Regression.

## Organisatorische Hinweise

* **Ubiquitous Language ↔ Design Language:** Gleiche Begriffe in Domäne und UI-Kopie; Glossar pflegen.
* **Team-Schnitt:** Teams entlang Bounded Contexts und/oder App-Features; BFF gehört dem Frontend-Team.
* **Monorepo (optional):** Geteilte Typen/Contracts (nur DTO-Interfaces, nicht Domain-Klassen!) + automatisierte Contract-Tests.

## Tests & Qualitätssicherung

* **Contract-Tests:** Zwischen BFF/API und UI (z. B. Pact).
* **Komponenten-Stories → visuelle Regression:** Jede Story als Testfall.
* **Domänentests:** Invariant-/Policy-Tests auf Aggregat-Ebene.
* **End-to-End:** Kritische Flows abdecken (Happy/Edge/Error).

## Fallstricke (und wie man sie vermeidet)

* **Over-Modeling im Frontend:** UI braucht nicht das gesamte Domainmodell → über BFF/Mapper zuschneiden.
* **Anämische Domänenmodelle:** Regeln gehören ins Domainmodell, nicht in Controller/Services verschieben.
* **UI koppelt direkt an Entities:** Immer DTOs/Use-Case-APIs nutzen.
* **Fehlende Event-Kanäle:** Reaktive UI ohne Events wird “polling-lastig”.

## Mini-Checkliste zum Start

* Bounded Contexts definieren, Ubiquitous Language festhalten.
* Design-System & Storybook aufsetzen, erste Kernkomponenten definieren.
* APIs pro Use-Case spezifizieren (REST/GraphQL) + BFF entscheiden.
* Mapping-Schicht (Domain → DTO) implementieren, Contract-Tests einrichten.
* Event-Flüsse und UI-States skizzieren (inkl. Fehler/Leere/Loading).