# Layered Architecture (Layered / N-Tier)

> **Quelle:** Classic Architectural Patterns  
> **Kategorie:** Architectural Pattern  
> **Ebene:** Gesamtarchitektur

---

## 🎯 Ziel

Einfache Entwicklung und Wartung durch klare Trennung von Verantwortlichkeiten in Schichten (Presentation, Business, Data). Gut geeignet für kleine bis mittelgroße Anwendungen mit stabilen Anforderungen.

---

## 📋 Architektur-Schichten

| Schicht | Zweck | Artefakte | Hauptverantwortung |
|---------|-------|-----------|-------------------|
| **Presentation Layer** | UI / API Endpoints | Controllers, Views, DTOs | Eingabevalidierung, Mapping |
| **Application / Service Layer** | Orchestrierung von Use-Cases | Application Services, DTO Mappers | Koordination, Transaktionsgrenzen |
| **Business / Domain Layer** | Geschäftslogik | Entities, Value Objects, Domain Services | Kernlogik, Invarianten |
| **Persistence / Data Layer** | Datenzugriff | Repositories, DAOs, Migrations | Persistenz, Queries |

---

## 🏗️ Architektur-Diagramm

```
┌──────────────────────────────┐
│      Presentation Layer      │
│  (Controllers, Views, DTOs)  │
└─────────────┬────────────────┘
              │ depends on
┌─────────────▼────────────────┐
│   Application / Service Layer│
│   (Use Cases, Services)      │
└─────────────┬────────────────┘
              │ depends on
┌─────────────▼────────────────┐
│      Business / Domain Layer │
│ (Entities, Domain Services)  │
└─────────────┬────────────────┘
              │ implemented by
┌─────────────▼────────────────┐
│     Persistence / Data Layer │
│     (Repositories, DAOs)     │
└──────────────────────────────┘
```

**Regel:** Abhängigkeiten zeigen typischerweise nach unten (Presentation → Application → Domain → Data).

---

## ✅ Best Practices

| Regel | Beschreibung |
|-------|--------------|
| **Klare Schichtgrenzen** | Logik klar in die passende Schicht platzieren. |
| **Keine Business-Logik in Presentation** | Presentation darf keine Geschäftsregeln enthalten. |
| **Transaktionsgrenzen** | Application Layer definiert Transaktionsgrenzen. |
| **Re-use durch Services** | Business-Logik in wiederverwendbaren Services organisieren. |
| **DTOs für Schnittstellen** | Verwendung von DTOs zwischen Layern/Netzwerkgrenzen. |
| **Testbarkeit** | Unit Tests pro Schicht (Domain unabhängig von Frameworks). |

---

## 💻 Beispiel: Verzeichnisstruktur

```
src/
 ├─ presentation/
 │   ├─ controllers/
 │   └─ dto/
 ├─ application/
 │   ├─ services/
 │   └─ commands/
 ├─ domain/
 │   ├─ model/
 │   └─ services/
 └─ infrastructure/
     ├─ persistence/
     └─ external/
```

---

## 🤖 KI-Agent Hinweise

* Platziere Geschäftsregeln im Domain-Layer.
* Use-Case-Orchestrierung im Application Layer (keine Domain-Logik dort).
* Verwende Interfaces/Ports für Persistence, Implementierung in Infrastructure.
* Vermeide direkte Datenbankzugriffe in Presentation.

---

## 📌 Checkliste

- [ ] Schichtgrenzen dokumentiert
- [ ] Geschäftslogik in Domain-Layer
- [ ] DTOs in Presentation/Application
- [ ] Repositories als Interfaces in Domain
- [ ] Persistence-Implementierungen in Infrastructure
- [ ] Unit Tests für Domain-Logik

---

## ⚠️ Anti-Patterns vermeiden

❌ **Anemic Domain Model (Datenobjekte ohne Verhalten)**
```java
public class User {
    private String name;
    private String email;
    // nur Getter/Setter -> Logik fehlt
}
```

✅ **Rich Domain Model**
```java
public class User {
    private final String name;
    private final Email email;
    public void changeEmail(Email newEmail) { /* Validierung */ }
}
```

❌ **Business-Logik in Presentation Layer**
```java
// FALSCH
public Response createOrder(Request req) {
    // komplexe Preisberechnung hier -> falsch
}
```

✅ **Business-Logik in Domain**
```java
// RICHTIG
public class OrderService {
    public Order createOrder(CreateOrderCommand cmd) { /* complex logic */ }
}
```

---

## 🔧 Technologie-Stack Beispiele

- Java/Spring Boot (Controller → Service → Repository)
- .NET (MVC → Application Services → Repositories)
- Node.js (Express → Services → Data Access)

---

## 📊 Wann Layered Architecture verwenden?

| ✅ Geeignet für | ❌ Nicht geeignet für |
|----------------|----------------------|
| Kleine bis mittelgroße Apps | Sehr dynamische, hochskalierbare Plattformen |
| Teams mit klarer Aufgabenverteilung | Systeme mit hoher Service-Unabhängigkeit |
| Klassische Webanwendungen | Microservices-first-Strategie |

---

## 🔗 Referenzen

- Related Patterns: Hexagonal Architecture, Modular Monolith
- Projekt-Beispiele: `docs/architecture/domain-categorization.md`
- Literatur: "Patterns of Enterprise Application Architecture" by Martin Fowler
