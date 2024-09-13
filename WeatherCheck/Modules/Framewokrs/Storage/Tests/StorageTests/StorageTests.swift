import XCTest
@testable import Storage

final class StorageTests: XCTestCase {
    var storage: Storage!

    override func setUp() {
        super.setUp()
        storage = Storage(identifier: "com.yourapp.test")
        storage.clear()
    }

    override func tearDown() {
        storage.clear()
        super.tearDown()
    }

    func testAddAndRetrieveValue() {
        let testValue = "TestString"
        storage.add(value: testValue, forKey: "testKey")

        let retrievedValue: String? = storage.value(forKey: "testKey", type: String.self)
        XCTAssertEqual(retrievedValue, testValue)
    }

    func testRemoveValue() {
        let testValue = "TestString"
        storage.add(value: testValue, forKey: "testKey")
        storage.removeValue(forKey: "testKey")

        let retrievedValue: String? = storage.value(forKey: "testKey", type: String.self)
        XCTAssertNil(retrievedValue)
    }

    func testClearStorage() {
        let testValue = "TestString"
        storage.add(value: testValue, forKey: "testKey")
        storage.clear()

        let retrievedValue: String? = storage.value(forKey: "testKey", type: String.self)
        XCTAssertNil(retrievedValue)
    }

    func testAddAndRetrieveCustomObject() {
        struct TestModel: Codable, Equatable {
            let name: String
            let age: Int
        }

        let testObject = TestModel(name: "Javier", age: 33)
        storage.add(value: testObject, forKey: "testModelKey")

        let retrievedObject: TestModel? = storage.value(forKey: "testModelKey", type: TestModel.self)
        XCTAssertEqual(retrievedObject, testObject)
    }
}
