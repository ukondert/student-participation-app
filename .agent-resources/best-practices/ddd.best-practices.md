Perfekt ✅ — also:
**Ziel:** Eine **vollständige, KI-agentenoptimierte DDD-Best-Practice-Dokumentation** im **Markdown-Format**, mit Fokus auf:

* **Value Objects** (inkl. Validierung),
* **Entities**,
* **Aggregates**,
* **Repositories**,
* **Domain Events**,
* **Factories**,
* **Application Services**,
* **Integration / Infrastruktur-Schicht**,
* **Tests & KI-Automation-Hinweise**.

Die Struktur ist **klar, semantisch, maschinenlesbar** (für KI-Agenten oder Code-Assistenten wie Copilot, LangChain, oder ChatGPT-Coding-Agents).
Ich erstelle sie jetzt in Markdown – so, dass sie sofort als Wissensdokument oder Prompt-Basis verwendbar ist:

---

# 🧭 Domain-Driven Design — Best Practices (KI-Agent Optimized)

> **Zweck:**
> Diese Dokumentation definiert eine strukturierte, kontextfreie Referenz für Domain-Driven Design (DDD) Patterns, die **automatisiert von KI-Agenten interpretiert und angewendet** werden kann.
> Jede Sektion ist eigenständig nutzbar und beschreibt *Ziel, Prinzipien, Regeln, Code-Richtlinien und KI-Interaktionshinweise.*

---

## 🏗 1. Gesamtarchitektur

| Schicht                  | Zweck                           | Artefakte                              | Hauptverantwortung                   |
| ------------------------ | ------------------------------- | -------------------------------------- | ------------------------------------ |
| **Domain Layer**         | Fachlogik, Invarianten, Modelle | Entities, Value Objects, Domain Events | Kernlogik, unabhängig von Frameworks |
| **Application Layer**    | Orchestrierung von Use-Cases    | Application Services                   | Koordination, keine Business-Logik   |
| **Infrastructure Layer** | Technische Umsetzung            | Repositories, DB, APIs, Frameworks     | Persistenz, Messaging, I/O           |
| **Interface Layer**      | User- & System-Eingabe          | Controller, DTOs, Commands             | Eingabevalidierung, Mapping          |

---

## 🧩 2. Value Objects (VO)

### Ziel

Repräsentieren ein **unveränderliches, bedeutungsvolles Konzept** ohne eigene Identität (z. B. `Email`, `Money`, `Address`).

### Prinzipien

* **Immutability**: Keine Setter. Änderungen → neues Objekt.
* **Always valid**: Kein ungültiger Zustand erlaubt.
* **Equality by value**: `equals()` & `hashCode()` basieren auf Attributen.

### Best Practices

| Regel                                | Beschreibung                                                                        |
| ------------------------------------ | ----------------------------------------------------------------------------------- |
| **VOs validieren sich selbst**       | Validierung erfolgt im Konstruktor oder in einer Factory.                           |
| **Annotations an DTOs, nicht am VO** | Bean Validation (`@Email`, `@NotNull`) in DTOs; VO prüft Invarianten selbst.        |
| **Optional Integration**             | VO kann zusätzlich eigene `ConstraintValidator`s für DTO-Validierung bereitstellen. |

### Beispiel (Java)

```java
public record Email(String value) {
    public Email {
        if (value == null || !value.matches("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$"))
            throw new IllegalArgumentException("Invalid email: " + value);
    }
    public static Email of(String value) { return new Email(value); }
}
```

### KI-Agent Hinweise

* Erstelle VO-Klassen **immer unveränderlich**.
* Füge **automatische Validierung** im Konstruktor hinzu.
* Vermeide Bean Validation **direkt** im VO, außer explizit erlaubt.

---

## 🧱 3. Entities

### Ziel

Repräsentieren **fachliche Objekte mit Identität** (z. B. `User`, `Order`).

### Prinzipien

* **Identität = dauerhafte Referenz** (z. B. UUID).
* **Equals basiert auf ID**, nicht auf Werten.
* **Mutationen nur über Methoden, die Invarianten wahren.**

### Beispiel

```java
public class User {
    private final UUID id;
    private Email email;

    public User(UUID id, Email email) {
        this.id = Objects.requireNonNull(id);
        changeEmail(email);
    }

    public void changeEmail(Email newEmail) {
        if (newEmail.equals(this.email)) return;
        this.email = newEmail;
    }
}
```

### KI-Agent Hinweise

* Prüfe immer auf Invarianten bei Mutationen.
* Keine öffentlichen Setter generieren.
* Nur Factories oder Aggregate dürfen Entities direkt erzeugen.

---

## 🪢 4. Aggregates

### Ziel

Ein Aggregate bündelt Entities & Value Objects unter einer **Konsistenzgrenze**.

### Prinzipien

* Nur der **Aggregate Root** darf von außen referenziert werden.
* Transaktionen betreffen **immer genau ein Aggregate**.
* Invarianten gelten innerhalb des Aggregates.

### Beispiel

```java
public class Order {
    private final UUID id;
    private final List<OrderItem> items = new ArrayList<>();

    public void addItem(ProductId productId, int quantity) {
        if (quantity <= 0) throw new IllegalArgumentException("Quantity > 0 required");
        items.add(new OrderItem(productId, quantity));
    }
}
```

