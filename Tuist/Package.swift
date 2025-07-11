// swift-tools-version: 6.0
import PackageDescription

#if TUIST
  import struct ProjectDescription.PackageSettings

  let packageSettings = PackageSettings(
    productTypes: [:]
  )
#endif

let package = Package(
  name: "Cardtier",
  dependencies: [
    .package(path: "https://github.com/SimplyDanny/SwiftLintPlugins")
  ]
)
