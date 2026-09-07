import XCTest
@testable import RatoFilesCore

final class RatoFilesTests: XCTestCase {
    func testSandboxPath() {
        let home = PermissionsManager.shared.getSandboxHomeDirectory()
        XCTAssertFalse(home.path.isEmpty)
    }
}
