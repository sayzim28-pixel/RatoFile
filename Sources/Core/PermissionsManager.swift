import Foundation
import UIKit

public class PermissionsManager {
    public static let shared = PermissionsManager()
    
    private init() {}
    
    public func checkSandboxAccess() -> Bool {
        let docs = getDocumentsDirectory()
        return FileManager.default.isWritableFile(atPath: docs.path)
    }
    
    public func getSandboxHomeDirectory() -> URL {
        return URL(fileURLWithPath: NSHomeDirectory())
    }
    
    public func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    public func getCachesDirectory() -> URL {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
    }
}
