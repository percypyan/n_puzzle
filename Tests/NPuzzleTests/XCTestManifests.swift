import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(n_puzzleTests.allTests),
    ]
}
#endif
