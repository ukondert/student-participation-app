# Phase 6: State Management Optimization 🔄

## 📋 Übersicht

**Dauer**: 3-4 Tage  
**Risiko**: Mittel  
**Abhängigkeiten**: Phase 5 (Pages müssen refactored sein)  
**Status**: Wartet auf Phase 5 Completion

---

## 🎯 Ziele

1. **Trennung UI State vs. Domain State**
2. Optimierung der **Provider-Struktur**
3. **Performance-Optimierung** (Memoization, Selective Rebuilds)
4. **State Tests** für kritische Flows
5. **Performance Benchmarks**

---

## 📊 State Analyse

### Aktueller Zustand

```
presentation/providers/
├── providers.dart
└── providers.g.dart
```

**Probleme**:
- ❌ Keine klare Trennung UI vs. Domain State
- ❌ Zu breite Provider (unnötige Rebuilds)
- ❌ Fehlende Memoization
- ❌ Keine State Persistence für UI

---

## 🏗️ Ziel-Architektur

### Neue Struktur

```
lib/presentation/
├── state/
│   ├── ui/
│   │   ├── navigation_state.dart
│   │   ├── filter_state.dart
│   │   ├── search_state.dart
│   │   └── ui_state_providers.dart
│   ├── domain/
│   │   ├── student_state.dart
│   │   ├── subject_state.dart
│   │   ├── class_state.dart
│   │   ├── participation_state.dart
│   │   └── domain_state_providers.dart
│   └── app_state.dart
└── providers/
    └── providers.dart (legacy, wird migriert)
```

---

## 📝 State Management Patterns

### 1. UI State (Ephemeral)

**Navigation State**

```dart
@riverpod
class NavigationState extends _$NavigationState {
  @override
  int build() => 0; // Initial tab index

  void setTab(int index) {
    state = index;
  }
}
```

**Filter State**

```dart
@riverpod
class FilterState extends _$FilterState {
  @override
  FilterOptions build() => FilterOptions.empty();

  void setClassFilter(int? classId) {
    state = state.copyWith(classId: classId);
  }

  void setSubjectFilter(int? subjectId) {
    state = state.copyWith(subjectId: subjectId);
  }

  void reset() {
    state = FilterOptions.empty();
  }
}

class FilterOptions {
  final int? classId;
  final int? subjectId;
  final DateTime? startDate;
  final DateTime? endDate;

  const FilterOptions({
    this.classId,
    this.subjectId,
    this.startDate,
    this.endDate,
  });

  const FilterOptions.empty()
      : classId = null,
        subjectId = null,
        startDate = null,
        endDate = null;

  FilterOptions copyWith({
    int? classId,
    int? subjectId,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return FilterOptions(
      classId: classId ?? this.classId,
      subjectId: subjectId ?? this.subjectId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
}
```

**Search State**

```dart
@riverpod
class SearchState extends _$SearchState {
  @override
  String build() => '';

  void setQuery(String query) {
    state = query;
  }

  void clear() {
    state = '';
  }
}
```

---

### 2. Domain State (Persistent)

**Student State mit Memoization**

```dart
@riverpod
class StudentListState extends _$StudentListState {
  @override
  Future<List<Student>> build(int classId) async {
    final repo = ref.watch(classRepositoryProvider);
    return repo.watchStudents(classId).first;
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => build(classId));
  }
}

// Filtered students (memoized)
@riverpod
List<Student> filteredStudents(
  FilteredStudentsRef ref,
  int classId,
) {
  final studentsAsync = ref.watch(studentListStateProvider(classId));
  final searchQuery = ref.watch(searchStateProvider);

  return studentsAsync.when(
    data: (students) {
      if (searchQuery.isEmpty) return students;
      
      return students.where((student) {
        final fullName = '${student.firstName} ${student.lastName}'.toLowerCase();
        return fullName.contains(searchQuery.toLowerCase());
      }).toList();
    },
    loading: () => [],
    error: (_, __) => [],
  );
}

// Participation counts (memoized per student)
@riverpod
Future<int> positiveParticipationCount(
  PositiveParticipationCountRef ref,
  int studentId,
) async {
  final repo = ref.watch(participationRepositoryProvider);
  final participations = await repo.getParticipationsForStudent(studentId);
  return participations.where((p) => p.isPositive).length;
}

@riverpod
Future<int> negativeParticipationCount(
  NegativeParticipationCountRef ref,
  int studentId,
) async {
  final repo = ref.watch(participationRepositoryProvider);
  final participations = await repo.getParticipationsForStudent(studentId);
  return participations.where((p) => !p.isPositive).length;
}
```

