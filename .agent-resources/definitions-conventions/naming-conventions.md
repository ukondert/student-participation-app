# Naming Conventions

> **Quelle:** Domain-Driven Design Best Practices  
> **Kategorie:** Coding Standards  
> **Ebene:** Code-Qualität

---

## 🎯 Ziel

Konsistente, sprechende Namen basierend auf der Ubiquitous Language.

---

## 📋 Naming-Regeln

### Value Objects
- **Format:** Substantiv, beschreibt das Konzept
- **Beispiele:** `Email`, `Money`, `Address`, `PhoneNumber`, `OrderStatus`
- **Anti-Pattern:** `EmailVO`, `EmailValueObject` (Suffix unnötig)

### Entities
- **Format:** Substantiv, beschreibt das fachliche Objekt
- **Beispiele:** `User`, `Order`, `Product`, `Customer`
- **Anti-Pattern:** `UserEntity` (Suffix unnötig)

### Aggregates
- **Format:** Substantiv, Name des Aggregate Root
- **Beispiele:** `Order` (mit `OrderItem`), `User` (mit `EmergencyContact`)
- **Konvention:** Root-Entity = Aggregate-Name

### Repositories
- **Format:** `<Entity>Repository`
- **Beispiele:** `UserRepository`, `OrderRepository`
- **Interface:** Im Domain Layer
- **Implementierung:** `Jpa<Entity>Repository`, `Mongo<Entity>Repository` (in Infrastructure)

### Factories
- **Format:** `<Entity>Factory` oder Static Method `of()`/`create()`
- **Beispiele:** 
  - Klasse: `OrderFactory`
  - Method: `Email.of(string)`, `Money.create(amount, currency)`

### Domain Events
- **Format:** `<Entity><Action>Event` (Vergangenheitsform)
- **Beispiele:** `OrderCreatedEvent`, `UserEmailChangedEvent`, `PaymentReceivedEvent`
- **Anti-Pattern:** `CreateOrderEvent` (Präsens), `OrderEvent` (zu generisch)

### Application Services
- **Format:** `<UseCaseDomain>Service`
- **Beispiele:** `OrderService`, `UserService`, `PaymentService`
- **Methoden:** Verb + Substantiv (`createOrder`, `cancelOrder`, `changeEmail`)

### Commands (DTOs)
- **Format:** `<Action><Entity>Command`
- **Beispiele:** `CreateOrderCommand`, `UpdateUserEmailCommand`, `CancelOrderCommand`
- **Alternative:** `<Action><Entity>Request` (REST-Kontext)

### Queries (DTOs)
- **Format:** `<Entity>Query` oder `Find<Criteria>Query`
- **Beispiele:** `OrderQuery`, `FindActiveOrdersQuery`, `UserSearchQuery`

### Controllers
- **Format:** `<Entity>Controller`
- **Beispiele:** `UserController`, `OrderController`
- **Methoden:** HTTP-Verb-basiert (`getUser`, `createOrder`, `updateEmail`)

---

## 💻 Beispiele

### Value Object

```java
// ✅ RICHTIG
public record Email(String value) { }

// ❌ FALSCH
public record EmailVO(String value) { }
public record EmailValueObject(String value) { }
```

### Entity

```java
// ✅ RICHTIG
public class User { }

// ❌ FALSCH
public class UserEntity { }
public class UserDomainModel { }
```

### Repository

```java
// ✅ RICHTIG (Domain)
public interface OrderRepository { }

// ✅ RICHTIG (Infrastructure)
public class JpaOrderRepository implements OrderRepository { }

// ❌ FALSCH
public interface IOrderRepository { }  // Java nutzt kein 'I'-Prefix
public class OrderRepositoryImpl { }   // Generischer Suffix
```

### Domain Event

```java
// ✅ RICHTIG
public record OrderCreatedEvent(UUID orderId, LocalDateTime createdAt) { }
public record UserEmailChangedEvent(UUID userId, Email newEmail) { }

// ❌ FALSCH
public record CreateOrderEvent(...) { }  // Präsens
public record OrderEvent(...) { }        // Zu generisch
public record OrderCreated(...) { }      // Fehlendes 'Event'-Suffix
```

### Application Service

```java
// ✅ RICHTIG
@Service
public class OrderService {
    public UUID createOrder(CreateOrderCommand cmd) { }
    public void cancelOrder(UUID orderId) { }
}

// ❌ FALSCH
public class OrderApplicationService { }  // Redundant
public class OrderManager { }             // Unklare Verantwortung
```

---

## 🤖 KI-Agent Hinweise

* Verwende **Ubiquitous Language** aus `docs/architecture/ubiquitous-language_nomen&verben.md`
* Keine technischen Suffixe in Domain (`*VO`, `*Entity`, `*DomainModel`)
* Events immer Vergangenheitsform + `Event`-Suffix
* Service-Methoden: Verb + Substantiv (fachliche Sprache)

---

## 📌 Checkliste

- [ ] Value Objects: Substantiv, kein Suffix
- [ ] Entities: Substantiv, kein `Entity`-Suffix
- [ ] Repositories: `<Entity>Repository` (Interface), `<Tech><Entity>Repository` (Impl)
- [ ] Domain Events: Vergangenheitsform + `Event`
- [ ] Application Services: `<Domain>Service`
- [ ] Commands: `<Action><Entity>Command`
- [ ] Keine Abkürzungen (außer etabliert: `Id`, `DTO`)
- [ ] CamelCase für Java/C#, snake_case für DB-Spalten

---

## 🔗 Referenzen

- Ubiquitous Language: `docs/architecture/ubiquitous-language_nomen&verben.md`
- Directory Structure: `directory-structure.md`