### KI-Agent Hinweise

* Generiere Aggregates mit klarer Root (eine Entity).
* VO nur intern sichtbar machen, wenn nicht Teil des Aggregats.
* Transaktionen auf Aggregatebene halten.

---

## 🧰 5. Repositories

### Ziel

Abstraktion über Persistenz, um Domain von DB zu trennen.

### Prinzipien

* Nur Aggregate Roots werden gespeichert.
* Interface im Domain Layer, Implementierung in Infrastructure.
* Methoden: `save`, `findById`, `deleteById`, etc.

### Beispiel

```java
public interface OrderRepository {
    Optional<Order> findById(UUID id);
    void save(Order order);
}
```

### KI-Agent Hinweise

* Erzeuge Repositories **als Interface** im Domain Layer.
* Implementierung darf Framework (z. B. Spring Data JPA) verwenden.
* Keine Domain-Logik im Repository!

---

## ⚙️ 6. Factories

### Ziel

Erstellen komplexer Aggregate oder Entities in gültigem Zustand.

### Prinzipien

* Verbergen Konstruktor-Logik.
* Erlauben alternative Erzeugungslogik.
* Können VO-Validierungen koordinieren.

### Beispiel

```java
public class OrderFactory {
    public Order createNew(CustomerId customerId, List<OrderItem> items) {
        return new Order(UUID.randomUUID(), customerId, items);
    }
}
```

### KI-Agent Hinweise

* Verwende Factories bei komplexer Initialisierung.
* Einfachere VOs → statische Factory-Methode (`of()`).

---

## 📢 7. Domain Events

### Ziel

Signalisieren **relevante Zustandsänderungen** in der Domäne.

### Prinzipien

* Ereignisse sind **immutable**.
* Werden von Aggregaten emittiert, von Handlern verarbeitet.
* Benennung: `Vergangenheitsform` (`OrderCreatedEvent`).

### Beispiel

```java
public record OrderCreatedEvent(UUID orderId, LocalDateTime createdAt) {}
```

### KI-Agent Hinweise

* Erzeuge Domain Events, wenn Aggregate-Zustand sich ändert.
* Event Handler im Application Layer platzieren.

---

## 🧭 8. Application Services

### Ziel

Orchestrieren Use-Cases, koordinieren Domänenobjekte.

### Prinzipien

* Keine Business-Logik (nur „Orchestration“).
* Arbeiten mit Repositories und Aggregates.
* Rückgabe: Ergebnis oder Domain Event.

### Beispiel

```java
@Service
public class OrderService {
    private final OrderRepository repo;

    public OrderService(OrderRepository repo) {
        this.repo = repo;
    }

    public void placeOrder(CreateOrderCommand cmd) {
        Order order = new OrderFactory().createNew(cmd.customerId(), cmd.items());
        repo.save(order);
    }
}
```

### KI-Agent Hinweise

* Generiere Application Services für jeden Use-Case.
* Verwende Commands als Eingabeobjekte.
* Keine Logik in Controllern.

---

## 🌐 9. Infrastructure Layer

### Ziel

Implementiert technische Details: Persistenz, Messaging, API-Zugriffe.

### Prinzipien

* Domäne bleibt unabhängig von Frameworks.
* Verwende Adapter-Muster.
* Implementierungen der Repository-Interfaces hier platzieren.

### Beispiel

```java
@Repository
public class JpaOrderRepository implements OrderRepository {
    private final SpringDataOrderRepository repo;
    // ...
}
```

---

## 🧪 10. Testing & KI-Automation

### Testing-Regeln

| Ebene                 | Ziel                               | Beispiel                         |
| --------------------- | ---------------------------------- | -------------------------------- |
| **Unit Tests**        | Invarianten von VO & Entity prüfen | Email.isValid(), Order.addItem() |
| **Integration Tests** | Repository und Infrastruktur       | JpaOrderRepository.save()        |
| **Acceptance Tests**  | Use-Cases & Services               | OrderService.placeOrder()        |

### KI-Agent Regeln

* Erzeuge Tests für jede Invariante automatisch.
* VO-Tests: Konstruktion & Exception-Handling.
* Entity-Tests: Konsistenz der Zustände.
* Service-Tests: Aggregat-Orchestrierung ohne Framework.

---

## 📘 11. Naming & Structure Conventions

```
src/
 ├─ domain/
 │   ├─ model/
 │   │   ├─ user/ (Entities, VOs, Aggregates)
 │   │   └─ order/
 │   └─ repository/
 ├─ application/
 │   ├─ service/
 │   └─ command/
 ├─ infrastructure/
 │   ├─ persistence/
 │   └─ configuration/
 └─ interface/
     └─ controller/
```

---

## 🤖 12. KI-Agent Integration Summary

| KI-Aufgabe               | Empfohlene Logik                                                     |
| ------------------------ | -------------------------------------------------------------------- |
| **Code-Generierung**     | Verwende Templates gemäß Abschnitt 2–8                               |
| **Validierungsaufgaben** | Prüfe Invarianten & Exceptions bei VO-Erstellung                     |
| **Review / Refactoring** | Erkenne Domänelogik in Application Layer → verschiebe in Domain      |
| **Prompt-Design**        | Verwende Struktur: *Schicht → Artefakt → Regel → Beispiel → Aufgabe* |

