# Microservices Architecture

> **Quelle:** Software Architecture Patterns  
> **Kategorie:** Architectural Pattern  
> **Ebene:** Gesamtarchitektur

---

## 🎯 Ziel

Hohe Skalierbarkeit und Elastizität durch unabhängige Skalierung einzelner Komponenten. Flexibilität zur Aufrechterhaltung der Leistung bei unvorhersehbaren Spitzen.

---

## 📋 Architektur-Komponenten

| Komponente | Zweck | Artefakte | Hauptverantwortung |
|---------|-------|-----------|-------------------|
| **Microservice** | Eigenständige Geschäftsfähigkeit | Service Code, API, Datenbank | Vollständige Verantwortung für eine Domäne |
| **API Gateway** | Zentrale Eingangspunkt | Routing, Auth, Rate Limiting | Anfragen an Services weiterleiten |
| **Service Discovery** | Service-Registrierung | Registry, Health Checks | Services finden und überwachen |
| **Message Broker** | Asynchrone Kommunikation | Events, Commands, Queues | Entkoppelte Kommunikation |
| **Configuration Service** | Zentrale Konfiguration | Config Server, Properties | Konfiguration bereitstellen |

---

## 🏗️ Architektur-Diagramm

```
┌─────────────────────────────────────────────────┐
│            API Gateway                          │
│   (Routing, Auth, Rate Limiting)                │
└──────┬──────────┬──────────┬──────────┬─────────┘
       │          │          │          │
┌──────▼──────┐ ┌▼─────────┐ ┌▼────────┐ ┌▼────────┐
│ Service A   │ │Service B │ │Service C│ │Service D│
│ ┌─────────┐ │ │┌────────┐│ │┌───────┐│ │┌───────┐│
│ │Business │ │ ││Business││ ││Business││ ││Business││
│ │ Logic   │ │ ││ Logic  ││ ││ Logic ││ ││ Logic ││
│ └────┬────┘ │ │└───┬────┘│ │└───┬───┘│ │└───┬───┘│
│      │      │ │    │     │ │    │    │ │    │    │
│ ┌────▼────┐ │ │┌───▼────┐│ │┌───▼───┐│ │┌───▼───┐│
│ │  DB A   │ │ ││  DB B  ││ ││ DB C  ││ ││ DB D  ││
│ └─────────┘ │ │└────────┘│ │└───────┘│ │└───────┘│
└─────────────┘ └──────────┘ └─────────┘ └─────────┘
       │             │            │           │
       └─────────────┴────────────┴───────────┘
                     │
              ┌──────▼───────┐
              │Message Broker│
              │ (Events/Msg) │
              └──────────────┘
```

**Regel:** Jeder Microservice hat seine **eigene Datenbank** (Database per Service Pattern)!

---

## ✅ Best Practices

| Regel | Beschreibung |
|-------|--------------|
| **Lose Kopplung** | Services kommunizieren nur über APIs, keine direkten Abhängigkeiten. |
| **Hohe Kohäsion** | Jeder Service deckt eine spezifische Geschäftsfähigkeit ab. |
| **Autonomie** | Services können unabhängig entwickelt, deployed und skaliert werden. |
| **Resilience** | Circuit Breaker, Timeouts, Retry-Logik implementieren. |
| **Observability** | Distributed Tracing, Logging, Monitoring für alle Services. |
| **API Versionierung** | APIs versionieren für Abwärtskompatibilität. |

---

## 💻 Beispiel: Service-Struktur

```
microservices/
 ├─ user-service/
 │   ├─ src/
 │   │   ├─ api/
 │   │   │   ├─ UserController.java
 │   │   │   └─ dto/
 │   │   │       ├─ CreateUserRequest.java
 │   │   │       └─ UserResponse.java
 │   │   ├─ domain/
 │   │   │   ├─ User.java
 │   │   │   └─ UserService.java
 │   │   ├─ repository/
 │   │   │   └─ UserRepository.java
 │   │   └─ config/
 │   │       └─ ServiceConfig.java
 │   ├─ Dockerfile
 │   └─ pom.xml / build.gradle
 │
 ├─ order-service/
 │   ├─ src/
 │   │   ├─ api/
 │   │   │   └─ OrderController.java
 │   │   ├─ domain/
 │   │   │   ├─ Order.java
 │   │   │   └─ OrderService.java
 │   │   ├─ repository/
 │   │   │   └─ OrderRepository.java
 │   │   └─ messaging/
 │   │       ├─ OrderCreatedPublisher.java
 │   │       └─ PaymentEventListener.java
 │   ├─ Dockerfile
 │   └─ pom.xml / build.gradle
 │
 ├─ payment-service/
 │   └─ ...
 │
 ├─ api-gateway/
 │   └─ src/
 │       ├─ routes/
 │       ├─ filters/
 │       └─ security/
 │
 └─ docker-compose.yml
```

