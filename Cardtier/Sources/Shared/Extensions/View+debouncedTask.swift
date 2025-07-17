import SwiftUI

extension View {
  func task<T>(
    debounced debounceTime: Duration,
    id value: T,
    priority: TaskPriority = .userInitiated,
    _ action: @escaping () async -> Void
  ) -> some View where T: Equatable {
    self.task(id: value, priority: priority) {
      do { try await Task.sleep(for: debounceTime) } catch { return }
      await action()
    }
  }

  func onChange<T>(
    debounced debounceTime: Duration,
    of value: T,
    initial: Bool = false,
    _ action: @escaping @Sendable (_ oldValue: T, _ newValue: T) -> Void
  ) -> some View where T: Equatable {
    self.modifier(
      DebouncedChangeViewModifier(
        trigger: value,
        initial: initial,
        action: action,
        debounceDuration: debounceTime))
  }

  func onChange<T: Sendable>(
    debounced debounceTime: Duration,
    of value: T,
    initial: Bool = false,
    _ action: @escaping @Sendable () -> Void
  ) -> some View where T: Equatable {
    self.onChange(debounced: debounceTime, of: value, initial: initial) { _, _ in
      action()
    }
  }
}

private struct DebouncedChangeViewModifier<Value: Sendable>: ViewModifier where Value: Equatable {
  let trigger: Value
  let initial: Bool
  let action: @Sendable (Value, Value) -> Void
  let debounceDuration: Duration

  @State private var debouncedTask: Task<Void, Never>?

  func body(content: Content) -> some View {
    content.onChange(of: trigger, initial: initial) { lhs, rhs in
      debouncedTask?.cancel()
      debouncedTask = Task.delayed(for: debounceDuration) {
        action(lhs, rhs)
      }
    }
  }
}
