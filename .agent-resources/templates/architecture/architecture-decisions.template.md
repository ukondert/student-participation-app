# Architektur-Entscheidungen

> Stand: {{datum}}  
> Projekt: {{projektname}}

---

## 1. Übersicht

Dieses Dokument beschreibt die Architektur-Entscheidungen für jeden Bounded Context von {{projektname}}. Die Entscheidungen basieren auf:

- **Domain-Driven Design (DDD)** Prinzipien
- **Domänen-Kategorisierung** (Core, Supporting, Generic)
- **Qualitätsziele** (abgeleitet aus User Stories)
- **Entscheidungsmatrix** für Architekturmuster

---

## 2. Architektur-Prinzipien

### Leitprinzipien

1. **Core Domain zuerst**: Höchste Investition in Qualität, Testbarkeit und Wartbarkeit für Kerndomänen
2. **Buy over Build**: Fertige Lösungen für Generic Subdomains bevorzugen
3. **Lose Kopplung**: Bounded Contexts kommunizieren über definierte Schnittstellen (Events, APIs)
4. **Technologie-Unabhängigkeit**: Geschäftslogik unabhängig von Frameworks und Infrastruktur
5. **{{weitere_prinzipien}}**: {{beschreibung}}

### Architektur-Entscheidungsmatrix

Die Auswahl des Architekturmusters erfolgt anhand der primären Qualitätsziele:

| Primäres Qualitätsziel | Geeignetes Architekturmuster | Anwendungsfall |
|------------------------|------------------------------|----------------|
| **Wartbarkeit & Testbarkeit der Geschäftslogik** | Hexagonale Architektur | Core Domains mit komplexer fachlicher Logik |
| **Echtzeit-Verarbeitung & Reaktionsfähigkeit** | Event-Driven Architecture | Asynchrone, event-basierte Systeme |
| **Performance bei Lesezugriffen** | Layered + CQRS | Read-Heavy Workloads, Analysen |
| **Einfache Entwicklung & Wartung** | Layered Architecture | Supporting Subdomains mit stabiler Logik |
| **Hohe Skalierbarkeit & Elastizität** | Microservices-Architektur | Millionen von Nutzern, unvorhersehbare Spitzen |
| **Hohe Flexibilität & Modularität** | Microkernel-Architektur | Austauschbare Komponenten, Plug-in-Systeme |

---

## 3. Qualitätsziele pro Bounded Context

### Bewertungsskala
- ⭐⭐⭐⭐⭐ Sehr hoch
- ⭐⭐⭐⭐ Hoch
- ⭐⭐⭐ Mittel
- ⭐⭐ Niedrig
- ⭐ Sehr niedrig

---

