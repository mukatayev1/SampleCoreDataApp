//
//  ViewController.swift
//  CoreDataPractice
//
//  Created by Aidos Mukatayev on 2022/04/19.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    // MARK: - Properties
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private let coreDataManager = CoreDataManager.shared
    private var people = [Person]()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        setTableView()
        setRightBarButton()
        
        fetchData()
    }
    
    // MARK: - Set
    private func setNavigationBar() {
        title = "Core Data practice"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
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
    
    // MARK: - View Logic
    private func didTapAdd(_ name: String) {
        savePersonToCoreData(with: name)
    }
    
    private func didSwipeToDelete(at index: Int) {
        guard let person = people[safe: index] else { return }
        deletePersonFromCoreData(person)
    }
    
    private func didSwipeToEdit(at index: Int) {
        let ac = UIAlertController(title: "Edit person's name", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        guard let textField = ac.textFields?[0],
              let person = people[safe: index],
              let name = person.name else { return }
        textField.text = name
        
        //Save action
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let text = textField.text,
                  !text.isEmpty,
                  text != name else { return }
            person.name = text
            self.updatePersonToCoreData(person: person)
        }
        ac.addAction(saveAction)
        
        //Cancel action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        ac.addAction(cancelAction)
        
        DispatchQueue.main.async {
            self.present(ac, animated: true)
        }
    }
    
    private func showPersonDetails(at index: Int) {
        guard let person = people[safe: index],
              let name = person.name else { return }
        presentBasicAlert(title: "Person Details", message: name)
    }
    
    // MARK: - CoreData logic
    private func fetchData() {
        people = coreDataManager.fetchPeople()
        
        DispatchQueue.main.async {
            self.tableView.reloadSections([0], with: .fade)
        }
    }
    
    private func savePersonToCoreData(with name: String) {
        coreDataManager.saveNewPerson(name) { [weak self] error in
            guard let self = self else { return }
            
            if let error = error {
                fatalError(error.description)
            } else {
                self.fetchData()
            }
        }
    }
    
    private func deletePersonFromCoreData(_ person: Person) {
        coreDataManager.deletePerson(person) { [weak self] error in
            guard let self = self else { return }
            
            if let error = error {
                fatalError(error.description)
            } else {
                self.fetchData()
            }
        }
    }
    
    private func updatePersonToCoreData(person: Person) {
        coreDataManager.updatePerson(person: person) { [weak self] error in
            guard let self = self else { return }
            
            if let error = error {
                fatalError(error.description)
            } else {
                self.fetchData()
            }
        }
    }
    
    // MARK: - Selectors
    @objc private func didTapPlus() {
        let ac = UIAlertController(title: "Enter new person name", message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Add", style: .default) { [unowned ac] _ in
            guard let textField = ac.textFields?[0],
                  let text = textField.text,
                  !text.isEmpty else { return }
            self.didTapAdd(text)
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
            self.didSwipeToDelete(at: indexPath.row)
            completionHandler(true)
        }
        let swipeActionConfig = UISwipeActionsConfiguration(actions: [delete])
        return swipeActionConfig
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let edit = UIContextualAction(style: .normal, title: "Edit") { (action, sourceView, completionHandler) in
            self.didSwipeToEdit(at: indexPath.row)
            completionHandler(true)
        }
        let swipeActionConfig = UISwipeActionsConfiguration(actions: [edit])
        return swipeActionConfig
    }
}

// MARK: - TableView DataSource
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MyCell.identifier, for: indexPath) as! MyCell
        
        if let person = people[safe: indexPath.row], let name = person.name {
            cell.configure(text: name)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
}

