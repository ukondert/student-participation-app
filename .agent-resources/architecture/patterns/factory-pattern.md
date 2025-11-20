# Factory Pattern

> **Quelle:** Domain-Driven Design Best Practices  
> **Kategorie:** Tactical Design Pattern  
> **Ebene:** Domain Layer

---

## 🎯 Ziel

Erstellen komplexer Aggregate oder Entities in gültigem Zustand.

---

## 📋 Prinzipien

* Verbergen Konstruktor-Logik.
* Erlauben alternative Erzeugungslogik.
* Können VO-Validierungen koordinieren.

---

## ✅ Best Practices

| Regel | Beschreibung |
|-------|--------------|
| **Komplexe Initialisierung** | Factory bei mehreren Schritten zur Objekterzeugung. |
| **Alternative Erzeugung** | Verschiedene Factory-Methoden für unterschiedliche Szenarien. |
| **Invarianten sicherstellen** | Factory garantiert gültigen Zustand. |
| **Einfache VOs → Static Method** | Für simple Value Objects: `Email.of()` statt separater Factory. |

---

## 💻 Beispiel (Java)

### Factory für Aggregate

```java
public class OrderFactory {
    private final ProductRepository productRepo;

    public OrderFactory(ProductRepository productRepo) {
        this.productRepo = productRepo;
    }

    public Order createNew(CustomerId customerId, List<OrderItemRequest> itemRequests) {
        Order order = new Order(UUID.randomUUID(), customerId);
        
        for (OrderItemRequest request : itemRequests) {
            Product product = productRepo.findById(request.productId())
                .orElseThrow(() -> new ProductNotFoundException(request.productId()));
            
            order.addItem(product.getId(), request.quantity());
        }
        
        return order;
    }

    public Order fromPersistence(UUID id, CustomerId customerId, List<OrderItem> items) {
        // Rekonstitution aus Datenbank ohne Validierung
        return new Order(id, customerId, items);
    }
}
```

### Static Factory für Value Objects

```java
public record Email(String value) {
    public Email {
        validate(value);
    }

    public static Email of(String value) {
        return new Email(value);
    }

    public static Email fromUserInput(String input) {
        return new Email(input.trim().toLowerCase());
    }

    private static void validate(String value) {
        if (value == null || !value.matches("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$"))
            throw new IllegalArgumentException("Invalid email");
    }
}
```

---

## 🤖 KI-Agent Hinweise

* Verwende Factories bei komplexer Initialisierung.
* Einfachere VOs → statische Factory-Methode (`of()`).
* Factory kann externe Services (Repositories) nutzen zur Validierung.
* Unterscheide: `create()` (neue Objekte) vs. `fromPersistence()` (Rekonstitution).

---

## 📌 Checkliste

- [ ] Factory-Klasse im Domain Layer (bei komplexen Aggregates)
- [ ] Static Factory Methods für einfache VOs
- [ ] Konstruktor `private` oder `protected` (Factory erzwingt Nutzung)
- [ ] Factory validiert alle Invarianten
- [ ] Unterschiedliche Methoden für verschiedene Szenarien
- [ ] `fromPersistence()` für Rekonstitution ohne Validierung

---

## ⚠️ Anti-Patterns vermeiden

❌ **Öffentlicher Konstruktor bei komplexer Logik**
```java
// FALSCH
Order order = new Order(id, customerId);  // Keine Items, ungültiger Zustand!
```

✅ **Factory erzwingt gültigen Zustand**
```java
// RICHTIG
Order order = orderFactory.createNew(customerId, itemRequests);
```

❌ **Factory mit Business-Logik**
```java
// FALSCH
class OrderFactory {
    Order create(...) {
        Order order = ...;
        order.calculateTotal();  // Business-Logik gehört ins Aggregate!
        return order;
    }
}
```

✅ **Factory nur zur Erzeugung**
```java
// RICHTIG
class OrderFactory {
    Order create(...) {
        return new Order(...);  // Aggregate selbst berechnet Total
    }
}
```

---

## 🔗 Referenzen

- Related Patterns: `aggregate-design.md`, `value-object-design.md`
