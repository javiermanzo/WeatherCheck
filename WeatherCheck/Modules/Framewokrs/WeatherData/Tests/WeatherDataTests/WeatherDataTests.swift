import XCTest
@testable import WeatherData

final class WeatherDataTests: XCTestCase {

    override func setUp() {
        super.setUp()
        WeatherData.setUpApiKey("API_KEY")
    }

    override func tearDown() {
        super.tearDown()
    }

    func testRequestWeather() async throws {
        let latitude = -34.6037
        let longitude = -58.3816

        let response = await WeatherData.requestWeather(latitude: latitude, longitude: longitude, details: true)

        switch response {
        case .success(let result):
            XCTAssertNotNil(result, "Expected a valid weather response, got nil.")
        default:
            XCTFail("Request failed")
        }
    }

    func testRequestWeatherWithInvalidApiKey() async throws {
        WeatherData.setUpApiKey("INVALID_API_KEY")
        let latitude = -34.6037
        let longitude = -58.3816

        let response = await WeatherData.requestWeather(latitude: latitude, longitude: longitude, details: true)

        switch response {
        case .error(let error):
            XCTAssertNotNil(error, "Expected request to fail with an error, but it did not.")
        default:
            XCTFail("Expected the request to fail with an invalid API key, but it succeeded.")
        }
    }
}
