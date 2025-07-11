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
      infoPlist: .extendingDefault(
        with: [
          "UILaunchScreen": [
            "UIColorName": "",
            "UIImageName": "",
          ]
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
