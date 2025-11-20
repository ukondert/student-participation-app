# Testing Strategy

> **Quelle:** Domain-Driven Design Best Practices  
> **Kategorie:** Development Guidelines  
> **Ebene:** Quality Assurance

---

## 🎯 Ziel

Systematisches Testen von Domain-Logik, Use-Cases und Infrastructure.

---

## 📋 Test-Ebenen

| Ebene | Ziel | Beispiel | Framework |
|-------|------|----------|-----------|
| **Unit Tests** | Invarianten von VO & Entity prüfen | `Email.isValid()`, `Order.addItem()` | JUnit, Jest, xUnit |
| **Integration Tests** | Repository und Infrastruktur | `JpaOrderRepository.save()` | Testcontainers, H2 |
| **Acceptance Tests** | Use-Cases & Services | `OrderService.createOrder()` | Cucumber, ArchUnit |

---

## ✅ Best Practices

### Unit Tests (Domain Layer)

| Regel | Beschreibung |
|-------|--------------|
| **Test Invarianten** | Jede Geschäftsregel muss getestet werden. |
| **Keine Mocks** | Domain-Objekte direkt instanziieren (keine Framework-Abhängigkeit). |
| **AAA-Pattern** | Arrange, Act, Assert. |
| **Positive + Negative Cases** | Happy Path + Exception-Fälle. |

**Beispiel:**

```java
class EmailTest {
    @Test
    void shouldCreateValidEmail() {
        // Arrange & Act
        Email email = Email.of("test@example.com");
        
        // Assert
        assertNotNull(email);
        assertEquals("test@example.com", email.value());
    }

    @Test
    void shouldThrowExceptionForInvalidEmail() {
        // Act & Assert
        assertThrows(IllegalArgumentException.class, 
            () -> Email.of("invalid-email"));
    }
}
```

### Integration Tests (Infrastructure Layer)

| Regel | Beschreibung |
|-------|--------------|
| **Testcontainers** | Verwende echte DB (PostgreSQL, MongoDB) via Docker. |
| **Transaktional** | Tests in Transaktionen (Rollback nach Test). |
| **Repository-Contract** | Teste Interface-Vertrag, nicht Implementierung. |

**Beispiel:**

```java
@DataJpaTest
@Testcontainers
class JpaOrderRepositoryTest {
    @Container
    static PostgreSQLContainer<?> postgres = new PostgreSQLContainer<>("postgres:15");

    @Autowired
    private JpaOrderRepository repository;

    @Test
    void shouldSaveAndFindOrder() {
        // Arrange
        Order order = new Order(UUID.randomUUID(), new CustomerId(...));
        
        // Act
        repository.save(order);
        Optional<Order> found = repository.findById(order.getId());
        
        // Assert
        assertTrue(found.isPresent());
        assertEquals(order.getId(), found.get().getId());
    }
}
```

### Acceptance Tests (Application Layer)

| Regel | Beschreibung |
|-------|--------------|
| **Use-Case-basiert** | Teste einen vollständigen fachlichen Ablauf. |
| **Mocking von Infrastructure** | Mock Repositories, External Services. |
| **Command → Assertion** | Eingabe (Command) → Erwartetes Ergebnis. |

**Beispiel:**

```java
class OrderServiceTest {
    private OrderRepository mockRepo;
    private OrderFactory factory;
    private OrderService service;

    @BeforeEach
    void setup() {
        mockRepo = mock(OrderRepository.class);
        factory = new OrderFactory(mockProductRepo);
        service = new OrderService(mockRepo, factory, eventPublisher);
    }

    @Test
    void shouldCreateOrder() {
        // Arrange
        CreateOrderCommand cmd = new CreateOrderCommand(...);
        
        // Act
        UUID orderId = service.createOrder(cmd);
        
        // Assert
        assertNotNull(orderId);
        verify(mockRepo, times(1)).save(any(Order.class));
    }
}
```

---

## 🤖 KI-Agent Regeln

* Erzeuge Tests für jede Invariante automatisch.
* VO-Tests: Konstruktion & Exception-Handling.
* Entity-Tests: Konsistenz der Zustände.
* Service-Tests: Aggregat-Orchestrierung ohne Framework.
* Teste immer Happy Path + mindestens 2 Fehlerfälle.

---

## 📌 Checkliste

### Value Object Tests
- [ ] Gültige Erstellung (`of()` mit korrekten Daten)
- [ ] Ungültige Erstellung (Exception bei falschen Daten)
- [ ] Immutability (keine Setter, Copy-on-Write bei Änderung)
- [ ] Equals by value

### Entity Tests
- [ ] Erstellung mit gültiger ID
- [ ] Mutationen über benannte Methoden
- [ ] Invarianten-Prüfung bei Zustandsänderung
- [ ] Equals basiert auf ID

### Aggregate Tests
- [ ] Root-Methoden prüfen Invarianten
- [ ] Interne Entities nur über Root modifizierbar
- [ ] Domain Events werden emittiert
- [ ] Transaktions-Konsistenz

### Repository Tests
- [ ] Save + FindById (Round-Trip)
- [ ] Update (optimistic locking, falls vorhanden)
- [ ] Delete
- [ ] Queries (fachliche Abfragen)

### Application Service Tests
- [ ] Use-Case happy path
- [ ] Exception-Handling (Domain-Fehler, NotFound)
- [ ] Events werden publiziert
- [ ] Transaktions-Rollback bei Fehler

---

## ⚠️ Anti-Patterns vermeiden

❌ **Framework in Unit Tests**
```java
// FALSCH
@SpringBootTest  // Zu langsam, unnötiger Overhead
class EmailTest {
    @Autowired
    EmailValidator validator;  // Domain braucht kein Spring!
}
```

✅ **Pure Unit Test**
```java
// RICHTIG
class EmailTest {
    @Test
    void shouldValidate() {
        Email email = Email.of("test@example.com");
        assertNotNull(email);
    }
}
```

❌ **Testen von Implementierungs-Details**
```java
// FALSCH
@Test
void shouldCallSaveMethod() {
    service.createOrder(...);
    verify(repo).save(any());  // Implementierungsdetail!
}
```

✅ **Testen von Verhalten**
```java
// RICHTIG
@Test
void shouldCreateOrderSuccessfully() {
    UUID id = service.createOrder(...);
    assertNotNull(id);
    // Optional: verify event published
}
```

---

## 🔗 Referenzen

- Test Pyramid: Unit (viele) > Integration (einige) > E2E (wenige)
- Testcontainers: https://testcontainers.com
- ArchUnit: Architektur-Tests (Layer-Abhängigkeiten prüfen)
