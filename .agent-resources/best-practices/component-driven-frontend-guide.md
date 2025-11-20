# 🎨 Component-Driven Frontend Development - Vollständiger Workflow-Guide

Dieser Guide beschreibt den **vollständigen Workflow** für die iterative Implementierung von Frontend User Stories unter Verwendung von **Component-Driven Development**, **Design Systems** und **Accessibility-First Ansatz**.

---

## 🎯 Zielsetzung

1. **Component-Driven Development:** UI in klar abgegrenzte, wiederverwendbare Komponenten zerlegen (Atomic Design / Design System)
2. **API-First Consumption:** OpenAPI / GraphQL Spec als Grundlage für Client-Generierung & Typen
3. **Design System Integration:** Nutzung konsistenter Tokens (Color, Spacing, Typography)
4. **Accessibility First:** WCAG 2.1 AA Richtlinien früh prüfen (Keyboard, ARIA, Kontrast)
5. **State Management Klarheit:** Trennung von Server State (Query/Cache) & UI/Local State
6. **Test-Pyramide für Frontend:** Unit (logik), Component (Rendering), Visual Regression, E2E (Flows)
7. **Performance & UX Optimierung:** Lazy Loading, Code Splitting, Rendering Costs minimieren
8. **Iterative Entwicklung:** Eine Story vollständig (Design → Code → Tests → Review) abschließen

---

## 📋 Voraussetzungen

Stelle sicher, dass folgende Artefakte vorhanden sind:

- ✅ User Story (refined) in `docs/requirements/user-stories/refined/`
- ✅ OpenAPI / GraphQL Spezifikation (`api/openapi/*.yaml` oder `api/schema.graphql`)
- ✅ Domain & Begrifflichkeiten (`docs/architecture/ubiquitous-language-glossar.md`)
- ✅ Design-Ressourcen (Figma Link / Tokens Datei z.B. `design/tokens.json`)
- ✅ Component Guidelines / Design System (z.B. `design/system.md`)
- ✅ Accessibility Guidelines (`.agent-resources/best-practices/`)

Optional:
- 🔄 Feature Flags Konfiguration (`config/feature-flags.yaml`)
- 🔐 Auth Flows Dokumentation (`docs/architecture/architecture-decisions.md`)

---

## 🔄 Workflow: User Story → Frontend Umsetzung

### Phase 1: Story Selection & UX Analysis

**Step 1.1: Story auswählen**

```prompt
Wähle nächste Frontend Story basierend auf:
- Priorität (MVP, Must-Have, Should-Have)
- UI-Abhängigkeiten (Basis-Komponenten zuerst)
- API Verfügbarkeit (benötigte Endpunkte vorhanden?)
- Risiko (komplexe Interaktionen früh klären)

Output als Tabelle:
| ID | Titel | Bounded Context | Priorität | API-Status | UI-Komplexität | Dependencies |
```

**Step 1.2: UX & Flow Analyse**

1. Benutzerziel & Erwartung
2. Primäre & sekundäre Interaktionen
3. Navigationspunkte / Entry Points
4. Fehler- & leere Zustände (Empty / Loading / Error UI)
5. Accessibility Hotspots (Focus Order, Landmark Roles)

**Output:** `analysis/[story-id]-frontend-analysis.md`

```markdown
# Frontend Story Analysis: [US-ID] [Titel]
## Benutzerfluss
Sequence Diagram / Step Liste
## Screens / Views
- [Screen 1]: Beschreibung
- [Screen 2]: Beschreibung
## States
- Loading: Skelett / Spinner / ARIA
- Empty: Illustration / CTA
- Error: Retry / Support Link
## Accessibility Checkpoints
- Focus Trap nötig? Ja/Nein
- ARIA Rollen: [list]
- Kontrast: Prüfen für Primärbutton
## Performance Risiken
- Große Tabellen? Virtuelles Scrolling?
```

---

### Phase 2: UI Specification & Component Design

**Step 2.1: UI Spec Ableiten**
Erstelle eine Low-Level UI Spec Datei: `ui-spec/[story-id].md`

