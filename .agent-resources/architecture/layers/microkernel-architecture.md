# Microkernel (Plugin) Architecture

> **Quelle:** Architectural Patterns & Plugin Systems  
> **Kategorie:** Architectural Pattern  
> **Ebene:** Gesamtarchitektur

---

## 🎯 Ziel

Hohe Flexibilität und Modularität: Erlaubt das Hinzufügen, Entfernen oder Ersetzen von Funktionalität durch Plug-ins, ohne den Kern des Systems zu verändern.

---

## 📋 Architektur-Komponenten

| Komponente | Zweck | Artefakte | Hauptverantwortung |
|---------|-------|-----------|-------------------|
| **Core (Microkernel)** | Minimaler Laufzeitkern | Kernel API, Lifecycle Management | Kernfunktionen, Plugin-Management |
| **Plugins** | Erweiterungen der Funktionalität | Plugin Bundles, Adapters | Implementieren Geschäftslogik-Erweiterungen |
| **Plugin Host/Loader** | Laden & Initialisieren | Classloaders, Module Registry | Plugin-Lifecycle, Isolation |
| **Extension Points** | API-Punkte im Kernel | Interfaces, Events | Stellen Hooks für Plugins bereit |
| **Plugins Repository** | Speicherung von Plugins | Artifact Repository | Distribution und Versionierung |

---

## 🏗️ Architektur-Diagramm

```
┌───────────────────────────┐
│         Application       │
│ ┌───────────────────────┐ │
│ │      Microkernel      │ │
│ │  (Core + ExtensionPoints)│
│ └──────┬────────┬────────┘ │
│        │        │          │
│  ┌─────▼──┐  ┌──▼────┐  ┌──▼────┐
│  │Plugin A│  │Plugin B│  │Plugin C│
│  └────────┘  └────────┘  └────────┘
└───────────────────────────┘
        │            │
        ▼            ▼
   Plugin Repo    Management UI
```

**Regel:** Der Kernel bleibt klein und stabil; komplexe oder wechselnde Funktionen gehören in Plugins.

---

## ✅ Best Practices

| Regel | Beschreibung |
|-------|--------------|
| **Kleiner Kernel** | Minimaler, verlässlicher Kern ohne Geschäftsspezifik. |
| **Klare Extension Points** | Definierte Interfaces und Events für Plugins. |
| **Isolation** | Plugins sollten isoliert laufen (Classloader, Prozesse) um Seiteneffekte zu minimieren. |
| **Versionierung** | Kompatibilitätsgarantien zwischen Kernel und Plugins. |
| **Sandboxing** | Sicherheitsgrenzen für untrusted Plugins. |
| **Lifecycle Management** | Hot-swap von Plugins unterstützen (Load/Unload) wenn möglich. |

---

## 💻 Beispiel: Verzeichnisstruktur

```
app/
 ├─ core/
 │   ├─ kernel/
 │   │   ├─ Kernel.java
 │   │   ├─ ExtensionPoint.java
 │   │   └─ PluginManager.java
 │
 ├─ plugins/
 │   ├─ payment-plugin/
 │   │   ├─ src/
 │   │   │   └─ PaymentPlugin.java
 │   │   └─ plugin-manifest.yml
 │   ├─ reports-plugin/
 │   │   └─ src/
 │   │       └─ ReportsPlugin.java
 │   └─ analytics-plugin/
 │       └─ src/
 │           └─ AnalyticsPlugin.java
 │
 ├─ plugin-repo/
 │   └─ artifacts/
 │       ├─ payment-plugin-1.0.jar
 │       └─ reports-plugin-2.1.jar
 │
 └─ management/
     ├─ ui/
     └─ cli/
```

---

## 🤖 KI-Agent Hinweise

* Definiere Extension Points so früh wie möglich; sie sind das Contract zwischen Kernel und Plugins.
* Erzeuge `plugin-manifest.yml` mit Metadaten (id, version, dependencies, compatible-kernel).
* Favorisiere lose Kopplung: Plugins kommunizieren über Kernel-APIs und Events.
* Implementiere Sicherheitsprüfungen bevor Plugins geladen werden (Signatur, Whitelist).
* Biete ein Plugin-Testing-Toolkit (Mock Kernel) für Plugin-Entwickler.

---

## 📌 Checkliste

- [ ] Kernel minimal halten
- [ ] Extension Points dokumentieren
- [ ] Plugin-Isolierung implementiert
- [ ] Plugin Versioning & Compatibility-Policy
- [ ] Management UI / CLI für Plugin Lifecycle
- [ ] Sicherheitsprüfung für externe Plugins
- [ ] Hot-Swap (Load/Unload) Unterstützung geprüft
- [ ] CI/CD für Plugin-Publikation

---

## ⚠️ Anti-Patterns vermeiden

❌ **Monolithischer Kernel (Zu viel Logik im Kernel)**
```java
// FALSCH
public class Kernel {
    public void generateReports() { /* report logic */ }
    public void processPayments() { /* payment logic */ }
}
```

✅ **Keep Kernel Slim**
```java
// RICHTIG
public interface ReportExtensionPoint {
    void generateReport(ReportRequest req);
}

// Implementation in reports-plugin
public class ReportsPlugin implements ReportExtensionPoint {
    public void generateReport(ReportRequest req) { /* plugin logic */ }
}
```

❌ **Tight Coupling via Shared State**
```java
// FALSCH - Plugins greifen auf geteilten globalen State zu
GlobalState.get().set("user", user);
```

✅ **Kommunikation über APIs/Events**
```java
// RICHTIG - Plugins nutzen Kernel-APIs
kernel.getUserService().getUser(userId);
```

---

## 🔧 Technologie-Stack Beispiele

### Java
- OSGi (Modular Runtime)
- Spring Boot with Plugin System
- Java ServiceLoader

### .NET
- MEF (Managed Extensibility Framework)
- .NET Core with dynamic Assembly Loading

### JavaScript/Node.js
- Plugin architectures via npm packages
- Electron Plugin Systems

---

## 📊 Wann Microkernel verwenden?

| ✅ Geeignet für | ❌ Nicht geeignet für |
|----------------|----------------------|
| Plattformen mit konfigurierbarer Funktionalität | Sehr kleine, einfache Apps |
| Systeme mit erweiterbaren Features (IDE, CMS) | Anwendungen ohne Erweiterungsbedarf |
| Produkte mit Drittanbieter-Plugins | Systeme mit hoher Security-Risk ohne Sandbox |
| Long-living Applications mit dynamischen Anforderungen | Kurzlebige, disposable services |

---

## 🔗 Referenzen

- Related Patterns: Plugin Architecture, Hexagonal Architecture
- Projekt-Beispiele: `docs/architecture/domain-categorization.md`
- OSGi Specification
- Martin Fowler: Microkernel Architecture
