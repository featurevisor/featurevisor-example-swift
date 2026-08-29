import Featurevisor
import Foundation

let datafileURL = URL(
    string: "https://featurevisor-example-cloudflare.pages.dev/production/featurevisor-sdk-v3.json"
)!

var request = URLRequest(url: datafileURL)
request.timeoutInterval = 10
request.setValue("application/json", forHTTPHeaderField: "Accept")

let (data, response) = try await URLSession.shared.data(for: request)
guard let httpResponse = response as? HTTPURLResponse,
      (200..<300).contains(httpResponse.statusCode) else {
    throw URLError(.badServerResponse)
}

let datafile = try DatafileContent.fromData(data)
let f = createFeaturevisor(
    FeaturevisorOptions(
        datafile: datafile,
        context: [
            "userId": .string("customer-123"),
            "country": .string("nl"),
            "locale": .string("nl-NL"),
            "accountPlan": .string("pro")
        ],
        logLevel: .error
    )
)

let commerceEnabled = f.isEnabled("commerce_platform")
let checkoutVariation = f.getVariation("checkout_experience")
let maxItems = f.getVariableInteger("checkout_experience", "max_items")
let paymentMethods = f.getVariableArray("checkout_experience", "payment_methods")
let endpoints = f.getVariableObject("serviceEndpoints")
let supportContact = f.getVariableString("supportContact")

let methods = paymentMethods?
    .compactMap { $0.asString() }
    .joined(separator: ", ") ?? ""
let baseURL = endpoints?["baseUrl"]?.asString() ?? "unavailable"
let timeoutMS = endpoints?["timeoutMs"]?.asInt() ?? 0
let retries = endpoints?["retries"]?.asInt() ?? 0

print("Commerce platform enabled: \(commerceEnabled)")
print("Checkout variation: \(checkoutVariation ?? "unavailable")")
print("Maximum checkout items: \(maxItems.map(String.init) ?? "unavailable")")
print("Payment methods: [\(methods)]")
print("Service endpoint: \(baseURL) (timeout: \(timeoutMS) ms, retries: \(retries))")
print("Support contact: \(supportContact ?? "unavailable")")

f.close()
