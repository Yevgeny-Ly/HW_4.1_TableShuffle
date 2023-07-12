//
//  ViewController.swift
//  HW #4 testShuffle
//
//  Created by Евгений Л on 10.07.2023.
//

import UIKit

final class TableVC: UIViewController {
    
    private var data: [String]     = []
    private var selected: [String] = []
    
    private let tableView: UITableView         = {
        let tableView                          = UITableView(frame: .zero, style: .insetGrouped)
        tableView.backgroundColor              = .white
        tableView.allowsMultipleSelection      = true
        tableView.bounces                      = false
        tableView.showsVerticalScrollIndicator = false
        tableView.layer.cornerRadius           = 10
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var dataSource: UITableViewDiffableDataSource<String, String> = {
        return UITableViewDiffableDataSource<String, String>(tableView: tableView) { tableView, indexPath, itemIdentifier in
            let cell              = tableView.dequeueReusableCell(withIdentifier: "cell")
            cell?.textLabel?.text = itemIdentifier
            cell?.accessoryType   = self.selected.contains(itemIdentifier) ? .checkmark : .none
            return cell
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupUI()
        numbersArray()
        updateData(data, animated: true)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barTintColor = .white.withAlphaComponent(0.9)
    }
    
    private func setupNavigation() {
        let shuffleItem = UIBarButtonItem(title: "Shuffle", style: .done, target: self, action: #selector(shuffleTapped))
        navigationController?.navigationBar.topItem?.rightBarButtonItems = [shuffleItem]
        
        let standardAppearance                 = UINavigationBarAppearance()
        standardAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        standardAppearance.configureWithOpaqueBackground()
        standardAppearance.backgroundColor     = .white

        self.navigationController?.navigationBar.standardAppearance   = standardAppearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = standardAppearance
    }
    
    private func setupUI() {
        title = "Task 4"
        view.backgroundColor = .white.withAlphaComponent(0.9)
        tableView.delegate = self
        view.addSubview(tableView)
    }
    
    private func numbersArray() {
        for i in 1...30 {
            data.append("\(i)")
        }
    }
    
    private func updateData(_ data: [String], animated: Bool) {
        var snapshot = NSDiffableDataSourceSnapshot<String, String>()
        snapshot.appendSections(["first"])
        snapshot.appendItems(data, toSection: "first")
        dataSource.apply(snapshot, animatingDifferences: animated)
    }
    
    private func setupLayout() {
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    @objc
    private func shuffleTapped() {
        updateData(data.shuffled(), animated: true)
    }
}

extension TableVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let item = dataSource.itemIdentifier(for: indexPath) {
            if self.selected.contains(item) {
                selected = selected.filter { $0 != item }
                tableView.cellForRow(at: indexPath)?.accessoryType = .none
            } else {
                selected.append(item)
                tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
                
                if let first = dataSource.snapshot().itemIdentifiers.first, first != item {
                    var snapshot = dataSource.snapshot()
                    snapshot.moveItem(item, beforeItem: first)
                    dataSource.apply(snapshot)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
}

