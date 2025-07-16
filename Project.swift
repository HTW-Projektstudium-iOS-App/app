import ProjectDescription

let project = Project(
  name: "Cardtier",
  packages: [
    .remote(
      url: "https://github.com/SimplyDanny/SwiftLintPlugins",
      requirement: .upToNextMajor(from: "0.59.1")
    )
  ],
  targets: [
    .target(
      name: "Cardtier",
      destinations: .iOS,
      product: .app,
      bundleId: "io.tuist.Cardtier",
      deploymentTargets: .iOS("18.0"),
      infoPlist: .extendingDefault(
        with: [
          "UILaunchStoryboardName": "LaunchScreen",

          "NSLocalNetworkUsageDescription":
            "Wird benötigt, um mit anderen Geräten in der Nähe zu interagieren.",
          "NSBonjourServices": ["_htw-cardtier._tcp.", "_htw-cardtier._udp."],
        ]
      ),
      sources: ["Cardtier/Sources/**"],
      resources: ["Cardtier/Resources/**"],
      dependencies: [
        .package(product: "SwiftLintBuildToolPlugin", type: .plugin)
      ]
    ),
    .target(
      name: "CardtierTests",
      destinations: .iOS,
      product: .unitTests,
      bundleId: "io.tuist.CardtierTests",
      infoPlist: .default,
      sources: ["Cardtier/Tests/**"],
      resources: [],
      dependencies: [.target(name: "Cardtier")]
    ),
  ]
)
