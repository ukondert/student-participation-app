# Aggregate, Entitäten und Value Objects

> Stand: {{YYYY-MM-DD}}
> Projekt: {{Projektname}}

---

{{Für jeden Bounded Context aus Phase 1.3}}

## {{Context-Name}}

### Aggregate Root
{{Für jedes identifizierte Aggregate Root aus Phase 2.1}}
- **{{Aggregat-Name}}**
  - *Begründung:* {{Warum ist dies ein Aggregate Root? Hat eindeutige Identität, ist Konsistenzgrenze für zugehörige Entitäten}}

### Entitäten (innerhalb von Aggregaten)
{{Für jede identifizierte Entity aus Phase 2.1}}
- **{{Entität-Name}}** (Teil von {{Aggregat-Name}})
  - *Begründung:* {{Warum ist dies eine Entity? Hat eigene Identität und Lebenszyklus, ist aber nur im Kontext des Aggregats relevant}}

### Value Objects
{{Für jedes identifizierte Value Object aus Phase 2.1}}
- **{{Value-Object-Name}}** ({{Datentyp, z.B. String, Enum, Composite}})
  - *Begründung:* {{Warum ist dies ein Value Object? Wird durch Attribute definiert, keine eigene Identität, unveränderlich}}

### Aggregate-Details: {{Aggregat-Name}}

**ID:** {{id-attribut}} ({{Datentyp, z.B. UUID}})

**Eigene Attribute:**
{{Für jedes Attribut aus Phase 2.2}}
- {{attributName}}: {{Datentyp}} – {{Beschreibung}}

**Enthaltene Entitäten:**
{{Für jede enthaltene Entity aus Phase 2.2}}
- {{Beziehungstyp, z.B. "Liste von"}} {{Entität-Name}} ({{Kardinalität, z.B. 1:n, 0:1}})
  - Jede(r) {{Entität-Name}}: {{Liste der Attribute mit Datentypen}}

**Referenzierte Aggregate:**
{{Für jede Aggregat-Referenz aus Phase 2.2}}
- {{Aggregat-Name}}: {{id-attribut}} ({{FK-Typ, z.B. FK UUID}})

**Value Objects:**
{{Für jedes verwendete Value Object}}
- {{Value-Object-Name}}: {{Verwendungszweck}}

**Geschäftsregeln (Invarianten):**
{{Für jede Geschäftsregel aus Phase 1.1 und Phase 2.2, die dieses Aggregat betrifft}}
- {{Geschäftsregel-Beschreibung}}
- {{User Story Referenz, falls vorhanden}}

**Methoden (aus Phase 2.3):**
{{Für jede zugeordnete Methode aus Phase 2.3}}
- `{{methodenName}}({{parameter}})`: {{rückgabetyp}}
  - **Zweck:** {{Was macht die Methode}}
  - **Geschäftsregel:** {{Welche Invariante wird durchgesetzt}}
  - **Use Case:** {{User Story ID und Titel}}

---

{{Weitere Komponenten des Bounded Context}}

### Domain Services

{{Für jeden Domain Service aus Phase 2.4}}

**Domain Service: {{Service-Name}}**
- **Zweck:** {{Beschreibung des Services}}
- **Beteiligte Aggregate:** {{Liste der involvierten Aggregate}}
- **Methoden:**
  {{Für jede Service-Methode}}
  - `{{methodenName}}({{parameter}})`: {{rückgabetyp}}
    - **Beschreibung:** {{Was macht die Methode}}
    - **Use Case:** {{User Story Referenz}}

**Begründung für Domain Service:**
{{Warum ist dies ein Domain Service und nicht Teil eines Aggregats? Z.B.:
- Operation betrifft mehrere Aggregate
- Zu komplex für ein einzelnes Aggregat
- Repräsentiert wichtigen Domänenprozess}}

---

### Weitere Komponenten (falls vorhanden)

{{Für zusätzliche Elemente wie Repositories, Events, etc.}}

**{{Komponenten-Typ, z.B. "Repository", "Domain Event", "Policy"}}:**

{{Falls Repository}}
- **{{Repository-Name}}Repository**
  - **Zweck:** Laden und Speichern von {{Aggregat-Name}}
  - **Methoden:**
    - `findById(id: UUID): {{Aggregat-Name}}`
    - `save({{aggregat}}: {{Aggregat-Name}}): void`
    - `delete(id: UUID): void`
    - {{Weitere Query-Methoden}}

{{Falls Domain Event}}
- **{{Event-Name}}**
  - **Beschreibung:** {{Was ist passiert}}
  - **Auslöser:** {{Welches Aggregat/Welcher Service}}
  - **Payload:** {{Welche Daten werden übertragen}}
  - **Subscriber:** {{Wer reagiert darauf}}
  - **Use Case:** {{User Story Referenz}}

{{Falls Policy/Strategy}}
- **{{Policy-Name}}**
  - **Zweck:** {{Konfigurierbare Regel oder austauschbare Strategie}}
  - **Konfiguration:** {{Welche Parameter sind anpassbar}}
  - **Verwendung:** {{Wo wird die Policy angewendet}}

---

{{Ende eines Bounded Context - Wiederhole für alle Contexts}}

---

## Zusammenfassung

### Übersicht aller Aggregate

| Bounded Context | Aggregate Root | Enthaltene Entities | Key Value Objects | Wichtigste Methoden |
|-----------------|----------------|---------------------|-------------------|---------------------|
{{Für jeden Context und jedes Aggregat}}
| {{Context-Name}} | {{Aggregat-Name}} | {{Anzahl}} Entities | {{Wichtigste VOs}} | {{Kern-Methoden}} |

