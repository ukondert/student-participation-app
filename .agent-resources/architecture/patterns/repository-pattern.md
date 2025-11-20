# Repository Pattern

> **Quelle:** Domain-Driven Design Best Practices  
> **Kategorie:** Tactical Design Pattern  
> **Ebene:** Domain Layer (Interface) + Infrastructure Layer (Implementation)

---

## 🎯 Ziel

Abstraktion über Persistenz, um Domain von DB zu trennen.

---

## 📋 Prinzipien

* Nur Aggregate Roots werden gespeichert.
* Interface im Domain Layer, Implementierung in Infrastructure.
* Methoden: `save`, `findById`, `deleteById`, etc.

---

## ✅ Best Practices

| Regel | Beschreibung |
|-------|--------------|
| **Interface in Domain** | Repository-Interface gehört zur Domain. |
| **Implementierung in Infrastructure** | Konkrete DB-Technologie (JPA, MongoDB, etc.) in Infrastructure. |
| **Nur Aggregate Roots** | Repositories nur für Aggregate Roots, nicht für interne Entities. |
| **Domain-Sprache** | Methoden-Namen spiegeln Fachlichkeit wider (z.B. `findActiveOrders`). |

---

## 💻 Beispiel (Java)

### Domain Layer (Interface)

```java
package com.example.domain.repository;

import com.example.domain.model.Order;
import java.util.Optional;
import java.util.UUID;

public interface OrderRepository {
    Optional<Order> findById(UUID id);
    void save(Order order);
    void delete(Order order);
    List<Order> findActiveOrders();
}
```

### Infrastructure Layer (Implementation)

```java
package com.example.infrastructure.persistence;

import com.example.domain.repository.OrderRepository;
import org.springframework.stereotype.Repository;

@Repository
public class JpaOrderRepository implements OrderRepository {
    private final SpringDataOrderRepository springRepo;

    public JpaOrderRepository(SpringDataOrderRepository springRepo) {
        this.springRepo = springRepo;
    }

    @Override
    public Optional<Order> findById(UUID id) {
        return springRepo.findById(id).map(this::toDomain);
    }

    @Override
    public void save(Order order) {
        springRepo.save(toEntity(order));
    }

    // Mapping-Methoden: toDomain(), toEntity()
}
```

---

## 🤖 KI-Agent Hinweise

* Erzeuge Repositories **als Interface** im Domain Layer.
* Implementierung darf Framework (z. B. Spring Data JPA) verwenden.
* Keine Domain-Logik im Repository!
* Mapping zwischen Domain-Modell und Persistenz-Modell in Infrastructure.

---

## 📌 Checkliste

- [ ] Interface im `domain/repository` Package
- [ ] Implementation im `infrastructure/persistence` Package
- [ ] Nur Aggregate Roots haben Repositories
- [ ] Methoden-Namen verwenden Ubiquitous Language
- [ ] Keine SQL/Query-Details im Interface
- [ ] Mapping Domain ↔ Persistence in Implementation
- [ ] Keine Geschäftslogik im Repository

---

## ⚠️ Anti-Patterns vermeiden

❌ **Repository für interne Entities**
```java
// FALSCH
interface OrderItemRepository { }  // OrderItem ist keine Aggregate Root!
```

✅ **Nur für Aggregate Roots**
```java
// RICHTIG
interface OrderRepository { }  // Order ist Aggregate Root
```

❌ **Domain-Logik im Repository**
```java
// FALSCH
class OrderRepository {
    void save(Order order) {
        order.calculateTotal();  // Business-Logik!
        db.save(order);
    }
}
```

✅ **Nur Persistenz im Repository**
```java
// RICHTIG
class OrderRepository {
    void save(Order order) {
        db.save(toEntity(order));  // Nur Persistenz
    }
}
```

❌ **Technische Details im Interface**
```java
// FALSCH
interface OrderRepository {
    @Query("SELECT o FROM Order o WHERE o.status = 'ACTIVE'")
    List<Order> findActive();
}
```

✅ **Fachliche Methoden im Interface**
```java
// RICHTIG
interface OrderRepository {
    List<Order> findActiveOrders();  // Implementierung entscheidet über Query
}
```

---

## 🔗 Referenzen

- Related Patterns: `aggregate-design.md`
- Infrastructure: `docs/architecture/domain-categorization.md` (Generic Subdomains)
