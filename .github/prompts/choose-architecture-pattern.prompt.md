---
description: 'Choose architecture patterns for bounded contexts based on domain categorization'
mode: 'agent'
---

# Architekturmuster wählen

Du bist ein Software-Architekt, der basierend auf der **bereits durchgeführten Domänen-Kategorisierung** das optimale Architekturmuster für jeden Bounded Context vorschlägt.

## Eingabe-Kontext

Analysiere folgende Dokumente:
- **Domänen-Kategorisierung:** [domain-categorization.md](../../../docs/architecture/domain-categorization.md)
- **Bounded Contexts:** [bounded-contexts.md](../../../docs/architecture/bounded-contexts.md)

**Projekt-Kontext:**
- Team-Größe: ${input:teamSize:3-5 Entwickler}
- Erwartete Nutzer: ${input:expectedUsers:500-2000}
- Deployment: ${input:deployment:Cloud, On-Premise}
- Zeitrahmen: ${input:timeline:MVP in 3 Monaten}

## Aufgabe
Analysiere die **Core Domain, Supporting Subdomains und Generic Subdomains** aus der Kategorisierung und schlage für jeden Bounded Context das passende Architekturmuster vor.

## Referenzen

- [Domänen-Kategorisierung](../../../docs/architecture/domain-categorization.md)
- [Bounded Contexts](../../../docs/architecture/bounded-contexts.md)
- [Hexagonale Architektur](../../architecture/layers/hexagonal-architecture.md)

## Entscheidungskriterien

Nutze die **Investitionsstrategie** aus der Domänen-Kategorisierung

## Ausgabe-Format

Erstelle für jeden Bounded Context eine Architektur-Empfehlung:

```markdown
## Architektur-Empfehlungen pro Bounded Context

### 1. Fahrtenmanagement-Context (Core Domain)
**Empfohlenes Muster:** Hexagonale Architektur (Ports & Adapters)

**Begründung:**
- Kerngeschäft der Plattform (Matching, Anfragen, Status)
- Hohe fachliche Komplexität (Invarianten, Geschäftsregeln)
- Testbarkeit kritisch (Unit Tests ohne DB/Framework)
- Unabhängigkeit von Infrastruktur (Prisma, REST API)

**Architektur-Schichten:**
- **Domain Layer:** Aggregate (Fahrt), Entities (MitfahrerAnfrage), Value Objects (StartOrt)
- **Application Layer:** Use Cases (CreateRideUseCase, AcceptRequestUseCase)
- **Infrastructure Layer:** Repositories (PrismaRideRepository), External Services (Geocoding)
- **Interface Layer:** REST API (NestJS Controller), GraphQL Resolver

**Referenz:**
- [Hexagonale Architektur](../../architecture/layers/hexagonal-architecture.md)
- [Aggregate Design](../../architecture/patterns/aggregate-design.md)

---

### 2. Benutzer-Context (Core Domain)
**Empfohlenes Muster:** Hexagonale Architektur (Ports & Adapters)

**Begründung:**
- Schulische Verifizierung ist einzigartig (Core Domain)
- DSGVO-Konformität kritisch (Soft Delete, Anonymisierung)
- Sperr-/Löschlogik komplex (Admin-Workflow)

**Architektur-Schichten:**
- **Domain Layer:** Aggregate (Benutzer), Entities (Notfallkontakt), Value Objects (Email, Passwort)
- **Application Layer:** Use Cases (RegisterUserUseCase, VerifyEmailUseCase)
- **Infrastructure Layer:** Repositories (PrismaUserRepository), Auth (SuperTokens Adapter)
- **Interface Layer:** REST API (AuthController)

---

### 3. Kommunikations-Context (Core Domain)
**Empfohlenes Muster:** Hexagonale Architektur (Ports & Adapters)

**Begründung:**
- Missbrauchsmeldung ist sicherheitskritisch (Core Domain)
- Admin-Workflow komplex (Warnungen, Sperrungen, Einsprüche)
- Integration mit Benutzer-Context (Domain Events)

**Architektur-Schichten:**
- **Domain Layer:** Aggregate (Missbrauchsmeldung), Entities (Beweis, Admin-Aktion)
- **Application Layer:** Use Cases (ReportAbuseUseCase, IssueWarningUseCase)
- **Infrastructure Layer:** Repositories, Notification Services (Push, SMS, Email)
- **Interface Layer:** REST API, WebSockets (Chat - Should-Have)

---

### 4. Analyse- und Statistik-Context (Supporting Subdomain)
**Empfohlenes Muster:** Layered Architecture (3-Schichten)

**Begründung:**
- Standard-Berichts-Logik (nicht differenzierend)
- Moderate Komplexität (Aggregation, Visualisierung)
- Integration mit Fahrtenmanagement-Context (Read Model)

**Architektur-Schichten:**
- **Presentation Layer:** Dashboard UI, Chart Components
- **Business Logic Layer:** Report Services, Metrics Aggregation
- **Data Access Layer:** Read-Only Repositories, CQRS Query Side

---

### 5. Vergütungs-Context (Supporting Subdomain)
**Empfohlenes Muster:** Layered Architecture (3-Schichten)

**Begründung:**
- Standard-Belohnungssystem (ähnlich wie Treueprogramme)
- Moderate Komplexität (Punkte, Voucher)
- Integration mit Fahrtenmanagement-Context (Domain Events)

**Architektur-Schichten:**
- **Business Logic Layer:** Reward Services, Voucher Generation
- **Data Access Layer:** Repositories (RewardAccount, Voucher)

---

### 6. Admin-Context (Generic Subdomain)
**Empfohlenes Muster:** Admin-Panel-Framework (z.B. AdminJS, Strapi, Directus)

**Begründung:**
- Standard-Admin-Funktionen (CRUD, Audit-Log, CSV-Export)
- Minimale Ressourcen, fertige Lösung bevorzugt
- Integration mit Core Domain über APIs

**Komponenten:**
- **Admin-Panel:** Strapi/AdminJS (Out-of-the-Box UI)
- **Audit-Log:** Database Triggers + Read-Only View
- **CSV-Export:** Library (csv-parser, papaparse)

---

### 7. Infrastruktur-Context (Generic Subdomain)
**Empfohlenes Muster:** Adapter-Pattern (Ports & Adapters für Integration)

**Begründung:**
- Standard-Services (Auth, Email, Storage, Geocoding)
- Fertige Lösungen (SuperTokens, SendGrid, AWS S3, Nominatim)
- Fokus auf sichere Integration

**Komponenten:**
- **Auth:** SuperTokens (Session Management, OAuth2)
- **Email:** SendGrid/AWS SES (SMTP Adapter)
- **Storage:** AWS S3/Cloudinary (Blob Storage Adapter)
- **Geocoding:** OpenStreetMap Nominatim (HTTP Adapter)
- **Push/SMS:** Firebase Cloud Messaging, Twilio (API Adapter)

---

## Zusammenfassung

| Context | Kategorie | Architekturmuster | Begründung |
|---------|-----------|-------------------|------------|
| **Fahrtenmanagement** | Core Domain | Hexagonale Architektur | Kerngeschäft, hohe Komplexität, Testbarkeit |
| **Benutzer** | Core Domain | Hexagonale Architektur | DSGVO, schulische Verifizierung, Sicherheit |
| **Kommunikation** | Core Domain | Hexagonale Architektur | Missbrauchsmeldung, Admin-Workflow |
| **Analyse & Statistik** | Supporting | Layered Architecture | Standard-Berichte, moderate Komplexität |
| **Vergütung** | Supporting | Layered Architecture | Standard-Belohnungssystem |
| **Admin** | Generic | Admin-Panel-Framework | CRUD, Audit-Log, fertige Lösung |
| **Infrastruktur** | Generic | Adapter-Pattern | Auth, Email, Storage, Geocoding |
```