### Übersicht aller Domain Services

| Bounded Context | Service Name | Zweck | Beteiligte Aggregate |
|-----------------|--------------|-------|----------------------|
{{Für jeden Domain Service}}
| {{Context-Name}} | {{Service-Name}} | {{Kurzbeschreibung}} | {{Aggregate-Liste}} |

### Cross-Context-Referenzen

{{Für jeden Fall, wo ein Aggregat ein anderes aus einem anderen Context referenziert}}
- **{{Context-A}}** → **{{Context-B}}**: {{Aggregat-A}} referenziert {{Aggregat-B}} über {{id-attribut}}
  - **Art der Beziehung:** {{z.B. "Lose Kopplung über ID", "Event-basiert", "Shared Kernel"}}
  - **Integration-Pattern:** {{z.B. "Published Language", "Customer/Supplier", "Anti-Corruption Layer"}}

---

## Modellierungs-Entscheidungen

### Warum Aggregate Root?

{{Für wichtige Aggregate Root Entscheidungen}}
- **{{Aggregat-Name}}**: {{Begründung, warum dies die Konsistenzgrenze ist}}

### Warum Entity vs. Value Object?

{{Für wichtige Entity vs. Value Object Entscheidungen}}
- **{{Name}}** ist eine **{{Entity/Value Object}}**, weil: {{Begründung}}

### Aggregat-Grenzen

{{Für wichtige Entscheidungen über Aggregat-Grenzen}}
- **{{Aggregat-A}}** und **{{Aggregat-B}}** sind getrennte Aggregate, weil: {{Begründung}}
- Alternative erwogen: {{Alternative Modellierung}} - Verworfen, weil: {{Grund}}

---

## Nächste Schritte

Nach Finalisierung dieser DDD-Bausteine:

1. ✅ **PlantUML-Diagramme erstellen** (Phase 3.1)
   - Pro Bounded Context ein Klassendiagramm
   - Visualisierung der Aggregate, Entities, Value Objects
   - Beziehungen und Kardinalitäten

2. ✅ **Vollständiges Glossar erstellen** (Phase 3.0)
   - `docs/architecture/ubiquitous-language-glossar.md`
   - Alle Begriffe mit finalen Rollen und Context-Zuordnungen

3. ✅ **Domain-Modell-Dokumentation** (Phase 3.2)
   - `docs/architecture/domain-model.md`
   - Gesamtübersicht mit eingebetteten Diagrammen

4. ✅ **Traceability Matrix** (Phase 3.3)
   - User Stories ↔ Aggregate/Methoden Mapping

5. ✅ **Architektur-Entscheidungen** (Phase 4)
   - Architekturmuster pro Context
   - Technology Stack
   - Repository-Strategie

---

## Verwendete DDD-Patterns

{{Automatisch aus der Modellierung ableiten}}

- ✅ **Aggregate Pattern**: {{Anzahl}} Aggregates identifiziert
- ✅ **Entity Pattern**: {{Anzahl}} Entities innerhalb von Aggregaten
- ✅ **Value Object Pattern**: {{Anzahl}} Value Objects
- ✅ **Domain Service Pattern**: {{Anzahl}} Domain Services
- ✅ **Repository Pattern**: Repositories für alle Aggregate Roots
{{Falls Events vorhanden}}
- ✅ **Domain Event Pattern**: {{Anzahl}} Domain Events
{{Falls Policies vorhanden}}
- ✅ **Policy/Strategy Pattern**: {{Anzahl}} konfigurierbare Policies

---

## Validierung

### Checkliste: Sind alle DDD-Regeln eingehalten?

**Aggregate-Regeln:**
- [ ] Jedes Aggregate hat genau eine Root-Entity
- [ ] Aggregate werden nur über ihre Root referenziert
- [ ] Andere Aggregate werden nur über ID referenziert (keine direkten Objekt-Referenzen)
- [ ] Aggregat-Grenzen sind entlang Transaktions-/Konsistenz-Grenzen gewählt
- [ ] Aggregate sind nicht zu groß (Faustregel: max. 3-5 Entities pro Aggregat)

**Entity-Regeln:**
- [ ] Alle Entities haben eine eindeutige Identität
- [ ] Entities außerhalb von Aggregaten sind selbst Aggregate Roots
- [ ] Entity-Gleichheit wird über ID geprüft, nicht über Attribute

**Value Object-Regeln:**
- [ ] Alle Value Objects sind unveränderlich (immutable)
- [ ] Value Objects haben keine eigene Identität
- [ ] Value Object-Gleichheit wird über alle Attribute geprüft
- [ ] Komplexe Werte (z.B. Adressen) sind als Value Objects modelliert, nicht als primitive Typen

**Domain Service-Regeln:**
- [ ] Domain Services enthalten nur Logik, die nicht in Aggregate passt
- [ ] Domain Services sind zustandslos (stateless)
- [ ] Domain Services operieren auf Aggregaten, enthalten aber keine Entity-Logik

**Bounded Context-Regeln:**
- [ ] Jedes Modell-Element gehört zu genau einem Bounded Context
- [ ] Ubiquitous Language ist innerhalb eines Context eindeutig
- [ ] Context-übergreifende Begriffe haben ggf. unterschiedliche Bedeutungen

---

**Letzte Aktualisierung dieses Templates**: {{YYYY-MM-DD}}
**Erstellt mit**: Software-Architect Chatmode (Phase 2 - Taktisches Design)
