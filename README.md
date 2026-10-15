# GoodRun iOS

## Setup

Install SwiftLint: 

```
brew install swiftlint
```

## Before opening a PR

CI will run formattnig, linting and building so run these locally first:


These will fix what they can automatically.
```
xcrun swift-format format --in-place --recursive GoodRun GoodRunTests
swiftlint --fix
```

Anything this still talks about will need to be fixed manually
```
swiftlint lint --strict
```
