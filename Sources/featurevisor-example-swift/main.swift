import Foundation
import Featurevisor

let datafileURL = URL(string: "https://featurevisor-example-cloudflare.pages.dev/production/featurevisor-tag-all.json")!

let data = try Data(contentsOf: datafileURL)
let datafileContent = try DatafileContent.fromData(data)

let f = createInstance(
    InstanceOptions(
        datafile: datafileContent,
        context: [
            "userId": .string("123"),
            "deviceId": .string("device-23456"),
            "country": .string("nl")
        ]
    )
)

let featureIsEnabled = f.isEnabled("my_feature")
print("Feature is enabled: \(featureIsEnabled)")
