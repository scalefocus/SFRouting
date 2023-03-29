# SFRouting

Provides dynamic, programmable and unified approach to navigation in SwiftUI. All possible routes are predefined at compile time with an enum. The router object defines the current application path and contains methods for navigation. The following presentation styles are supported: 

- stack 
- full screen cover
- sheet
- half sheet

> Both iOS 15 and iOS 16 are supported.

## Installation

1. Add the *SFRouting* package in your project.
2. Define the application routes:

```Swift
import SFRouting

enum Routes: Hashable {
    case welcome
    case login
    case onboarding(OnboardingRoute)
}

typealias Router = SfRouter<Routes>
```

3. Set the router as an environment object:

```Swift
@main
struct ExampleApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(Router(.welcome))
        }
    }
}
```

4. Use the **SfRouterView** to define what view should be presented for the current *path*:

```Swift
@EnvironmentObject var router: Router

var body: some View {
    SfRouterView(router: router) { route in
        switch route {
            case .welcome: WelcomeView()
            case .login: LoginView()
            case .onboarding(let subRoute): OnboardingRootView(subRoute)
        }
    }
}
```

## Main functions:

```Swift
router.push(.networkError)                   // pushes a new route
router.pop()                                 // pops to the previous route
router.popToRoot()                           // pops to the root of the navigation stack
router.replaceRoot(.welcome, path: [.login]) // replaces the current path with a new root and a subpath (optional)
```

The default presentation style is **stack**. Use the **presentationMode** property to specify a different style:

```Swift
router.push(.createUser, presentationMode: .sheet)
router.push(.networkError, presentationMode: .fullScreen)
```