{{#für_jeden_bounded_context}}

### 3.{{context_nummer}} {{context_name}}-Context ({{kategorie}})

| Qualitätsziel | Bewertung | Begründung |
|---------------|-----------|------------|
| Wartbarkeit der Geschäftslogik | {{bewertung}} | {{begründung}} |
| Flexibilität/Modularität | {{bewertung}} | {{begründung}} |
| Testbarkeit | {{bewertung}} | {{begründung}} |
| Skalierbarkeit | {{bewertung}} | {{begründung}} |
| Änderungshäufigkeit | {{bewertung}} | {{begründung}} |
| Echtzeit-Verarbeitung | {{ja_nein}} | {{begründung}} |
| {{weitere_qualitätsziele}} | {{bewertung}} | {{begründung}} |

**Erwartete Nutzerlast:** {{nutzerlast}}

{{#wenn_compliance}}
**Compliance:** {{compliance_anforderungen}}
{{/wenn}}

{{#wenn_event_basiert}}
**Event-basiert:** {{event_beschreibung}}
{{/wenn}}

{{#wenn_workload}}
**Workload:** {{workload_beschreibung}}
{{/wenn}}

---

{{/für_jeden_bounded_context}}

## 4. Architektur-Entscheidungen pro Bounded Context

---

{{#für_jeden_bounded_context}}

### 4.{{context_nummer}} {{context_name}}-Context

**Kategorie:** {{kategorie}}  
**Primäres Qualitätsziel:** {{primäres_qualitätsziel}}  
**Architekturmuster:** **{{architekturmuster}}**

#### Begründung

{{begründung_für_architekturmuster}}

{{#wenn_hexagonal_architecture}}
Die Hexagonale Architektur ist optimal für Core Domains geeignet, da sie:
- ✅ Die **Geschäftslogik völlig unabhängig** von Infrastruktur (Datenbank, Framework) macht
- ✅ **Hohe Testbarkeit** ermöglicht (Domain Layer ohne DB/Framework testbar)
- ✅ **Flexibilität** bei Technologie-Wechseln bietet (z.B. ORM austauschen)
- ✅ **Klare Schichten-Trennung** für bessere Wartbarkeit schafft
{{/wenn}}

{{#wenn_event_driven}}
Event-Driven Architecture ist optimal für diesen Context, da:
- ✅ **Asynchrone** Verarbeitung die Reaktionsfähigkeit erhöht
- ✅ **Lose Kopplung** zu anderen Contexts gewährleistet wird
- ✅ **Hohe Skalierbarkeit** durch Message Queue erreicht wird
- ✅ **Ausfallsicherheit** durch Event-Replay möglich ist
{{/wenn}}

{{#wenn_layered_cqrs}}
Layered Architecture mit CQRS ist optimal, da:
- ✅ **Read-Heavy** Workload effizient bedient wird
- ✅ **Denormalisierte Read-Models** schnelle Abfragen ermöglichen
- ✅ **Caching** für häufige Zugriffe einfach integrierbar ist
- ✅ **Pragmatischer Ansatz** für Supporting Subdomain ausreichend ist
{{/wenn}}

{{#wenn_layered}}
Layered Architecture ist optimal, da:
- ✅ **Einfache Entwicklung** und Wartung gewährleistet ist
- ✅ **Schnelle Time-to-Market** für Supporting Subdomain erreicht wird
- ✅ **Geringere Komplexität** ausreichend für die Anforderungen ist
{{/wenn}}

{{#wenn_microservices}}
Microservices-Architektur ist optimal, da:
- ✅ **Unabhängige Skalierung** bei Verkehrsspitzen möglich ist
- ✅ **Team-Autonomie** (eigener Deployment-Zyklus) erreicht wird
- ✅ **Technologie-Freiheit** pro Service gewährleistet ist
{{/wenn}}

{{#wenn_generic_subdomain}}
Integration bestehender Lösungen (Buy over Build) ist optimal, da:
- ✅ **Generic Subdomain** keine Eigenentwicklung rechtfertigt
- ✅ **Minimaler Entwicklungsaufwand** gewünscht ist
- ✅ **Bewährte Lösungen** verfügbar sind
- ✅ **Fokus auf sichere Integration** ausreichend ist
{{/wenn}}

#### Layer-Struktur

```
{{context_name}}-Context/
{{verzeichnisstruktur}}
```

{{#wenn_geschäftsregeln}}
#### Geschäftsregeln (Invarianten)

**Im Aggregat `{{aggregat_name}}`:**
{{#für_jede_geschäftsregel}}
- {{geschäftsregel_beschreibung}}
{{/für_jede_geschäftsregel}}
{{/wenn}}

{{#wenn_domain_events}}
#### Domain Events

| Event | Auslöser | Consumer |
|-------|----------|----------|
{{#für_jedes_event}}
| `{{event_name}}` | {{auslöser}} | {{consumer}} |
{{/für_jedes_event}}
{{/wenn}}

{{#wenn_mapping_zu_user_stories}}
#### Mapping zu User Stories

| User Story | Aggregate | Use Case | Methoden |
|------------|-----------|----------|----------|
{{#für_jede_user_story}}
| {{user_story_titel}} | `{{aggregat}}` | `{{use_case}}` | `{{methoden}}` |
{{/für_jede_user_story}}
{{/wenn}}

{{#wenn_event_consumer_logik}}
#### Event-Consumer-Logik

{{event_consumer_beschreibung}}
{{/wenn}}

{{#wenn_cqrs_pattern}}
#### CQRS-Pattern

**Write-Side (Commands):**
{{write_side_beschreibung}}

**Read-Side (Queries):**
{{read_side_beschreibung}}
{{/wenn}}

{{#wenn_geschäftslogik}}
#### Geschäftslogik

{{geschäftslogik_beschreibung}}
{{/wenn}}

{{#wenn_features}}
#### Features

{{#für_jedes_feature}}
**{{feature_name}}:**
{{feature_beschreibung}}
{{/für_jedes_feature}}
{{/wenn}}

{{#wenn_fertige_lösungen}}
#### Empfohlene Fertige Lösungen

| Bereich | Empfohlene Lösung | Begründung | {{compliance_spalte}} |
|---------|------------------|------------|{{compliance_spalte_separator}}|
{{#für_jede_lösung}}
| **{{bereich}}** | **{{lösung}}** | {{begründung}} | {{compliance_status}} |
{{#wenn_alternative}}
| | Alternative: {{alternative}} | {{alternative_begründung}} | {{alternative_compliance}} |
{{/wenn}}
{{/für_jede_lösung}}
{{/wenn}}

{{#wenn_integration_pattern}}
#### Integration-Pattern

{{integration_pattern_beschreibung}}

```{{sprache}}
{{code_beispiel}}
```

**Vorteile:**
{{#für_jeden_vorteil}}
- ✅ {{vorteil}}
{{/für_jeden_vorteil}}
{{/wenn}}

#### Vorteile

{{#für_jeden_vorteil}}
- ✅ {{vorteil}}
{{/für_jeden_vorteil}}

---

{{/für_jeden_bounded_context}}

## 5. Zusammenfassung: Architektur-Übersicht

### Architektur-Entscheidungen im Überblick

| Bounded Context | Kategorie | Primäres Ziel | Architekturmuster | Technologie-Stack |
|-----------------|-----------|---------------|-------------------|-------------------|
{{#für_jeden_bounded_context}}
| **{{context_name}}** | {{kategorie}} | {{primäres_ziel}} | **{{architekturmuster}}** | {{technologie_stack}} |
{{/für_jeden_bounded_context}}

---

### Context-Kommunikation

```mermaid
graph TD
{{#für_jeden_bounded_context}}
    {{context_variable}}[{{context_name}}<br/>{{architekturmuster_kurz}}]
{{/für_jeden_bounded_context}}
{{#für_jede_kommunikation}}
    {{source}} -->|{{kommunikations_typ}}| {{target}}
{{/für_jede_kommunikation}}
```

**Kommunikations-Patterns:**
{{#für_jedes_pattern}}
- **{{pattern_name}}** für {{pattern_beschreibung}}
{{/für_jedes_pattern}}

---

## 6. Deployment-Architektur

### Empfohlene Deployment-Strategie

**Phase 1: {{phase_1_name}}**
{{phase_1_beschreibung}}
{{#für_jeden_punkt}}
- {{punkt}}
{{/für_jeden_punkt}}

**Phase 2: {{phase_2_name}}**
{{phase_2_beschreibung}}
{{#für_jeden_punkt}}
- {{punkt}}
{{/für_jeden_punkt}}

**Phase 3: {{phase_3_name}}**
{{phase_3_beschreibung}}
{{#für_jeden_punkt}}
- {{punkt}}
{{/für_jeden_punkt}}

---

## 7. Nächste Schritte

### Phase A: {{phase_name}} ({{sprint_info}})
{{#für_jeden_schritt}}
{{schritt_nummer}}. ✅ {{schritt_beschreibung}}
{{#wenn_substeps}}
   {{#für_jeden_substep}}
   - {{substep}}
   {{/für_jeden_substep}}
{{/wenn}}
{{/für_jeden_schritt}}

### Phase B: {{phase_name}} ({{sprint_info}})
{{#für_jeden_schritt}}
{{schritt_nummer}}. ✅ **{{schritt_titel}}** {{#wenn_details}}({{details}}){{/wenn}}
   {{#für_jeden_substep}}
   - {{substep}}
   {{/für_jeden_substep}}
{{/für_jeden_schritt}}

### Phase C: {{phase_name}} ({{sprint_info}})
{{#für_jeden_schritt}}
{{schritt_nummer}}. ✅ **{{schritt_titel}}** {{#wenn_details}}({{details}}){{/wenn}}
   {{#für_jeden_substep}}
   - {{substep}}
   {{/für_jeden_substep}}
{{/für_jeden_schritt}}

### Phase D: {{phase_name}} ({{sprint_info}})
{{#für_jeden_schritt}}
{{schritt_nummer}}. ✅ **{{schritt_titel}}**
   {{#für_jeden_substep}}
   - {{substep}}
   {{/für_jeden_substep}}
{{/für_jeden_schritt}}

---

## 8. Risiken und Mitigationen

| Risiko | Wahrscheinlichkeit | Impact | Mitigation |
|--------|-------------------|--------|------------|
{{#für_jedes_risiko}}
| **{{risiko_titel}}** | {{wahrscheinlichkeit}} | {{impact}} | {{mitigation}} |
{{/für_jedes_risiko}}

---

## 9. Referenzen

{{#für_jede_referenz}}
- **{{referenz_titel}}:** {{referenz_details}}
{{/für_jede_referenz}}

---

*Letzte Aktualisierung: {{datum}}*
