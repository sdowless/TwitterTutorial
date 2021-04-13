//
//  MenuController.swift
//  TwitterTutorial
//
//  Created by Stephen Dowless on 3/25/20.
//  Copyright © 2020 Stephan Dowless. All rights reserved.
//

import UIKit

protocol MenuControllerDelegate: class {
    func didSelect(option: MenuOptions)
}

enum MenuOptions: Int, CustomStringConvertible, CaseIterable {
    case profile
    case lists
    case logout
    
    var description: String {
        switch self {
        case .profile: return "Profile"
        case .lists: return "Lists"
        case .logout: return "Logout"
        }
    }
    
    var image: UIImage {
        switch self {
        case .profile: return #imageLiteral(resourceName: "ic_person_outline_white_2x")
        case .lists: return #imageLiteral(resourceName: "ic_menu_white_3x")
        case .logout: return #imageLiteral(resourceName: "baseline_arrow_back_white_24dp")
        }
    }
}

private let reuseIdentifer = "MenuOptionCell"

class MenuController: UIViewController {
    
    // MARK: - Properties
    
    private var user: User
    weak var delegate: MenuControllerDelegate?
    private var tableView = UITableView()
    
    private lazy var headerView: MenuHeader = {
        let frame = CGRect(x: 0, y: 0, width: self.view.frame.width - 80, height: 180)
        let view = MenuHeader(frame: frame)
        view.user = user
        return view
    }()
    
    // MARK: - Lifecycle
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .twitterBlue
        
        tableView.register(MenuOptionCell.self, forCellReuseIdentifier: reuseIdentifer)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .twitterBlue
        tableView.separatorStyle = .none
        tableView.rowHeight = 72
        tableView.tableHeaderView = headerView
        
        view.addSubview(tableView)
        tableView.addConstraintsToFillView(view)
    }
}

// MARK: - UITableViewDelegate/DataSource

extension MenuController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuOptions.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifer, for: indexPath) as! MenuOptionCell
        let option = MenuOptions(rawValue: indexPath.row)
        cell.option = option
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let option = MenuOptions(rawValue: indexPath.row) else { return }
        delegate?.didSelect(option: option)
    }
}