Inhalt:
- Komponenten-Liste (Atoms, Molecules, Organisms)
- Props Tabellen (Name | Typ | Pflicht | Default | Beschreibung | A11y)
- Zustände (Normal, Hover, Focus, Disabled, Error, Loading, Empty)
- Responsive Breakpoints Verhalten

**Step 2.2: Figma / Design Tokens Abgleich**
```prompt
Mappe alle Komponenten auf Design Tokens:
- Farben -> semantic tokens (primary.bg, danger.text)
- Spacing -> scale (space.1 .. space.8)
- Typografie -> heading.s, body.m, mono.s
```

**Step 2.3: Storybook Draft**
Erstelle Skeleton Stories für jede neue Komponente:
```
src/components/[Component]/[Component].stories.tsx
```

Template:
```typescript
import type { Meta, StoryObj } from '@storybook/react';
import { [Component] } from './[Component]';

const meta: Meta<typeof [Component]> = {
  title: 'Components/[Category]/[Component]',
  component: [Component],
  args: { /* default props */ },
  parameters: { a11y: { disable: false } }
};
export default meta;
export const Default: StoryObj<typeof [Component]> = { };
export const Loading: StoryObj<typeof [Component]> = { args: { loading: true } };
export const Error: StoryObj<typeof [Component]> = { args: { error: 'Fehler' } };
```

---

### Phase 3: API Client & Data Layer

**Step 3.1: Types generieren**
```bash
openapi-typescript api/openapi/[bounded-context].yaml -o src/api/types/[bounded-context].d.ts
```

**Step 3.2: API Client Wrapper**
```typescript
// src/api/clients/[bounded-context]Client.ts
import { createClient } from 'openapi-fetch';
import type { paths } from '../types/[bounded-context]';

export const boundedContextClient = createClient<paths>({ baseUrl: '/api/v1' });

export async function listResource(params?: { page?: number }) {
  return await boundedContextClient.GET('/resource', { params: { query: params } });
}
```

**Step 3.3: Server State Management (z.B. TanStack Query)**
```typescript
// src/state/queries/use[Resource]List.ts
import { useQuery } from '@tanstack/react-query';
import { listResource } from '../../api/clients/boundedContextClient';

export const useResourceList = (page = 1) => {
  return useQuery({
    queryKey: ['resource-list', page],
    queryFn: () => listResource({ page }),
    staleTime: 60_000,
  });
};
```

**Step 3.4: Error & Loading Handling Patterns**
Definition zentraler UI Patterns in `src/ui/patterns/` (Spinner, Skeleton, ErrorBoundary).

---

### Phase 4: State & Interaction Design

**Step 4.1: Lokaler State vs. Server State**
Dokumentiere für die Story:
```markdown
| Datenpunkt | Quelle | Lebensdauer | Sync Strategie | Ownership |
|------------|--------|-------------|----------------|-----------|
```

**Step 4.2: Form Handling**
Nutzung von `react-hook-form` / `Formik` inkl. Zod/Joi Validierung.

**Step 4.3: Optimistic Updates & Undo**
Beschreibe wann Optimistic UI eingesetzt wird und wie Rollback erfolgt.

**Step 4.4: Accessibility Checks**
- Fokus-Reihenfolge testen
- Screenreader Labels (aria-label, aria-describedby)
- Escape / Keyboard Shortcuts

---

### Phase 5: Component Implementation

**Step 5.1: Komponentenverzeichnis**
```
src/components/[Component]/
  [Component].tsx
  [Component].test.tsx
  [Component].stories.tsx
  index.ts
  styles.module.(css|scss|ts)
```