---

### 3. Performance Optimizations

**Selective Rebuilds mit select**

```dart
// ❌ Bad: Rebuilds on any student change
final students = ref.watch(studentListStateProvider(classId));

// ✅ Good: Only rebuilds when specific student changes
final student = ref.watch(
  studentListStateProvider(classId).select(
    (students) => students.firstWhere((s) => s.id == studentId),
  ),
);
```

**Family Providers für granulare Updates**

```dart
// ✅ Each student has its own provider
@riverpod
Future<Student> student(StudentRef ref, int studentId) async {
  final repo = ref.watch(classRepositoryProvider);
  return repo.getStudent(studentId);
}
```

**KeepAlive für teure Berechnungen**

```dart
@riverpod
Future<List<ParticipationStats>> participationStats(
  ParticipationStatsRef ref,
  int classId,
) async {
  // Keep this data alive even when not watched
  ref.keepAlive();
  
  // Expensive calculation
  final repo = ref.watch(participationRepositoryProvider);
  return repo.calculateStats(classId);
}
```

---

### 4. State Persistence (UI State)

**Persisted Navigation State**

```dart
@riverpod
class PersistedNavigationState extends _$PersistedNavigationState {
  static const _key = 'navigation_tab_index';

  @override
  int build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    return prefs.getInt(_key) ?? 0;
  }

  Future<void> setTab(int index) async {
    final prefs = ref.watch(sharedPreferencesProvider);
    await prefs.setInt(_key, index);
    state = index;
  }
}
```

---

## 📋 Implementation Checklist

### Setup (Tag 1)
- [ ] Create `lib/presentation/state/` structure
- [ ] Create `ui/` and `domain/` subdirectories
- [ ] Setup SharedPreferences provider

### UI State (Tag 1)
- [ ] Implement `navigation_state.dart`
- [ ] Implement `filter_state.dart`
- [ ] Implement `search_state.dart`
- [ ] Implement `ui_state_providers.dart`
- [ ] Tests

### Domain State Optimization (Tag 2)
- [ ] Refactor student providers
- [ ] Refactor subject providers
- [ ] Refactor class providers
- [ ] Refactor participation providers
- [ ] Add memoization
- [ ] Add family providers
- [ ] Tests

### Performance Optimization (Tag 3)
- [ ] Add selective rebuilds with `select`
- [ ] Implement `keepAlive` for expensive calculations
- [ ] Optimize list rendering
- [ ] Add debouncing for search
- [ ] Performance profiling

### Migration & Cleanup (Tag 4)
- [ ] Migrate pages to new state structure
- [ ] Remove old provider code
- [ ] Update all references
- [ ] Integration tests
- [ ] Performance benchmarks
- [ ] Code review

---

## ✅ Verification Plan

### Automated Tests

1. **State Tests**
   - UI State changes correctly
   - Domain State updates correctly
   - Persistence works

2. **Performance Tests**
   - Rebuild counts
   - Memory usage
   - Response times

### Manual Verification

1. **Performance Profiling**
   - Use Flutter DevTools
   - Check rebuild counts
   - Memory leaks

2. **User Experience**
   - Smooth interactions
   - Fast responses
   - No jank

---

## 🎯 Success Criteria

- ✅ UI State getrennt von Domain State
- ✅ Provider-Struktur optimiert
- ✅ Rebuild Count reduziert um ≥30%
- ✅ Memory Usage stabil
- ✅ Alle Tests bestehen
- ✅ Performance Benchmarks erfüllt

---

## 📊 Performance Benchmarks

### Before Optimization
- Average rebuilds per interaction: ~15
- Memory usage (100 students): ~45MB
- List scroll FPS: ~55

### Target After Optimization
- Average rebuilds per interaction: ≤10 (-33%)
- Memory usage (100 students): ≤40MB (-11%)
- List scroll FPS: ≥58 (+5%)

---

## 📝 Deliverables

1. **Code**
   - Neue State Management Struktur
   - Optimierte Provider
   - Performance Optimizations

2. **Documentation**
   - State Management Guide
   - Performance Best Practices
   - Migration Guide

3. **Tests**
   - State Tests
   - Performance Tests
   - Benchmarks

---

**Status**: Wartet auf Phase 5 Completion  
**Nächster Schritt**: Phase 5 abschließen, dann finale Optimierung
