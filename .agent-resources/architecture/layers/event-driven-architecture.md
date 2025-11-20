# Event-Driven Architecture (EDA)

> **Quelle:** Enterprise Integration Patterns  
> **Kategorie:** Architectural Pattern  
> **Ebene:** Gesamtarchitektur

---

## 🎯 Ziel

Unterstützt lose gekoppelte Komponenten für hohe Flexibilität und Reaktionsfähigkeit. Gewährleistet hohe Reaktionsfähigkeit und Skalierbarkeit für Echtzeit-Datenverarbeitung.

---

## 📋 Architektur-Komponenten

| Komponente | Zweck | Artefakte | Hauptverantwortung |
|---------|-------|-----------|-------------------|
| **Event Producer** | Ereignisse erzeugen | Events, Commands | Statusänderungen publizieren |
| **Event Broker** | Ereignisse verteilen | Message Queue, Topic | Entkoppelte Verteilung |
| **Event Consumer** | Ereignisse verarbeiten | Event Handlers, Processors | Reaktion auf Ereignisse |
| **Event Store** | Ereignisse speichern | Event Log, Event Database | Audit Trail, Event Sourcing |
| **Event Processor** | Ereignisse transformieren | Stream Processing | Filterung, Aggregation, Enrichment |

---

## 🏗️ Architektur-Diagramm

```
┌─────────────────────────────────────────────────┐
│            Event Producers                      │
│  (Services, IoT Devices, User Actions)          │
└──────┬──────────┬──────────┬──────────┬─────────┘
       │          │          │          │
       │ publish  │ publish  │ publish  │ publish
       ▼          ▼          ▼          ▼
┌─────────────────────────────────────────────────┐
│         Event Broker / Message Bus              │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐        │
│  │ Topic A  │ │ Topic B  │ │ Topic C  │        │
│  └──────────┘ └──────────┘ └──────────┘        │
└──────┬───────────┬──────────┬──────────┬────────┘
       │           │          │          │
       │ subscribe │subscribe │subscribe │subscribe
       ▼           ▼          ▼          ▼
┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐
│Consumer 1│ │Consumer 2│ │Consumer 3│ │Consumer 4│
│(Email)   │ │(Logging) │ │(Analytics)│ │(Billing) │
└──────────┘ └──────────┘ └──────────┘ └──────────┘
       │                        │
       ▼                        ▼
┌─────────────┐          ┌─────────────┐
│ Event Store │          │Stream Proc. │
│ (Event Log) │          │(Aggregation)│
└─────────────┘          └─────────────┘
```

**Regel:** Producer und Consumer kennen sich **nicht** - Kommunikation nur über Events!

---

## ✅ Best Practices

| Regel | Beschreibung |
|-------|--------------|
| **Event Immutability** | Events sind unveränderlich - einmal publiziert, nie geändert. |
| **Event Schema** | Klare Schema-Definition (Avro, Protobuf, JSON Schema). |
| **Idempotenz** | Consumer müssen idempotent sein (doppelte Events verarbeiten können). |
| **Event Ordering** | Partitionierung für Reihenfolge kritischer Events. |
| **Dead Letter Queue** | Fehlerhafte Events in DLQ verschieben, nicht verlieren. |
| **Event Versioning** | Events versionieren für Schema Evolution. |
| **Backward Compatibility** | Neue Event-Versionen müssen abwärtskompatibel sein. |

---

## 💻 Beispiel: Event-Struktur

