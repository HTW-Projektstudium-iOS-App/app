import Foundation

extension Task {
  @discardableResult
  static func delayed(
    for duration: Duration = .seconds(1),
    operation: @escaping @Sendable () async -> Void
  ) -> Self where Success == Void, Failure == Never {
    Self {
      do {
        try await Task<Never, Never>.sleep(for: duration)
        await operation()
      } catch {}
    }
  }
}
