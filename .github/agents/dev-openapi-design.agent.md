---
description: Führt Sie durch die taktischen Design-Entscheidungen und Implementierungsschritte basierend auf Domain-Driven Design (DDD)
tools: ['edit', 'search', 'Ref/*', 'sequentialthinking/*', , 'fetch', 'todos']
handoffs:
  - label: ➡️ OpenAP Design starten
    agent: dev-openapi-design
    prompt: 'Das Domain-Modell ist vollständig dokumentiert und visualisiert. Beginne nun mit der Implementierung. Analysiere die vorhandenen Dokumente: - docs/architecture/domain-model.md - docs/architecture/ubiquitous-language-glossar.md - docs/architecture/aggregates-entities-valueobjects.md - docs/architecture/traceability-matrix.md- docs/architecture/domain-models/*.puml Imlementiere die Aggregate, Entitäten, Reposistorie, DomainServices und Value Objects gemäß API-First DDD Workflow.'
    send: false
---

### Phase 1: Story Selection & Analysis

**Step 1.1: User Story auswählen**

```prompt
Wähle die nächste umzusetzende User Story aus docs/requirements/user-stories/refined/:

- Priorisierung: MVP > Must-Have > Should-Have > Nice-to-Have
- Abhängigkeiten: Stories mit wenigen Dependencies zuerst
- Bounded Context: Gruppiere Stories nach Bounded Context

Zeige:
- User Story ID & Titel
- Epic & Bounded Context
- Priorität & Story Points
- Abhängigkeiten zu anderen Stories
```

**Step 1.2: Story analysieren**

Analysiere die ausgewählte User Story:

1. **Akzeptanzkriterien** durchgehen
2. **Gherkin-Szenarien** identifizieren
3. **Betroffene Bounded Contexts** ermitteln
4. **Aggregates & Entities** aus Domain Model referenzieren
5. **Business Rules** aus Ubiquitous Language extrahieren

**Output:** Story Analysis Document
```markdown
# Story Analysis: [US-ID] [Titel]

## Bounded Context
- Primary: [Context Name]
- Secondary: [Context Name] (optional)

## Betroffene Aggregates
- [Aggregate Root 1]: [Beschreibung]
- [Aggregate Root 2]: [Beschreibung]

## Business Rules
1. [Rule aus Glossar]
2. [Rule aus Glossar]

## Domain Events
- [Event Name]: Wann ausgelöst?
- [Event Name]: Wann ausgelöst?

## Externe Dependencies
- [Service/System]: Wofür?
```

---

### Phase 2: API-First Design

**Step 2.1: OpenAPI Specification erstellen**

Erstelle/erweitere die OpenAPI Spec für die Story:

```prompt
Erstelle eine OpenAPI 3.0 Spezifikation für [User Story]:

Datei: api/openapi/[bounded-context].yaml

Berücksichtige:
1. RESTful Design Principles
2. Resource Naming (aus Ubiquitous Language)
3. HTTP Methods (GET, POST, PUT, PATCH, DELETE)
4. Request/Response Schemas
5. Error Responses (4xx, 5xx)
6. Authentication & Authorization (Bearer Token)
7. Pagination für Listen
8. Filtering & Sorting
9. HATEOAS Links (optional)

Verwende Schemas aus:
- docs/architecture/aggregates-entities-valueobjects.md
- docs/architecture/ubiquitous-language-glossar.md
```

Verwende das template: `api/openapi/bounded-context.template.yaml`

Speichere das OpenAPI Spec unter `docs/api/[bounded-context].yaml`


**Step 2.2: API Review**

```prompt
Überprüfe die OpenAPI Spec jedes bounded-contexts gegen:

1. ✅ Naming Conventions (aus Ubiquitous Language)
2. ✅ RESTful Best Practices
3. ✅ Vollständigkeit aller Akzeptanzkriterien
4. ✅ Error Handling
5. ✅ Security (Authentication/Authorization)
6. ✅ Pagination & Filtering
7. ✅ Documentation Quality
8. ✅ Schema Validations

Erstelle Review-Checklist und dokumentiere Findings.
```