**Step 5.2: Komponenten Template**
```typescript
import clsx from 'clsx';
import styles from './styles.module.css';
import { useId } from 'react';

export interface [Component]Props {
  variant?: 'primary' | 'secondary';
  disabled?: boolean;
  loading?: boolean;
  onClick?: () => void;
  children?: React.ReactNode;
  'aria-label'?: string;
}

export const [Component]: React.FC<[Component]Props> = ({
  variant = 'primary', disabled, loading, onClick, children, ...rest
}) => {
  const id = useId();
  return (
    <button
      id={id}
      className={clsx(styles.root, styles[variant], { [styles.loading]: loading })}
      disabled={disabled || loading}
      onClick={onClick}
      {...rest}
    >
      {loading ? <span className={styles.spinner} aria-hidden /> : children}
    </button>
  );
};
```

**Step 5.3: Styling Strategie**
- CSS Modules / Tailwind / Styled Components
- Theming via CSS Custom Properties (`:root { --color-primary: ... }`)
- Dark Mode Support

**Step 5.4: Design Tokens Verbrauch**
Zentrale Datei `src/design/tokens.ts`:
```typescript
export const tokens = {
  color: { primary: 'hsl(210,90%,50%)', danger: 'hsl(0,70%,50%)' },
  space: { xs: 4, sm: 8, md: 16, lg: 24 },
  radius: { sm: 4, md: 8 },
  font: { body: 'Inter, sans-serif', mono: 'JetBrains Mono' }
};
```

---

### Phase 6: Testing

**Testarten:**
1. Unit Tests (Logik, Hooks)
2. Component Tests (Rendering + Props + A11y) → Testing Library
3. Visual Regression (Chromatic / Loki)
4. E2E Flows (Playwright / Cypress)
5. Performance Smoke (Lighthouse CI)

**Step 6.1: Component Test Beispiel**
```typescript
// src/components/[Component]/[Component].test.tsx
import { render, screen } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { [Component] } from './[Component]';

describe('[Component]', () => {
  it('renders children', () => {
    render(<[Component]>Click me</[Component]>);
    expect(screen.getByRole('button', { name: /click me/i })).toBeInTheDocument();
  });
  it('handles onClick', async () => {
    const fn = vi.fn();
    render(<[Component] onClick={fn}>Trigger</[Component]>);
    await userEvent.click(screen.getByRole('button'));
    expect(fn).toHaveBeenCalledTimes(1);
  });
});
```

**Step 6.2: Accessibility Test (Jest Axe)**
```typescript
import { axe } from 'jest-axe';
it('has no a11y violations', async () => {
  const { container } = render(<[Component]>Label</[Component]>);
  const results = await axe(container);
  expect(results).toHaveNoViolations();
});
```

**Step 6.3: E2E Beispiel (Playwright)**
```typescript
// tests/e2e/[story].spec.ts
import { test, expect } from '@playwright/test';
test('User can submit form', async ({ page }) => {
  await page.goto('/register');
  await page.fill('input[name=email]', 'user@example.com');
  await page.click('button[type=submit]');
  await expect(page.getByText(/Willkommen/i)).toBeVisible();
});
```

---

### Phase 7: Performance & Optimization

**Step 7.1: Messung**
- Lighthouse lokal → `npm run lighthouse`
- Web Vitals Logging → `reportWebVitals.ts`

**Step 7.2: Optimierungen**
- Code Splitting (`React.lazy`) / Dynamic Imports
- Memoization (useMemo / useCallback) bewusst einsetzen
- Virtualized Lists (react-window)
- Image Optimierung (responsive sizes, lazy loading)

**Step 7.3: Bundle Analyse**
```bash
npm run build -- --stats
```
Nutze `source-map-explorer` / `webpack-bundle-analyzer`.

---

### Phase 8: Documentation & Review

**Step 8.1: Storybook Dokumentation vervollständigen**
- Controls / Docs Tab
- MDX für komplexe Komponenten (`[Component].stories.mdx`)

**Step 8.2: Prop Tables & A11y Hinweise**
Automatisiert durch Storybook / Typedoc.

**Step 8.3: Changelog Eintrag**
Bei UI-relevanten Änderungen → `CHANGELOG.md` Abschnitt `Added` / `Changed`.

