import UIKit
@_exported import RatoFilesCore

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private var tableView: UITableView!
    private var currentURL: URL!
    private var fileItems: [URL] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Rato Files"
        view.backgroundColor = .systemBackground
        
        currentURL = PermissionsManager.shared.getDocumentsDirectory()
        
        setupNavBar()
        setupTableView()
        loadFiles()
    }
    
    private func setupNavBar() {
        navigationItem.rightBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showCreateFolderAlert))
        navigationItem.leftBarButton = UIBarButtonItem(title: "Raiz", style: .plain, target: self, action: #selector(goToRootSandbox))
    }
    
    private func setupTableView() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        view.addSubview(tableView)
    }
    
    private func loadFiles() {
        fileItems = FileManagerController.shared.contentsOfDirectory(at: currentURL)
        tableView.reloadData()
    }
    
    @objc private func goToRootSandbox() {
        currentURL = PermissionsManager.shared.getSandboxHomeDirectory()
        loadFiles()
    }
    
    @objc private func showCreateFolderAlert() {
        let alert = UIAlertController(title: "Rato Files - Novo", message: "Criar na Sandbox", preferredStyle: .alert)
        alert.addTextField { tf in tf.placeholder = "Nome" }
        
        alert.addAction(UIAlertAction(title: "Criar Pasta", style: .default, handler: { [weak self] _ in
            guard let self = self, let name = alert.textFields?.first?.text, !name.isEmpty else { return }
            let success = FileManagerController.shared.createDirectory(named: name, at: self.currentURL)
            if success { self.loadFiles() }
        }))
        
        alert.addAction(UIAlertAction(title: "Criar Arquivo", style: .default, handler: { [weak self] _ in
            guard let self = self, let name = alert.textFields?.first?.text, !name.isEmpty else { return }
            let success = FileManagerController.shared.createTestFile(at: self.currentURL, name: "\(name).txt", content: "Gerenciado por Rato Files")
            if success { self.loadFiles() }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        present(alert, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fileItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let itemURL = fileItems[indexPath.row]
        
        var isDir: ObjCBool = false
        FileManager.default.fileExists(atPath: itemURL.path, isDirectory: &isDir)
        
        cell.textLabel?.text = itemURL.lastPathComponent
        cell.imageView?.image = UIImage(systemName: isDir.boolValue ? "folder.fill" : "doc.text.fill")
        cell.accessoryType = isDir.boolValue ? .disclosureIndicator : .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let itemURL = fileItems[indexPath.row]
        
        var isDir: ObjCBool = false
        FileManager.default.fileExists(atPath: itemURL.path, isDirectory: &isDir)
        
        if isDir.boolValue {
            currentURL = itemURL
            loadFiles()
        } else {
            do {
                let content = try String(contentsOf: itemURL, encoding: .utf8)
                let alert = UIAlertController(title: itemURL.lastPathComponent, message: content, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Fechar", style: .default))
                present(alert, animated: true)
            } catch {
                let alert = UIAlertController(title: "Erro", message: "Não foi possível ler o arquivo.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                present(alert, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let itemURL = fileItems[indexPath.row]
            let success = FileManagerController.shared.removeItem(at: itemURL)
            if success {
                fileItems.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
    }
}
