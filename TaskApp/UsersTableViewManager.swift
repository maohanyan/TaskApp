//
//  UsersTableViewManager.swift
//  TaskApp
//
//  Created by Mariam Ohanyan on 29.07.22.
//

import UIKit
import Kingfisher

protocol UsersTableViewManagerDelegate {
    func loadMore()
    func selectItem(item: UserProtocol)
}

class UsersTableViewManager:NSObject, UITableViewDelegate, UITableViewDataSource {
    var delegate: UsersTableViewManagerDelegate!
    
    private enum ScreenMode {
        case main
        case search
    }
    private var screenMode: ScreenMode = .main
    
    private let celIdentifier = "userCellIdent"
    private let loadingCelIdentifier = "loadingCellIdent"
    private var tableView: UITableView!
    private var mainFeed = [UserProtocol]() {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()              
                self?.hideBottomLoader()
            }
        }
    }
    private var searchFeed: [UserProtocol]?
    private var withInfiniteLoad:Bool = false
    
    
    //MARK: -
    init(with table: UITableView, infiniteLoad: Bool = true) {
        super.init()
        self.tableView = table
        self.tableView.register(UINib.init(nibName: "UserCell", bundle: nil), forCellReuseIdentifier: celIdentifier)
        self.tableView.register(UINib.init(nibName: "LoadingCell", bundle: nil), forCellReuseIdentifier: loadingCelIdentifier)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.withInfiniteLoad = infiniteLoad
    }
    
    func reloadData(data: [UserProtocol]) {
        if withInfiniteLoad {
            mainFeed.append(contentsOf: data)
        } else {
            mainFeed = data
        }
    }
    
    func searchResult(data: [UserProtocol]) {
        screenMode = .search
        searchFeed = data
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    func endSearch() {
        screenMode = .main
        searchFeed = nil
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    //MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        if screenMode == .search {
            return 1
        }
        if withInfiniteLoad {
            return 2
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if screenMode == .search {
            return searchFeed!.count
        }
        switch section {
        case 0:
            return mainFeed.count
            
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: celIdentifier, for: indexPath) as! UserCell
        if screenMode == .search {
            cell.setupCell(data: searchFeed![indexPath.row])
            return cell
        }
        
        switch indexPath.section {
        case 0:
            cell.setupCell(data: mainFeed[indexPath.row])
                
        default:
            return tableView.dequeueReusableCell(withIdentifier: loadingCelIdentifier, for: indexPath)
        }
        return cell
    }
    
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if let dlg = self.delegate {
                dlg.loadMore()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if indexPath.section == 0 {
            var selectedUser: UserProtocol!
            if screenMode == .search {
                selectedUser = searchFeed![indexPath.row]
            } else {
                selectedUser = mainFeed[indexPath.row]
            }
            delegate.selectItem(item: selectedUser!)
        }
    }
    
    //MARK: - Class helpers
    private func hideBottomLoader() {
        DispatchQueue.main.async {
            let lastListIndexPath = IndexPath(row: self.mainFeed.count - 1, section: 0)
            self.tableView.scrollToRow(at: lastListIndexPath, at: .bottom, animated: true)
        }
    }
}
