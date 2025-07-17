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

          "NSContactsUsageDescription": "Used to save cards to your contacts.",

          "NSLocationWhenInUseUsageDescription":
            "Used to record the location where business cards are received.",

          "NSLocalNetworkUsageDescription":
            "Used to exchange cards with devices nearby.",
          "NSNearbyInteractionUsageDescription":
            "Used to exchange cards with devices nearby.",
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
