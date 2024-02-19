# NetworkingKit

NetworkingKit is a modular Swift package designed to simplify networking tasks in iOS applications. With NetworkingKit, you can seamlessly integrate with backend APIs while maintaining clean, scalable, and testable code.

## Features

- **Modular Design**: NetworkingKit follows a modular architecture, allowing for easy organization and reuse of networking components.

- **Encapsulation**: Networking functionality is encapsulated within distinct modules, promoting separation of concerns and ensuring code clarity.

- **Flexible Integration**: Easily integrate with backend APIs using predefined interfaces tailored for specific features, such as OnboardingService for onboarding-related APIs.

- **Testability**: With clear abstractions and dependency injection, NetworkingKit facilitates unit testing of networking logic without the need for actual network requests.

## Usage

### OnboardingService

To interact with onboarding-related APIs, use the `OnboardingService` interface provided by NetworkingKit. Here's an example of how to register a user:

```swift
let onboardingService = OnboardingServiceProvider()

onboardingService.register(email: "example@email.com", password: "password123", name: "John Doe")
    .sink { completion in
        // Handle completion
    } receiveValue: { response in
        // Handle successful response
    }
    .store(in: &cancellables)
```

### Custom Endpoints

If you need to define custom endpoints, create a new endpoint conforming to the `APIEndpoint` protocol. Here's an example:

```swift
enum CustomEndpoint: APIEndpoint {
    case fetchData
    case postData(data: Data)

    var baseURL: URL {
        // Define base URL
    }

    var path: String {
        // Define endpoint path
    }

    var method: HTTPMethod {
        // Define HTTP method
    }

    var headers: [String: String]? {
        // Define headers
    }

    var body: Data? {
        // Define request body
    }
}
```

## Contributing

We welcome contributions to NetworkingKit! If you have any ideas, suggestions, or bug fixes, feel free to open an issue or submit a pull request.
