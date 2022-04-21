//
//  ViewController.swift
//  CoreDataPractice
//
//  Created by Aidos Mukatayev on 2022/04/19.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    private var items = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Core Data practice"
        navigationController?.navigationBar.prefersLargeTitles = true
        setTableView()
        setRightBarButton()
    }
    
    // MARK: - Set
    private func setTableView() {
        view.addSubview(tableView)
        tableView.rowHeight = 100
        tableView.register(MyCell.self, forCellReuseIdentifier: MyCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setRightBarButton() {
        let plusIcon = UIImage(systemName: "plus")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: plusIcon, style: .plain, target: self, action: #selector(didTapPlus))
    }
    
    // MARK: - Logic
    private func saveNewPerson(_ name: String) {
        appendName(name)
        saveNameToDB(name)
    }
    
    private func deletePerson(at index: Int) {
        guard let nameText = items[safe: index] else { return }
        removeName(at: index)
        deleteNameFromDB(nameText)
    }
    
    private func editPerson(at index: Int) {
        let ac = UIAlertController(title: "Enter edited person name", message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Edit", style: .default) { [unowned ac] _ in
            guard let textField = ac.textFields?[0], let text = textField.text, !text.isEmpty else { return }
            self.insertName(name: text, at: index)
        }
        
        ac.addAction(submitAction)
        ac.addAction(cancelAction)
        
        DispatchQueue.main.async {
            self.present(ac, animated: true)
        }
    }
    
    private func showPersonDetails(at index: Int) {
        guard let nameText = items[safe: index] else { return }
        presentBasicAlert(title: "Person Details", message: nameText)
    }
    
    // MARK: - Array
    private func appendName(_ name: String) {
        items.append(name)
        DispatchQueue.main.async {
            self.tableView.reloadSections([0], with: .automatic)
        }
    }
    
    private func removeName(at index: Int) {
        items.remove(at: index)
        DispatchQueue.main.async {
            self.tableView.reloadSections([0], with: .automatic)
        }
    }
    
    private func insertName(name: String, at index: Int) {
        items.remove(at: index)
        items.insert(name, at: index)
        DispatchQueue.main.async {
            self.tableView.reloadSections([0], with: .automatic)
        }
    }
    
    // MARK: - DB
    private func deleteNameFromDB(_ name: String) {
        print("DEBUGGG: DeleteName \(name)")
    }
    
    private func saveNameToDB(_ name: String) {
        print("DEBUGGG: SaveName \(name)")
    }
    
    // MARK: - Selectors
    @objc private func didTapPlus() {
        let ac = UIAlertController(title: "Enter new person name", message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Add", style: .default) { [unowned ac] _ in
            guard let textField = ac.textFields?[0], let text = textField.text, !text.isEmpty else { return }
            self.saveNewPerson(text)
        }
        
        ac.addAction(submitAction)
        ac.addAction(cancelAction)
        
        DispatchQueue.main.async {
            self.present(ac, animated: true)
        }
    }
}

// MARK: - TableViewDelegate
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        showPersonDetails(at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completionHandler) in
            self.deletePerson(at: indexPath.row)
            completionHandler(true)
        }
        let swipeActionConfig = UISwipeActionsConfiguration(actions: [delete])
        return swipeActionConfig
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .normal, title: "Edit") { (action, sourceView, completionHandler) in
            self.editPerson(at: indexPath.row)
            completionHandler(true)
        }
        let swipeActionConfig = UISwipeActionsConfiguration(actions: [delete])
        return swipeActionConfig
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MyCell.identifier, for: indexPath) as! MyCell
        if let nameText = items[safe: indexPath.row] {
            cell.configure(text: nameText)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
}

