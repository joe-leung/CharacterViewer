//
//  SummaryViewController.swift
//  GenericViewer
//
//  Created by Joe Leung on 5/7/21.
//

import UIKit

protocol CharacterSelectionDelegate: class {
    func characterSelected(characterName: String, characterDetail: Dictionary<String, Any>)
}

class SummaryViewController: UITableViewController {
    
    private var dataSource: Array<Any> = []
    private var builder: DataSourceBuilder?
    private var characterDetail: Dictionary<String, Any> = [:]
    
    weak var delegate: CharacterSelectionDelegate?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let baseURL = Bundle.main.object(forInfoDictionaryKey: "ViewerAppBaseURL") as! String
        let query = Bundle.main.object(forInfoDictionaryKey: "ViewerAppQuery") as! String
        let sourceURL = baseURL + query

        self.builder = DataSourceBuilder(withURL: sourceURL)
        NotificationCenter.default.addObserver(self, selector: #selector(dataSourceUpdate), name: Notification.Name("PullDataTaskDone"), object: nil)
    }
    
    @objc func dataSourceUpdate() {
        guard let mybuilder = self.builder else {
            return
        }
        self.dataSource = mybuilder.getDataSource()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.dataSource.count
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        let dict = self.dataSource[indexPath.row] as! Dictionary<String, Any>
        let firstURLStr = dict["FirstURL"] as! String
        let url = URL(string: firstURLStr)
        let rawCharacterName = url?.lastPathComponent
        var characterName = ""
        rawCharacterName?.split(separator: "_").forEach {
            characterName += $0 + " "
        }
        cell.textLabel?.text = "\(indexPath.row) \(characterName)"
        cell.textLabel?.text = characterName
        return cell
    }
        
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        self.characterDetail = self.dataSource[indexPath.row] as! Dictionary<String, Any>
        delegate?.characterSelected(characterName: (cell?.textLabel!.text)!, characterDetail: self.characterDetail)
        if let detailViewController = delegate as? CharacterDetailViewController, let detailNavigationController = detailViewController.navigationController {
            splitViewController?.showDetailViewController(detailNavigationController, sender: nil)
        }
    }
    
}
