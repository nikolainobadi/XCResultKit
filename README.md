
# XCResultKit

![](https://badgen.net/badge/platform/macos?list=|&color=grey)
![](https://badgen.net/badge/distro/SPM%20only?color=red)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Overview

XCResultKit is a Swift package designed to parse and extract information from Xcode result bundles (`.xcresult` files). It provides a streamlined way to gather continuous integration (CI) results, including build, test actions, and test failures, making it easier to analyze and report CI outcomes. This package leverages SwiftShell for running command line commands and integrates with my personal Swift package, NnTestKit, for unit testing.

## Features

- Extract CI results from `.xcresult` files.
- Parse and represent build, test actions, and test failures.
- Designed for easy integration into CI pipelines.
- Extensible architecture for future enhancements.

## Installation

### Swift Package Manager

To integrate XCResultKit into your project using Swift Package Manager, add the following to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/nikolainobadi/XCResultKit", branch: "main"),
],
```

Then, add `XCResultKit` to your target's dependencies:

```swift
.target(
    name: "YourTargetName",
    dependencies: [
        .product(name: "XCResultKit", package: "XCResultKit"),
    ]
)
```

## Usage

### Extracting CI Results

```swift
import XCResultKit

let resultManager = CIResultManager()
if let ciResult = resultManager.extractResults(xcresultPath: "/path/to/your.xcresult") {
    // Use ciResult to access actions and test results
    ciResult.actions.forEach {
        print("\($0.type.name) didSucceed: \($0.didSucceed)")
        if let runTime = $0.runTime {
            print("runTime: \(runTime)")
        }
    }
    
    if let testResult = result?.testResult {
        print("totalTests: \(testResult.totalTests)")
    }
}
```

### Example Output

The `CIResult` structure provides detailed information about the CI actions and test results, including:

- Actions (clean, build, test) with success status and time intervals.
- Test results with the total number of tests and details about failed test cases.

## Documentation

Inline documentation is provided within the source code for detailed explanations of each component and its usage. For more information, refer to the source files:

- `ShellAdapter.swift`
- `CIResult.swift`
- `XCResultJSON.swift`
- `Int+Extensions.swift`
- `CIResultManager.swift`
- `TestResultMapper.swift`
- `ActionInfoMapper.swift`

## Contributing

I am open to contributions! If you have ideas, enhancements, or bug fixes, feel free to open an issue or submit a pull request. Please ensure that your code adheres to the existing coding standards and includes appropriate documentation and tests.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Future Plans

I plan to expand XCResultKit to include more detailed information about code coverage in future releases. Stay tuned for updates!

## Contact

Feel free to reach out if you have any questions or need further assistance. You can contact me via [GitHub](https://github.com/nikolainobadi).
