# Space-Based Architecture

> **Quelle:** Patterns for Scalable Systems  
> **Kategorie:** Architectural Pattern  
> **Ebene:** Gesamtarchitektur

---

## 🎯 Ziel

Maximale Leistung und Elastizität bei ressourcenintensiven Prozessen durch Eliminierung zentraler Flaschenhälse und durch verteilte Verarbeitung in einem "Space"-basierten Laufzeitmodell.

---

## 📋 Architektur-Komponenten

| Komponente | Zweck | Artefakte | Hauptverantwortung |
|---------|-------|-----------|-------------------|
| **Processing Units (PUs)** | Arbeitsinstanzen innerhalb des Space | Service Instances, In-memory Caches | Verarbeitungslast verteilen |
| **Shared Nothing Space** | Verteilte Datenhaltung | In-Memory Grid, Data Partitions | Daten lokal halten, Partitioning |
| **Messaging / Queue** | Aufgabenverteilung | Task Queues, Event Channels | Work Distribution, Backpressure |
| **Data Grid / Cache** | Schneller Datenspeicher | In-Memory Data Grid (GigaSpaces, Hazelcast) | Niedrige Latenz, Skalierung |
| **Scaler / Orchestrator** | Skalierung und Placement | Scheduler, Auto-Scaler | Ressourcenverwaltung, Placement

---

## 🏗️ Architektur-Diagramm

```
                 ┌──────────────────────┐
                 │     Client Layer     │
                 └─────────┬────────────┘
                           │
                   ┌───────▼────────┐
                   │   Frontend/API  │
                   └───────┬────────┘
                           │
        ┌──────────────────▼──────────────────┐
        │            Space / Grid              │
        │  ┌────────┐  ┌────────┐  ┌────────┐  │
        │  │ PU #1  │  │ PU #2  │  │ PU #3  │  │
        │  └──┬─────┘  └──┬─────┘  └──┬─────┘  │
        │     │           │           │       │
        │  ┌──▼──┐     ┌──▼──┐     ┌──▼──┐    │
        │  │Cache│     │Cache │     │Cache │    │
        │  └─────┘     └──────┘     └──────┘    │
        └────────┬──────────┬──────────┬──────┘
                 │          │          │
         ┌───────▼──┐  ┌────▼────┐  ┌──▼─────┐
         │Queue/Msg │  │DataGrid │  │Orchestr.│
         └──────────┘  └─────────┘  └─────────┘
```

**Regel:** Keine zentralen Bottlenecks; Daten/Work lokal an PUs halten.

---

## ✅ Best Practices

| Regel | Beschreibung |
|-------|--------------|
| **Shared-Nothing** | Vermeide zentrale State-Locks und Shared DBs. |
| **Partitioning** | Daten und Arbeit partitionieren (sharding). |
| **Local Caching** | Reduziere Netzwerk-Latenz durch lokale Caches. |
| **Backpressure** | Messaging mit Backpressure zur Stabilisierung nutzen. |
| **Elastic Scaling** | Autoscaling von Processing Units nach Last. |
| **Replication** | Repliziere kritische Daten für Ausfallsicherheit. |

---

## 💻 Beispiel: Verzeichnisstruktur / Deployment

```
space-based-system/
 ├─ processing-units/
 │   ├─ pu-1/
 │   ├─ pu-2/
 │   └─ pu-3/
 ├─ data-grid/
 │   └─ hazelcast-cluster/
 ├─ queue/
 │   └─ task-queue/
 ├─ orchestrator/
 │   └─ placement-service/
 └─ infra/
     ├─ monitoring/
     └─ autoscaler/
```

---

## 🤖 KI-Agent Hinweise

* Verwende In-Memory-Grids (Hazelcast, GigaSpaces) für niedrige Latenz.
* Halte Daten und Arbeit lokal — prefer local reads over network.
* Nutze eventuelle persistenten Backing Stores nur für Durability, nicht für Hot Paths.
* Implementiere starke Observability (latency, queue depth, partition skew).
* Teste Partitioning-Strategien mit realen Lastprofilen.

---

## 📌 Checkliste

- [ ] Shared-Nothing-Prinzip eingehalten
- [ ] Partitioning-Strategie definiert
- [ ] In-Memory-Data-Grid implementiert
- [ ] Backpressure im Messaging konfiguriert
- [ ] Autoscaling und Placement-Policy vorhanden
- [ ] Monitoring für queue-depth und partition-skew
- [ ] Failover/Replication getestet

---

## ⚠️ Anti-Patterns vermeiden

❌ **Zentrales Datenbank-Backbone**
```java
// FALSCH - Single DB wird Engpass
SELECT * FROM central_db.orders WHERE id = ?
```

✅ **Local Partition & Cache**
```java
// RICHTIG - Local PU greift auf lokalen Cache
Order o = localCache.get(orderId);
if (o == null) { o = remoteStorage.fetch(orderId); localCache.put(orderId, o); }
```

❌ **Unkontrolliertes Rebalancing**
```java
// FALSCH - Ständiges Verschieben von Partitionen unter Last
rebalancer.runContinuously();
```

✅ **Controlled Rebalancing**
```java
// RICHTIG - Rebalance nach stabilen Perioden
if (loadStable()) { rebalancer.rebalance(); }
```

---

## 🔧 Technologie-Stack Beispiele

- GigaSpaces XAP
- Hazelcast IMDG
- Redis Cluster (für some use-cases)
- Kubernetes für managing PUs
- Kafka / Pulsar for messaging

---

## 📊 Wann Space-Based Architecture verwenden?

| ✅ Geeignet für | ❌ Nicht geeignet für |
|----------------|----------------------|
| Echtzeit-Spitzenlasten | Kleine CRUD-Apps |
| Hohe Parallelität & niedrige Latenz | Systeme ohne in-memory requirements |
| Numerische Berechnungen / HPC-Likes | Workloads mit zentralen Transaktionen |
| Systeme mit kurzfristig sehr hoher Last | Einfach zu wartende Monolithen |

---

## 🔗 Referenzen

- Related Patterns: Scale-Out, Distributed Caching
- Projekt-Beispiele: `docs/architecture/domain-categorization.md`
- GigaSpaces Documentation
- Hazelcast Documentation
