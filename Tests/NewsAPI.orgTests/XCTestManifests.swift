import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(NewsAPI_orgTests.allTests),
    ]
}
#endif
