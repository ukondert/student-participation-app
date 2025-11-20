# Aggregate Design Pattern

> **Quelle:** Domain-Driven Design Best Practices  
> **Kategorie:** Tactical Design Pattern  
> **Ebene:** Domain Layer

---

## 🎯 Ziel

Ein Aggregate bündelt Entities & Value Objects unter einer **Konsistenzgrenze**.

---

## 📋 Prinzipien

* Nur der **Aggregate Root** darf von außen referenziert werden.
* Transaktionen betreffen **immer genau ein Aggregate**.
* Invarianten gelten innerhalb des Aggregates.

---

## ✅ Best Practices

| Regel | Beschreibung |
|-------|--------------|
| **Root ist Einstiegspunkt** | Alle Mutationen gehen über den Aggregate Root. |
| **Transaktions-Grenze** | Ein Aggregate = eine Transaktion. |
| **Keine direkten Referenzen** | Andere Aggregates nur über ID referenzieren. |
| **Invarianten schützen** | Root prüft alle Geschäftsregeln. |

---

## 💻 Beispiel (Java)

```java
public class Order {
    private final UUID id;
    private final List<OrderItem> items = new ArrayList<>();
    private OrderStatus status;

    public Order(UUID id) {
        this.id = Objects.requireNonNull(id);
        this.status = OrderStatus.DRAFT;
    }

    public void addItem(ProductId productId, int quantity) {
        if (quantity <= 0) 
            throw new IllegalArgumentException("Quantity > 0 required");
        if (status != OrderStatus.DRAFT)
            throw new IllegalStateException("Cannot modify submitted order");
        
        items.add(new OrderItem(productId, quantity));
    }

    public void submit() {
        if (items.isEmpty())
            throw new IllegalStateException("Order must have items");
        
        this.status = OrderStatus.SUBMITTED;
        // Domain Event: OrderSubmitted
    }
}
```

---

## 🤖 KI-Agent Hinweise

* Generiere Aggregates mit klarer Root (eine Entity).
* VO nur intern sichtbar machen, wenn nicht Teil des Aggregats.
* Transaktionen auf Aggregatebene halten.
* Keine direkten Objektreferenzen zwischen Aggregates (nur IDs).

---

## 📌 Checkliste

- [ ] Aggregate hat genau einen Root (Entity mit ID)
- [ ] Alle Mutationen gehen über Root-Methoden
- [ ] Keine direkten Referenzen zu anderen Aggregates (nur IDs)
- [ ] Transaktionsgrenze = Aggregate-Grenze
- [ ] Invarianten werden im Root geprüft
- [ ] Domain Events bei kritischen Zustandsänderungen
- [ ] Interne Entities sind von außen nicht direkt zugänglich

---

## ⚠️ Anti-Patterns vermeiden

❌ **Direkte Aggregat-Referenzen**
```java
// FALSCH
class Order {
    private Customer customer;  // Andere Aggregate-Root!
}
```

✅ **Nur ID speichern**
```java
// RICHTIG
class Order {
    private CustomerId customerId;  // Nur ID, keine direkte Referenz
}
```

❌ **Mehrere Transaktionen**
```java
// FALSCH
orderRepo.save(order);
customerRepo.save(customer);  // Zwei Aggregates, zwei Transaktionen!
```

✅ **Eine Transaktion pro Aggregate**
```java
// RICHTIG
orderRepo.save(order);  // Nur ein Aggregate
// Customer via Domain Event aktualisieren (eventual consistency)
```

❌ **Zugriff auf interne Entities**
```java
// FALSCH
order.getItems().get(0).changeQuantity(5);  // Bypass Root!
```

✅ **Mutation über Root**
```java
// RICHTIG
order.updateItemQuantity(itemId, 5);  // Root prüft Invarianten
```

---

## 🔗 Referenzen

- Related Patterns: `entity-design.md`, `repository-pattern.md`, `domain-events.md`
- Bounded Contexts: `docs/architecture/bounded-contexts.md`
