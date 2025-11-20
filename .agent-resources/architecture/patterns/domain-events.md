# Domain Events Pattern

> **Quelle:** Domain-Driven Design Best Practices  
> **Kategorie:** Tactical Design Pattern  
> **Ebene:** Domain Layer

---

## 🎯 Ziel

Signalisieren **relevante Zustandsänderungen** in der Domäne.

---

## 📋 Prinzipien

* Ereignisse sind **immutable**.
* Werden von Aggregaten emittiert, von Handlern verarbeitet.
* Benennung: **Vergangenheitsform** (`OrderCreatedEvent`, `UserEmailChangedEvent`).

---

## ✅ Best Practices

| Regel | Beschreibung |
|-------|--------------|
| **Vergangenheitsform** | Event-Namen beschreiben, was passiert **ist**. |
| **Immutable** | Events dürfen nach Erstellung nicht geändert werden. |
| **Fachliche Sprache** | Ereignisse nutzen Ubiquitous Language. |
| **Minimal Payload** | Nur relevante Daten im Event (IDs, Zeitstempel, Schlüsselattribute). |

---

## 💻 Beispiel (Java)

### Event-Definition

```java
public record OrderCreatedEvent(
    UUID orderId,
    CustomerId customerId,
    LocalDateTime createdAt,
    int itemCount
) {
    public OrderCreatedEvent {
        Objects.requireNonNull(orderId);
        Objects.requireNonNull(customerId);
        Objects.requireNonNull(createdAt);
    }
}
```

### Event-Emission im Aggregate

```java
public class Order {
    private final List<DomainEvent> domainEvents = new ArrayList<>();

    public void submit() {
        if (items.isEmpty())
            throw new IllegalStateException("Order must have items");
        
        this.status = OrderStatus.SUBMITTED;
        
        // Event emittieren
        domainEvents.add(new OrderSubmittedEvent(
            this.id,
            this.customerId,
            LocalDateTime.now(),
            this.items.size()
        ));
    }

    public List<DomainEvent> pullDomainEvents() {
        List<DomainEvent> events = new ArrayList<>(domainEvents);
        domainEvents.clear();
        return events;
    }
}
```

### Event-Handler (Application Layer)

```java
@Component
public class OrderEventHandler {
    private final NotificationService notificationService;

    @EventListener
    public void handle(OrderSubmittedEvent event) {
        notificationService.notifyCustomer(
            event.customerId(),
            "Your order " + event.orderId() + " has been submitted"
        );
    }
}
```

---

## 🤖 KI-Agent Hinweise

* Erzeuge Domain Events, wenn Aggregate-Zustand sich ändert.
* Event Handler im Application Layer platzieren.
* Events sind immutable (Java Records, C# Records, TypeScript readonly).
* Vermeide zirkuläre Abhängigkeiten (Events nur in eine Richtung).

---

## 📌 Checkliste

- [ ] Event-Name in Vergangenheitsform (`*Event`)
- [ ] Event ist immutable (alle Felder `final`/`readonly`)
- [ ] Event enthält nur notwendige Daten (IDs, Zeitstempel)
- [ ] Aggregate sammelt Events intern (`pullDomainEvents()`)
- [ ] Events werden nach Persistierung publiziert
- [ ] Event-Handler in Application/Infrastructure Layer
- [ ] Keine Geschäftslogik in Event-Handlern (nur Orchestrierung)

---

## ⚠️ Anti-Patterns vermeiden

❌ **Event mit Setter**
```java
// FALSCH
class OrderCreatedEvent {
    private UUID orderId;
    public void setOrderId(UUID id) { this.orderId = id; }
}
```

✅ **Event ist immutable**
```java
// RICHTIG
record OrderCreatedEvent(UUID orderId, LocalDateTime createdAt) {}
```

❌ **Zu viele Daten im Event**
```java
// FALSCH
record OrderCreatedEvent(
    UUID orderId,
    Order order,  // Ganzes Aggregat!
    Customer customer,
    List<Product> products
) {}
```

✅ **Nur relevante Daten**
```java
// RICHTIG
record OrderCreatedEvent(
    UUID orderId,
    CustomerId customerId,  // Nur ID
    LocalDateTime createdAt,
    int itemCount
) {}
```

❌ **Business-Logik im Event-Handler**
```java
// FALSCH
@EventListener
void handle(OrderSubmittedEvent event) {
    Order order = repo.findById(event.orderId());
    order.calculateTotal();  // Business-Logik!
    repo.save(order);
}
```

✅ **Nur Orchestrierung im Handler**
```java
// RICHTIG
@EventListener
void handle(OrderSubmittedEvent event) {
    notificationService.notify(event.customerId());
    analyticsService.track(event);
}
```

---

## 🔗 Referenzen

- Related Patterns: `aggregate-design.md`, `application-services.md`
- Event-Driven Architecture: Eventual Consistency zwischen Aggregates
- Projekt-Beispiele: `docs/architecture/agregates-entites-value_obj.md`