---

## 🤖 KI-Agent Hinweise

* Jeder Service ist ein **eigenständiges Deployment-Artefakt** (JAR, Container).
* Verwende **API First Design** - definiere OpenAPI/Swagger Specs zuerst.
* Implementiere **Service-to-Service Authentication** (OAuth2, JWT).
* Nutze **Asynchrone Kommunikation** wo möglich (Events statt direkte Calls).
* Implementiere **Health Checks** für jeden Service (`/actuator/health`).
* Verwende **Correlation IDs** für Request Tracking über Services hinweg.

---

## 📌 Checkliste

- [ ] Jeder Service hat seine eigene Datenbank
- [ ] API Gateway konfiguriert für Routing und Security
- [ ] Service Discovery implementiert (Eureka, Consul, etc.)
- [ ] Circuit Breaker für externe Calls (Resilience4j, Hystrix)
- [ ] Centralized Logging (ELK Stack, Splunk)
- [ ] Distributed Tracing (Zipkin, Jaeger)
- [ ] Container Orchestration (Kubernetes, Docker Swarm)
- [ ] CI/CD Pipeline pro Service
- [ ] API Versionierung implementiert
- [ ] Service-to-Service Authentication

---

## ⚠️ Anti-Patterns vermeiden

❌ **Shared Database**
```java
// FALSCH - Mehrere Services greifen auf gleiche DB zu
// user-service
SELECT * FROM users WHERE id = ?

// order-service
SELECT * FROM users WHERE id = ?  // Gleiche Tabelle!
```

✅ **Database per Service**
```java
// RICHTIG - Jeder Service hat eigene DB
// user-service
SELECT * FROM user_db.users WHERE id = ?

// order-service - User-Info über API holen
UserDTO user = userServiceClient.getUser(userId);
```

❌ **Synchrone Ketten (Cascading Failures)**
```java
// FALSCH - Service A → B → C → D (Kette)
// Wenn D ausfällt, fallen alle aus!
public Order createOrder() {
    User user = userService.getUser();  // Sync
    Payment payment = paymentService.charge();  // Sync
    Shipping shipping = shippingService.schedule();  // Sync
}
```

✅ **Asynchrone Event-basierte Kommunikation**
```java
// RICHTIG - Event-getrieben, entkoppelt
public Order createOrder() {
    Order order = orderRepository.save(order);
    eventPublisher.publish(new OrderCreated(order.getId()));
    return order;  // Schnell zurück
}

// Andere Services reagieren asynchron auf Event
@EventListener
public void onOrderCreated(OrderCreated event) {
    // Payment Service verarbeitet
}
```

❌ **Nanoservices (Zu fein granular)**
```java
// FALSCH - Service pro Entität
getUserFirstName() // Service 1
getUserLastName()  // Service 2
getUserEmail()     // Service 3
```

✅ **Bounded Context als Service-Grenze**
```java
// RICHTIG - Service pro Geschäftsfähigkeit
UserManagementService {
    createUser()
    updateUser()
    getUser()
}
```

---

## 🔧 Technologie-Stack Beispiele

### Java/Spring Boot
- **Spring Cloud** (Gateway, Config Server, Service Discovery)
- **Spring Boot Actuator** (Health Checks, Metrics)
- **Resilience4j** (Circuit Breaker)
- **Kafka/RabbitMQ** (Message Broker)

### .NET
- **ASP.NET Core**
- **Ocelot** (API Gateway)
- **MassTransit** (Messaging)
- **Polly** (Resilience)

### Node.js
- **Express/NestJS**
- **Kong/Express Gateway**
- **Bull/Bee-Queue** (Job Queues)

### Infrastruktur
- **Kubernetes** (Orchestration)
- **Docker** (Containerization)
- **Prometheus + Grafana** (Monitoring)
- **ELK Stack** (Logging)
- **Istio/Linkerd** (Service Mesh)

---

## 📊 Wann Microservices verwenden?

| ✅ Geeignet für | ❌ Nicht geeignet für |
|----------------|----------------------|
| E-Commerce Plattformen | Kleine Anwendungen (< 5 Entwickler) |
| Multi-Tenant SaaS | Startups in früher Phase |
| Systeme mit hoher Skalierungsanforderung | Einfache CRUD-Anwendungen |
| Große Teams (> 20 Entwickler) | Prototypen/MVPs |
| Unterschiedliche Technologie-Stacks pro Team | Geringe DevOps-Reife |
| Unabhängige Deployment-Zyklen | Keine Container-Infrastruktur |

---

## 🔗 Referenzen

- Related Patterns: Event-Driven Architecture, Hexagonal Architecture
- Projekt-Beispiele: `docs/architecture/domain-categorization.md`
- Sam Newman: Building Microservices
- Chris Richardson: Microservices Patterns
- Pattern: Database per Service, API Gateway, Saga, CQRS
