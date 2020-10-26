# ZISO8601DateFormatter

ISO8601DateFormatter alternative, upon DateFormatter.

How to formatter `2020-10-25T14:07:21.000Z`

```swift
let formatter = ZISO8601DateFormatter()
formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
let date = formatter.date(from: "2020-10-25T14:07:21.000Z")
```