```
event-driven-system/
 ├─ events/
 │   ├─ schemas/
 │   │   ├─ user-created.v1.json
 │   │   ├─ order-placed.v1.json
 │   │   └─ payment-completed.v1.json
 │   └─ definitions/
 │       ├─ UserCreatedEvent.java
 │       ├─ OrderPlacedEvent.java
 │       └─ PaymentCompletedEvent.java
 │
 ├─ producers/
 │   ├─ user-service/
 │   │   └─ src/
 │   │       └─ events/
 │   │           └─ UserEventPublisher.java
 │   └─ order-service/
 │       └─ src/
 │           └─ events/
 │               └─ OrderEventPublisher.java
 │
 ├─ consumers/
 │   ├─ email-service/
 │   │   └─ src/
 │   │       └─ listeners/
 │   │           ├─ UserCreatedListener.java
 │   │           └─ OrderPlacedListener.java
 │   ├─ analytics-service/
 │   │   └─ src/
 │   │       └─ processors/
 │   │           └─ OrderEventProcessor.java
 │   └─ notification-service/
 │       └─ src/
 │           └─ handlers/
 │               └─ PaymentEventHandler.java
 │
 ├─ stream-processing/
 │   └─ src/
 │       ├─ aggregators/
 │       │   └─ OrderStatisticsAggregator.java
 │       └─ filters/
 │           └─ HighValueOrderFilter.java
 │
 └─ infrastructure/
     ├─ kafka/
     │   ├─ topics/
     │   └─ connectors/
     └─ event-store/
         └─ EventStoreRepository.java
```

---

## 🤖 KI-Agent Hinweise

* **Events benennen** in Vergangenheitsform (`UserCreated`, nicht `CreateUser`).
* **Commands vs. Events**: Commands sind Imperative (`CreateUser`), Events sind Fakten (`UserCreated`).
* Verwende **Event Sourcing** für Audit Trail und Zeitreisen.
* Implementiere **Saga Pattern** für verteilte Transaktionen.
* Nutze **CQRS** (Command Query Responsibility Segregation) in Kombination.
* **Event Payload**: Genug Kontext, aber nicht zu viel (Balance).
* Implementiere **Correlation ID** für Event-Tracking über Flows.

---

## 📌 Checkliste

- [ ] Event-Schema definiert und versioniert
- [ ] Event Broker konfiguriert (Kafka, RabbitMQ, etc.)
- [ ] Topics/Queues strukturiert nach Bounded Contexts
- [ ] Producer publiziert Events nach Domain-Operationen
- [ ] Consumer sind idempotent implementiert
- [ ] Dead Letter Queue für fehlerhafte Events
- [ ] Event Store für Event Sourcing (optional)
- [ ] Monitoring für Event-Latenz und Consumer-Lag
- [ ] Schema Registry implementiert (Confluent, etc.)
- [ ] Event Versioning Strategie definiert

---

## ⚠️ Anti-Patterns vermeiden

❌ **Event als RPC-Ersatz (Request-Response)**
```java
// FALSCH - Event für synchrone Antwort missbrauchen
public User createUser(CreateUserCommand cmd) {
    eventBus.publish(new CreateUserEvent(cmd));
    // Warten auf Antwort... ❌ Blocking!
    return waitForUserCreatedEvent();
}
```

✅ **Echte asynchrone Event-Verarbeitung**
```java
// RICHTIG - Fire and Forget
public void createUser(CreateUserCommand cmd) {
    User user = userRepository.save(new User(cmd));
    eventBus.publish(new UserCreated(user.getId(), user.getEmail()));
    // Kein Warten - andere Services reagieren asynchron
}
```

❌ **Event-Payload zu groß (Fat Events)**
```java
// FALSCH - Komplettes Objekt im Event
public class OrderPlaced {
    private Order order;  // Komplettes Order-Objekt mit allen Details!
    private User user;    // Kompletter User mit Passwort-Hash!
    private List<Product> products;  // Alle Produkte mit Bildern!
}
```

✅ **Event mit essentiellen Daten (Thin Events)**
```java
// RICHTIG - Nur IDs und wichtige Felder
public class OrderPlaced {
    private UUID orderId;
    private UUID userId;
    private BigDecimal totalAmount;
    private Instant placedAt;
    // Consumer können Details über API nachladen wenn nötig
}
```

❌ **Consumer direkt koppeln**
```java
// FALSCH - Consumer kennt Producer
public class EmailService {
    public void sendEmail(UserCreatedEvent event) {
        User user = userService.getUser(event.getUserId());  // Direkte Kopplung!
    }
}
```

