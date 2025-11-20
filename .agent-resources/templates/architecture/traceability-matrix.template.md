# Traceability Matrix: User Stories ↔ Domain-Modell

> Stand: {{DATUM}}
> Projekt: {{PROJEKTNAME}}

---

## Übersicht

Diese Traceability Matrix bildet die Verbindung zwischen den fachlichen Anforderungen (User Stories) und dem technischen Domain-Modell ab. Sie ermöglicht:

- **Impact-Analyse:** Welche Teile des Domain-Modells sind bei Änderung einer User Story betroffen?
- **Vollständigkeitsprüfung:** Sind alle User Stories im Domain-Modell abgebildet?
- **Kommunikation:** Gemeinsames Verständnis zwischen Business und Entwicklung
- **Nachverfolgbarkeit:** Begründung für Architektur-Entscheidungen

---

## Legende

### Status-Symbole
- ✅ **Modelliert:** Vollständig im Domain-Modell abgebildet
- ⏳ **Geplant:** Noch nicht modelliert, für spätere Iteration vorgesehen (z.B. Should-Have)
- 🚧 **In Arbeit:** Aktuell in Modellierung/Implementierung
- ❌ **Nicht umgesetzt:** Bewusst nicht modelliert (z.B. Won't-Have)
- 🔄 **Überarbeitung:** Existierendes Modell wird angepasst

### Abkürzungen
- **(Query):** Read-Model/Repository-Operation, keine Aggregat-Methode
- **(Command):** Zustandsändernde Operation im Aggregat
- **(Event):** Domain Event, das nach einer Aktion publiziert wird
- **(Service):** Domain Service für kontext-übergreifende Logik

---

## Traceability Matrix

| User Story (Datei) | Titel (Kurz) | Bounded Context | Aggregate | Methode/Service (vorgeschlagen) | Status |
|---|---|---|---|---|---|
{{FÜR_JEDE_USER_STORY}}
| {{USER_STORY_DATEINAME}} | {{KURZTITEL}} | {{BOUNDED_CONTEXT_NAME}} | {{AGGREGATE_ROOT_NAME}} | {{METHODEN_VORSCHLAG}} | {{STATUS_SYMBOL}} |
{{/FÜR_JEDE_USER_STORY}}

---

## Detaillierte Zuordnungen

{{FÜR_JEDEN_BOUNDED_CONTEXT}}
### {{BOUNDED_CONTEXT_NAME}}

{{FÜR_JEDES_AGGREGAT_IN_DIESEM_CONTEXT}}
#### Aggregat: {{AGGREGATE_NAME}}

**Zugeordnete User Stories:**
{{FÜR_JEDE_USER_STORY_DIESES_AGGREGATS}}
- **{{USER_STORY_ID}}:** {{USER_STORY_TITEL}}
  - **Methoden:** {{METHODEN_LISTE}}
  - **Geschäftsregeln:** {{GESCHÄFTSREGELN}}
  - **Invarianten:** {{INVARIANTEN}}
  - **Domain Events:** {{EVENTS}} *(optional)*
{{/FÜR_JEDE_USER_STORY_DIESES_AGGREGATS}}

{{/FÜR_JEDES_AGGREGAT_IN_DIESEM_CONTEXT}}

{{WENN_DOMAIN_SERVICES_EXISTIEREN}}
#### Domain Services

{{FÜR_JEDEN_DOMAIN_SERVICE}}
**Service:** {{SERVICE_NAME}}

**Zugeordnete User Stories:**
{{FÜR_JEDE_USER_STORY_DIESES_SERVICE}}
- **{{USER_STORY_ID}}:** {{USER_STORY_TITEL}}
  - **Methoden:** {{METHODEN_LISTE}}
  - **Beteiligte Aggregate:** {{AGGREGATE_LISTE}}
{{/FÜR_JEDE_USER_STORY_DIESES_SERVICE}}
{{/FÜR_JEDEN_DOMAIN_SERVICE}}
{{/WENN_DOMAIN_SERVICES_EXISTIEREN}}

{{/FÜR_JEDEN_BOUNDED_CONTEXT}}

---

## Hinweise zur Interpretation

### Methodensignaturen
Die vorgeschlagenen Methoden sind **Vorschläge gemäß der Ubiquitous Language**. Die konkreten Signaturen (Parameter, Rückgabewerte, Exceptions) werden während des API-Designs finalisiert.

**Beispiel:**
```typescript
// Vorschlag in Matrix:
createRide(start, time, capacity, femaleOnly)

// Finale Signatur (API-Design):
createRide(
  startLocation: Location,
  departureTime: DateTime,
  availableSeats: PositiveInteger,
  femaleOnly: boolean,
  userId: UserId
): Result<RideId, ValidationError>
```

### Read vs. Write Operations

**Query-Operationen** (Suchen, Filtern, Sortieren):
- Gehören typischerweise ins **Read-Model** oder **Repository**
- Ändern keinen Zustand im Aggregat
- Werden in der Matrix mit **(Query)** markiert

**Command-Operationen** (Erstellen, Ändern, Löschen):
- Sind **Aggregat-Methoden** oder **Domain Services**
- Ändern den Zustand und prüfen Invarianten
- Werden in der Matrix mit **(Command)** markiert oder ohne Zusatz

**Beispiel:**
```
✅ Aggregat-Methode:  createRide(...) → ändert Zustand
❌ Keine Aggregat-Methode: searchRides(...) → nur Abfrage
```

### Domain Events

Einige User Stories implizieren **Domain Events**, die nach erfolgreicher Ausführung publiziert werden:

**Beispiel:**
- **User Story:** "Als Mitfahrer möchte ich benachrichtigt werden, wenn meine Anfrage akzeptiert wurde"
- **Aggregat-Methode:** `Fahrt.acceptRequest(requestId)` → **(Command)**
- **Domain Event:** `RideRequestAccepted` → **(Event)**
- **Event Handler:** `NotificationService.sendRideRequestAcceptedNotification()` → anderer Context

Events werden in der Matrix optional mit **(Event)** gekennzeichnet.

---

## Validierung

### Vollständigkeits-Check

**Alle User Stories abgedeckt?**
{{ANZAHL_MODELLIERTE_STORIES}} / {{ANZAHL_GESAMT_STORIES}} User Stories modelliert

**Must-Have Features:**
- {{LISTE_MUST_HAVE_STORIES}}

**Should-Have Features (geplant):**
- {{LISTE_SHOULD_HAVE_STORIES}}

**Could-Have Features (optional):**
- {{LISTE_COULD_HAVE_STORIES}}

### Konsistenz-Check

**Fehlende Zuordnungen:**
{{LISTE_USER_STORIES_OHNE_AGGREGAT}}

**Aggregate ohne User Stories:**
{{LISTE_AGGREGATE_OHNE_USER_STORY}}
*(Hinweis: Technische Aggregate oder Shared Kernel können legitim ohne direkte User Story existieren)*

**Inkonsistenzen:**
{{LISTE_INKONSISTENZEN}}

---

## Anleitung für die Erstellung (für Chatmode)

### Schritt 1: User Stories sammeln

**Quellen:**
- `docs/requirements/*.md` (Ursprüngliche User Stories)
- `docs/requirements/refined/*.md` (Verfeinerte User Stories)
- `docs/requirements/story-map.md` (Story Map für Priorisierung)

**Für jede User Story extrahieren:**
- Dateiname
- Kurztitel (max. 5-7 Worte)
- Priorität (Must/Should/Could/Won't-Have)

### Schritt 2: Domain-Modell analysieren

**Aus Phase 2 (Taktisches Design):**
- Bounded Contexts
- Aggregate Roots
- Entitäten innerhalb von Aggregaten
- Value Objects
- Domain Services

**Aus `docs/architecture/agregates-entites-value_obj.md`:**
- Detaillierte Aggregat-Definitionen
- Zugeordnete Methoden

### Schritt 3: Zuordnung erstellen

**Für jede User Story:**

1. **Bounded Context identifizieren**
   - Welcher Context ist primär verantwortlich?
   - Welche Contexts sind sekundär beteiligt?

2. **Aggregate Root bestimmen**
   - Welches Aggregat ist der Einstiegspunkt?
   - Welche Aggregate werden indirekt beeinflusst?

3. **Methoden vorschlagen**
   - Aus Verben der User Story ableiten
   - Ubiquitous Language verwenden
   - Query vs. Command unterscheiden
   - Format: `methodName(param1, param2, ...)`

4. **Status setzen**
   - ✅ Modelliert (Must-Have, fertig modelliert)
   - ⏳ Geplant (Should/Could-Have)
   - 🚧 In Arbeit (aktuell in Bearbeitung)

**Beispiel:**

```
User Story: "Als Fahrer möchte ich eine Fahrt mit Startort, Zeit und Kapazität anbieten"

→ Bounded Context: Fahrtenmanagement
→ Aggregate: Fahrt (Aggregate Root)
→ Methoden: createRide(startLocation, departureTime, capacity)
→ Status: ✅ Modelliert
```

### Schritt 4: Detaillierte Zuordnungen dokumentieren

**Für jedes Aggregat:**
- Liste alle zugeordneten User Stories
- Dokumentiere Geschäftsregeln aus den Stories
- Dokumentiere Invarianten, die das Aggregat sicherstellen muss
- Optional: Domain Events, die publiziert werden

### Schritt 5: Validierung durchführen

**Checkliste:**
- [ ] Alle Must-Have User Stories sind zugeordnet
- [ ] Alle Aggregate haben mindestens eine User Story (außer technische Aggregate)
- [ ] Methodennamen folgen der Ubiquitous Language
- [ ] Query/Command-Unterscheidung ist klar
- [ ] Status ist für alle Stories gesetzt

### Schritt 6: Matrix aktualisieren

**Die Matrix ist ein lebendes Dokument:**
- Bei neuen User Stories: Matrix erweitern
- Bei Änderungen im Domain-Modell: Matrix aktualisieren
- Bei Refactorings: Traceability prüfen

---

## Beispiel: Vollständige Zuordnung

### Beispiel User Story

**Datei:** `user-story-fahrten-anbieten.md`

**Titel:** Als Fahrer möchte ich eine Fahrt anbieten können, um Mitfahrer zu finden

**Akzeptanzkriterien:**
- Startort und Zielort angeben
- Abfahrtszeit festlegen
- Anzahl verfügbarer Plätze definieren
- Optional: Nur für weibliche Mitfahrer (femaleOnly-Filter)
- Fahrt bearbeiten können
- Fahrt stornieren können

### Zuordnung in Matrix

| User Story | Titel | Bounded Context | Aggregate | Methoden | Status |
|---|---|---|---|---|---|
| user-story-fahrten-anbieten.md | Fahrt anbieten | Fahrtenmanagement | Fahrt | createRide(start, dest, time, seats, femaleOnly); editRide(...); cancelRide(reason?) | ✅ |

### Detaillierte Zuordnung

**Bounded Context:** Fahrtenmanagement

**Aggregate:** Fahrt (Aggregate Root)

**Zugeordnete User Stories:**
- **US-001:** Als Fahrer möchte ich eine Fahrt anbieten
  - **Methoden:** 
    - `createRide(startLocation: Location, destination: Location, departureTime: DateTime, availableSeats: PositiveInteger, femaleOnly: boolean): Result<RideId, ValidationError>` **(Command)**
    - `editRide(updates: RideUpdateDto): Result<void, ValidationError>` **(Command)**
    - `cancelRide(reason?: string): Result<void, InvalidStateError>` **(Command)**
  - **Geschäftsregeln:**
    - Abfahrtszeit muss in der Zukunft liegen
    - Anzahl Plätze muss > 0 sein
    - femaleOnly-Filter ist optional (Standard: false)
    - Fahrt kann nur vom Ersteller bearbeitet/storniert werden
  - **Invarianten:**
    - `departureTime > now()`
    - `availableSeats > 0`
    - `status != 'CANCELLED'` (für editRide)
  - **Domain Events:**
    - `RideCreated` → Benachrichtigung an potenzielle Mitfahrer
    - `RideUpdated` → Benachrichtigung an bereits angefragte Mitfahrer
    - `RideCancelled` → Benachrichtigung an akzeptierte Mitfahrer

---

*Letzte Aktualisierung: {{DATUM}}*
