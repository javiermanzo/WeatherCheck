import XCTest
import UIKit
@testable import RemoteImage

final class ImageLoaderTests: XCTestCase {

    var testURL: URL!

    override func setUp() {
        super.setUp()
        testURL = URL(string: "https://via.placeholder.com/150")! // Example URL
    }

    override func tearDown() {
        testURL = nil
        super.tearDown()
    }

    func testLoadImageFromNetwork() async throws {
        let resultImage = try await ImageLoader.shared.loadImage(from: testURL)
        XCTAssertNotNil(resultImage)
    }

    func testInvalidURLThrowsError() async throws {
        let invalidURL = URL(string: "https://invalid.url")!

        do {
            let _ = try await ImageLoader.shared.loadImage(from: invalidURL)
            XCTFail("Expected an error for an invalid URL, but the request succeeded.")
        } catch {
            // This is the expected behavior
            XCTAssertNotNil(error, "Expected an error to be thrown, but no error was found.")
        }
    }

}
