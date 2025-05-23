import ProjectDescription

let project = Project(
    name: "Cardtier",
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
                    ],
                ]
            ),
            sources: ["Cardtier/Sources/**"],
            resources: ["Cardtier/Resources/**"],
            dependencies: []
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
