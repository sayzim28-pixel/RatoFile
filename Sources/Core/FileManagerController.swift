import Foundation

public class FileManagerController {
    public static let shared = FileManagerController()
    private init() {}
    
    public func contentsOfDirectory(at url: URL) -> [URL] {
        let fm = FileManager.default
        do {
            let items = try fm.contentsOfDirectory(at: url, includingPropertiesForKeys: [.isDirectoryKey, .fileSizeKey], options: [.skipsHiddenFiles])
            return items
        } catch {
            print("Erro ao ler diretório \(url.path): \(error.localizedDescription)")
            return []
        }
    }
    
    public func createDirectory(named name: String, at parentURL: URL) -> Bool {
        let newDirURL = parentURL.appendingPathComponent(name)
        let fm = FileManager.default
        do {
            try fm.createDirectory(at: newDirURL, withIntermediateDirectories: true, attributes: nil)
            return true
        } catch {
            print("Erro ao criar pasta: \(error)")
            return false
        }
    }
    
    public func removeItem(at url: URL) -> Bool {
        let fm = FileManager.default
        do {
            try fm.removeItem(at: url)
            return true
        } catch {
            print("Erro ao remover item: \(error)")
            return false
        }
    }
    
    public func createTestFile(at parentURL: URL, name: String, content: String) -> Bool {
        let fileURL = parentURL.appendingPathComponent(name)
        do {
            try content.write(to: fileURL, atomically: true, encoding: .utf8)
            return true
        } catch {
            print("Erro ao gravar arquivo: \(error)")
            return false
        }
    }
}