**Step 8.4: Review Checklist**
```markdown
# Frontend Story Review: [US-ID]
## UI
- [ ] Alle States implementiert (Loading, Empty, Error, Disabled)
- [ ] Responsive Verhalten getestet (sm, md, lg)
- [ ] Kontrast geprüft (AA mindestens)
## Code
- [ ] Komponenten ohne Business Logik
- [ ] Keine Inline Styles für wiederholte Patterns
- [ ] Tokens genutzt statt Hardcodes
## Accessibility
- [ ] Keyboard Navigation vollständig
- [ ] ARIA Rollen korrekt
- [ ] Fokus sichtbar & logisch
## Testing
- [ ] Unit Tests >= 80% für Logik
- [ ] Component Tests für kritische Props
- [ ] E2E Happy Path vorhanden
- [ ] Keine kritischen a11y Violations
## Performance
- [ ] Keine unnötigen Re-Renders (DevTools Profiler)
- [ ] Bundle Size im Budget
## Documentation
- [ ] Storybook Stories vollständig
- [ ] UI Spec aktuell
- [ ] README / ADR Ergänzungen (falls Architekturentscheidung)
```

---

## 🎓 Best Practices (Frontend Fokus)

### Accessibility (A11y)
- Verwende semantische HTML Elemente vor ARIA
- Form Labels immer gekoppelt (`label for` / `id`)
- Farbkontrast (Mindestens 4.5:1 für Text < 18px)
- Fokuszustände niemals entfernen
- Escape schließt Modals, Tab springt logisch

### Component Design
- Single Responsibility (Keine API Calls im UI Layer)
- Props Explosion vermeiden → Komposition bevorzugen
- Keine globalen Styles ohne Notwendigkeit
- Fallback UI für jeden asynchronen Bereich

### State Management
- Server State ≠ UI State (React Query für Daten, useState für UI)
- Vermeide übermäßige globale Stores (nur wo Sharing oder Cross-Cut nötig)
- Persistenz lokal nur wenn UX Mehrwert (localStorage / IndexedDB)

### API Consumption
- Typen aus OpenAPI statt manuell pflegen
- Error Boundaries für Netzwerkfehler
- Retry Strategien (Exponential Backoff) dokumentieren

### Performance
- Priorisiere FCP & TTI
- Bilder: korrekte Größen, lazy loading
- Fonts: `display=swap`, Subsetting
- Vermeide tiefe Prop Drilling → context / composition

---

## 📦 Empfohlener Tech Stack

| Bereich | Empfehlung |
|---------|------------|
| Framework | React / Next.js / Vue / Svelte |
| Styling | CSS Modules / Tailwind / Styled Components |
| Design System | Storybook + Tokens (style-dictionary) |
| API | REST (OpenAPI) / GraphQL (Codegen) |
| State | React Query / Zustand / Redux Toolkit (nur komplex) |
| Forms | react-hook-form + Zod |
| Testing | Vitest/Jest, Testing Library, Playwright |
| Linting | ESLint + Prettier + stylelint |
| Type Safety | TypeScript Strict Mode |
| CI | GitHub Actions (Lint → Test → Build → Visual Regression) |

---

## 🔄 Iteration Loop (Frontend)

1. Story auswählen & analysieren
2. UI Spec + Komponenten skeleton
3. API Typen & Client generieren
4. Komponenten & State implementieren
5. Tests (Unit → Component → E2E)
6. Accessibility & Performance Check
7. Dokumentation / Review / Merge
8. Nächste Story

---

## 📁 Referenzen

- User Stories: `docs/requirements/user-stories/refined/*.md`
- Ubiquitous Language: `docs/architecture/ubiquitous-language-glossar.md`
- Design Tokens: `src/design/tokens.ts` (falls vorhanden)
- API Spezifikation: `api/openapi/*.yaml`
- Best Practices: `.agent-resources/best-practices/*`
- Patterns: `.agent-resources/architecture/patterns/*.md`

---

**Version:** 1.0.0  
**Letzte Aktualisierung:** 12. November 2025  
**Maintainer:** Frontend Team