✅ **Consumer völlig entkoppelt**
```java
// RICHTIG - Consumer nutzt nur Event-Daten
@EventListener
public class EmailService {
    public void onUserCreated(UserCreated event) {
        emailSender.send(event.getEmail(), "Welcome!");
        // Kein Call zurück zum Producer
    }
}
```

❌ **Keine Fehlerbehandlung**
```java
// FALSCH - Exception killt Consumer
@EventListener
public void handle(OrderPlaced event) {
    process(event);  // Throws Exception -> Consumer stirbt
}
```

✅ **Resiliente Fehlerbehandlung**
```java
// RICHTIG - Retry + Dead Letter Queue
@EventListener
@Retryable(maxAttempts = 3, backoff = @Backoff(delay = 1000))
public void handle(OrderPlaced event) {
    try {
        process(event);
    } catch (RetryExhaustedException e) {
        deadLetterQueue.send(event);  // Nach 3 Versuchen -> DLQ
        log.error("Failed to process event", e);
    }
}
```

---

## 🔧 Technologie-Stack Beispiele

### Message Brokers
- **Apache Kafka** (High-throughput, Event Streaming)
- **RabbitMQ** (Flexible Routing, AMQP)
- **AWS EventBridge** (Cloud-native, Serverless)
- **Azure Service Bus** (Enterprise Messaging)
- **Google Cloud Pub/Sub** (Global Scale)

### Event Processing
- **Apache Flink** (Stream Processing)
- **Apache Storm** (Real-time Computation)
- **Kafka Streams** (Kafka-native Processing)
- **Akka Streams** (Reactive Streams)

### Event Sourcing
- **Axon Framework** (Java CQRS/ES)
- **EventStore** (Purpose-built Event Store)
- **Marten** (.NET Event Store)

### Schema Management
- **Confluent Schema Registry** (Kafka)
- **AWS Glue Schema Registry**
- **Apicurio Registry**

---

## 📊 Event-Muster

### Event Notification
```java
// Einfache Benachrichtigung - minimale Daten
public class UserEmailChanged {
    private UUID userId;
    private String newEmail;
    private Instant changedAt;
}
```

### Event-Carried State Transfer
```java
// Event trägt alle relevanten Daten
public class CustomerRelocated {
    private UUID customerId;
    private String name;
    private Address oldAddress;
    private Address newAddress;
    private Instant relocatedAt;
    // Consumer brauchen keinen zusätzlichen API-Call
}
```

### Event Sourcing
```java
// Event-Stream repräsentiert State
OrderCreated → ItemAdded → ItemRemoved → OrderSubmitted → OrderPaid
// Aktueller State = Replay aller Events
```

### CQRS (Command Query Responsibility Segregation)
```java
// Schreib-Modell
CommandHandler → Event → EventStore

// Lese-Modell
Event → Projektion → Read Database (denormalisiert)
```

---

## 📊 Wann Event-Driven Architecture verwenden?

| ✅ Geeignet für | ❌ Nicht geeignet für |
|----------------|----------------------|
| IoT-Systeme mit vielen Sensoren | Einfache CRUD-Anwendungen |
| Real-time Analytics | Transaktionale Konsistenz erforderlich |
| Microservices-Integration | Starke Daten-Konsistenz-Anforderungen |
| Audit Trail / Compliance | Geringe Event-Volumes |
| Asynchrone Workflows | Synchrone Request-Response |
| Skalierbare Stream-Processing | Einfache Batch-Verarbeitung |

---

## 🔗 Referenzen

- Related Patterns: Microservices Architecture, CQRS, Saga Pattern
- Projekt-Beispiele: `docs/architecture/domain-categorization.md`
- Martin Fowler: Event-Driven Architecture
- Gregor Hohpe: Enterprise Integration Patterns
- Chris Richardson: Microservices Patterns (Saga, Event Sourcing)
