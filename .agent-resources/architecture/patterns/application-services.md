# Application Services Pattern

> **Quelle:** Domain-Driven Design Best Practices  
> **Kategorie:** Application Layer Pattern  
> **Ebene:** Application Layer

---

## 🎯 Ziel

Orchestrieren Use-Cases, koordinieren Domänenobjekte.

---

## 📋 Prinzipien

* Keine Business-Logik (nur „Orchestration").
* Arbeiten mit Repositories und Aggregates.
* Rückgabe: Ergebnis oder Domain Event.

---

## ✅ Best Practices

| Regel | Beschreibung |
|-------|--------------|
| **Nur Koordination** | Keine Geschäftslogik, diese gehört ins Aggregate. |
| **Use-Case pro Service-Methode** | Jede Methode repräsentiert einen fachlichen Use-Case. |
| **Transaktions-Management** | Service-Methode = Transaktions-Grenze. |
| **DTO/Command als Input** | Eingabe über strukturierte Commands/DTOs. |

---

## 💻 Beispiel (Java)

### Command (Input)

```java
public record CreateOrderCommand(
    UUID customerId,
    List<OrderItemRequest> items
) {}

public record OrderItemRequest(
    UUID productId,
    int quantity
) {}
```

### Application Service

```java
@Service
@Transactional
public class OrderService {
    private final OrderRepository orderRepo;
    private final OrderFactory orderFactory;
    private final EventPublisher eventPublisher;

    public OrderService(
        OrderRepository orderRepo,
        OrderFactory orderFactory,
        EventPublisher eventPublisher
    ) {
        this.orderRepo = orderRepo;
        this.orderFactory = orderFactory;
        this.eventPublisher = eventPublisher;
    }

    public UUID createOrder(CreateOrderCommand cmd) {
        // 1. Factory erstellt Aggregate
        Order order = orderFactory.createNew(
            new CustomerId(cmd.customerId()),
            cmd.items()
        );

        // 2. Repository speichert
        orderRepo.save(order);

        // 3. Events publizieren
        order.pullDomainEvents().forEach(eventPublisher::publish);

        // 4. ID zurückgeben
        return order.getId();
    }

    public void submitOrder(UUID orderId) {
        // 1. Aggregate laden
        Order order = orderRepo.findById(orderId)
            .orElseThrow(() -> new OrderNotFoundException(orderId));

        // 2. Business-Logik aufrufen (im Aggregate!)
        order.submit();

        // 3. Speichern
        orderRepo.save(order);

        // 4. Events publizieren
        order.pullDomainEvents().forEach(eventPublisher::publish);
    }
}
```

---

## 🤖 KI-Agent Hinweise

* Generiere Application Services für jeden Use-Case.
* Verwende Commands als Eingabeobjekte.
* Keine Logik in Controllern.
* Service-Methoden sind transaktional (`@Transactional`).
* Events nach erfolgreicher Persistierung publizieren.

---

## 📌 Checkliste

- [ ] Service im `application/service` Package
- [ ] Jede Methode = ein Use-Case
- [ ] Input über Command/DTO
- [ ] Keine Geschäftslogik im Service
- [ ] Transaktions-Management (z.B. `@Transactional`)
- [ ] Domain Events nach Persistierung publizieren
- [ ] Exception Handling für Domain-Fehler
- [ ] Return-Typ: ID, DTO oder void

---

## ⚠️ Anti-Patterns vermeiden

❌ **Business-Logik im Service**
```java
// FALSCH
@Service
class OrderService {
    void submitOrder(UUID orderId) {
        Order order = repo.findById(orderId);
        if (order.getItems().isEmpty())  // Business-Regel!
            throw new Exception();
        order.setStatus(SUBMITTED);  // Setter statt Methode!
        repo.save(order);
    }
}
```

✅ **Logik im Aggregate**
```java
// RICHTIG
@Service
class OrderService {
    void submitOrder(UUID orderId) {
        Order order = repo.findById(orderId);
        order.submit();  // Aggregate prüft Regeln!
        repo.save(order);
    }
}
```

❌ **Mehrere Use-Cases in einer Methode**
```java
// FALSCH
void processOrder(UUID orderId, boolean submit, boolean cancel) {
    if (submit) { ... }
    if (cancel) { ... }
}
```

✅ **Ein Use-Case pro Methode**
```java
// RICHTIG
void submitOrder(UUID orderId) { ... }
void cancelOrder(UUID orderId) { ... }
```

❌ **Transaktions-Grenzen über mehrere Aggregates**
```java
// FALSCH
@Transactional
void processOrder(UUID orderId, UUID customerId) {
    Order order = orderRepo.findById(orderId);
    order.submit();
    orderRepo.save(order);
    
    Customer customer = customerRepo.findById(customerId);
    customer.addPoints(10);  // Anderes Aggregate!
    customerRepo.save(customer);
}
```

✅ **Ein Aggregate pro Transaktion**
```java
// RICHTIG
@Transactional
void submitOrder(UUID orderId) {
    Order order = orderRepo.findById(orderId);
    order.submit();
    orderRepo.save(order);
    // Customer-Update via Domain Event (eventual consistency)
}
```

---

## 🔗 Referenzen

- Related Patterns: `aggregate-design.md`, `domain-events.md`, `repository-pattern.md`
- Layering: `hexagonal-architecture.md`
