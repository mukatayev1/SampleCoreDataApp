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

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Core Data practice"
        navigationController?.navigationBar.prefersLargeTitles = true
        setTableView()
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
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MyCell.identifier, for: indexPath) as! MyCell
        cell.configure(text: "iPhone")
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
}