---

## Risiken & Trade-offs

### Hexagonale Architektur (Core Domain)
✅ **Vorteile:**
- Testbarkeit ohne Infrastruktur
- Unabhängigkeit von Frameworks
- Klare Domänen-Grenzen

⚠️ **Risiken:**
- Höherer initialer Aufwand
- Mehr Abstraktionen (Ports/Adapters)
- Benötigt DDD-Know-how im Team

**Mitigation:**
- Schulungen/Pair Programming
- Code-Generatoren (Templates)
- `.github-copilot/` Best Practices nutzen

### Layered Architecture (Supporting Subdomains)
✅ **Vorteile:**
- Einfacher zu verstehen
- Schnellere Entwicklung

⚠️ **Risiken:**
- Tendenz zu Anemic Domain Model
- Schlechter testbar (DB-Abhängigkeit)

**Mitigation:**
- Business Logic in Services kapseln
- Integration Tests bevorzugen

### Admin-Panel-Framework (Generic Subdomain)
✅ **Vorteile:**
- Out-of-the-Box UI
- Minimaler Entwicklungsaufwand

⚠️ **Risiken:**
- Vendor Lock-in
- Eingeschränkte Anpassbarkeit

**Mitigation:**
- Open-Source-Framework wählen
- API-First-Design (Headless Admin)

---

## Nächste Schritte

1. **Dokumentation aktualisieren:**
   - Erstelle `architecture-decisions.md` in [docs/architecture/](../../../docs/architecture/)
   - Architecture Decision Records (ADR) für Core Domain

2. **Verzeichnisstruktur anlegen:**
   ```
   src/
   ├── fahrtenmanagement/        # Hexagonal Architecture
   │   ├── domain/
   │   ├── application/
   │   ├── infrastructure/
   │   └── interface/
   ├── benutzer/                 # Hexagonal Architecture
   ├── kommunikation/            # Hexagonal Architecture
   ├── analyse/                  # Layered Architecture
   ├── verguetung/               # Layered Architecture
   └── shared/                   # Shared Kernel (Value Objects, Events)
   ```

3. **Technologie-Stack definieren:**
   - Backend: NestJS (TypeScript)
   - ORM: Prisma
   - Auth: SuperTokens
   - Admin: Strapi/AdminJS
   - Testing: Jest, Supertest

---

## Beispiel-Verwendung

In der Chat-Ansicht:
```
/choose-architecture-pattern teamSize="3-5 Entwickler" expectedUsers="500-2000" deployment="AWS Cloud" timeline="MVP in 3 Monaten"
```

Oder als Kommando:
**Chat: Run Prompt** → `choose-architecture-pattern`

---

*Referenziert: [Hexagonale Architektur](../../architecture/layers/hexagonal-architecture.md), [Domain Categorization](../../../docs/architecture/domain-categorization.md)*
