# Hexagonal Architecture (Ports & Adapters)

> **Quelle:** Domain-Driven Design Best Practices  
> **Kategorie:** Architectural Pattern  
> **Ebene:** Gesamtarchitektur

---

## 🎯 Ziel

Trennung von fachlicher Logik (Domain) und technischer Infrastruktur (Framework, DB, APIs).

---

## 📋 Architektur-Schichten

| Schicht | Zweck | Artefakte | Hauptverantwortung |
|---------|-------|-----------|-------------------|
| **Domain Layer** | Fachlogik, Invarianten, Modelle | Entities, Value Objects, Domain Events | Kernlogik, unabhängig von Frameworks |
| **Application Layer** | Orchestrierung von Use-Cases | Application Services | Koordination, keine Business-Logik |
| **Infrastructure Layer** | Technische Umsetzung | Repositories, DB, APIs, Frameworks | Persistenz, Messaging, I/O |
| **Interface Layer** | User- & System-Eingabe | Controller, DTOs, Commands | Eingabevalidierung, Mapping |

---

## 🏗️ Abhängigkeitsregeln

```
┌─────────────────────────────────────┐
│       Interface Layer               │
│   (Controllers, DTOs, REST)         │
└─────────────┬───────────────────────┘
              │ depends on
┌─────────────▼───────────────────────┐
│    Application Layer                │
│  (Services, Commands, Queries)      │
└─────────────┬───────────────────────┘
              │ depends on
┌─────────────▼───────────────────────┐
│       Domain Layer                  │
│ (Aggregates, Entities, VOs, Events) │
└─────────────────────────────────────┘
              ▲
              │ implements
┌─────────────┴───────────────────────┐
│   Infrastructure Layer              │
│ (Repositories Impl, DB, External)   │
└─────────────────────────────────────┘
```

**Regel:** Domain Layer darf **keine** Abhängigkeiten nach außen haben!

---

## ✅ Best Practices

| Regel | Beschreibung |
|-------|--------------|
| **Domain ist isoliert** | Keine Framework-Abhängigkeiten (Spring, JPA, etc.) in Domain. |
| **Ports & Adapters** | Interfaces (Ports) in Domain, Implementierungen (Adapters) in Infrastructure. |
| **Dependency Inversion** | Domain definiert Interfaces, Infrastructure implementiert sie. |
| **Testbarkeit** | Domain ohne Framework testbar (Unit Tests). |

---

## 💻 Beispiel: Verzeichnisstruktur

```
src/
 ├─ domain/
 │   ├─ model/
 │   │   ├─ user/
 │   │   │   ├─ User.java          (Entity)
 │   │   │   ├─ Email.java         (Value Object)
 │   │   │   └─ UserCreated.java   (Domain Event)
 │   │   └─ order/
 │   │       ├─ Order.java
 │   │       ├─ OrderItem.java
 │   │       └─ Money.java
 │   └─ repository/
 │       ├─ UserRepository.java    (Interface, Port)
 │       └─ OrderRepository.java
 │
 ├─ application/
 │   ├─ service/
 │   │   ├─ UserService.java
 │   │   └─ OrderService.java
 │   └─ command/
 │       ├─ CreateUserCommand.java
 │       └─ CreateOrderCommand.java
 │
 ├─ infrastructure/
 │   ├─ persistence/
 │   │   ├─ JpaUserRepository.java     (Adapter, implements UserRepository)
 │   │   └─ JpaOrderRepository.java
 │   ├─ messaging/
 │   │   └─ KafkaEventPublisher.java
 │   └─ configuration/
 │       └─ BeanConfiguration.java
 │
 └─ interface/
     └─ rest/
         ├─ UserController.java
         ├─ OrderController.java
         └─ dto/
             ├─ CreateUserRequest.java
             └─ OrderResponse.java
```

---

## 🤖 KI-Agent Hinweise

* Generiere Domain-Code **ohne** Framework-Annotations (`@Entity`, `@Autowired`).
* Repositories als Interfaces in Domain, Implementierung in Infrastructure.
* DTOs nur in Interface Layer, nie im Domain.
* Mapping Domain ↔ DTO in Application oder Interface Layer.

---

## 📌 Checkliste

- [ ] Domain Layer hat **keine** Abhängigkeiten zu Spring/JPA/etc.
- [ ] Repository-Interfaces in `domain/repository`
- [ ] Repository-Implementierungen in `infrastructure/persistence`
- [ ] Application Services koordinieren, enthalten keine Business-Logik
- [ ] DTOs nur in Interface Layer
- [ ] Domain Events werden in Application/Infrastructure publiziert
- [ ] Testbare Domain (Unit Tests ohne Framework)

---

## ⚠️ Anti-Patterns vermeiden

❌ **Framework-Annotations in Domain**
```java
// FALSCH
@Entity  // JPA in Domain!
public class User {
    @Id
    private UUID id;
}
```

✅ **Domain ohne Framework**
```java
// RICHTIG
public class User {
    private final UUID id;  // Keine Annotations
}
```

❌ **Repository-Implementierung in Domain**
```java
// FALSCH
// domain/repository/UserRepository.java
@Repository
public class UserRepository {
    @Autowired
    private JpaRepository repo;  // Infrastructure in Domain!
}
```

✅ **Interface in Domain, Implementierung in Infrastructure**
```java
// RICHTIG
// domain/repository/UserRepository.java
public interface UserRepository {
    Optional<User> findById(UUID id);
}

// infrastructure/persistence/JpaUserRepository.java
@Repository
public class JpaUserRepository implements UserRepository {
    // ...
}
```

---

## 🔗 Referenzen

- Related Patterns: All patterns in `architecture/patterns/`
- Projekt-Beispiele: `docs/architecture/domain-categorization.md`
- Alistair Cockburn: Hexagonal Architecture (Ports & Adapters)
