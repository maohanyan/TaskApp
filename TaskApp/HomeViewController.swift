//
//  HomeViewController.swift
//  TaskApp
//
//  Created by Mariam Ohanyan on 28.07.22.
//

import UIKit

struct Info: Decodable {
    var seed: String
    var results: Int
    var page: Int
    var version: String
}


struct Result: Decodable {
    var users: [User]
    var info: Info
    
    private enum CodingKeys: String, CodingKey {
        case users = "results"
        case info
    }
}


class HomeViewController: UIViewController, UsersTableViewManagerDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var usersTable: UITableView!
    @IBOutlet weak var savedUsersTable: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    private var usersTVManager: UsersTableViewManager!
    private var savedUsersTVManager: UsersTableViewManager!
    private var curPage = 1
    private let perPage = 20
    private var selectedUser: UserProtocol!
    
    //
    private enum ScreenMode {
        case users
        case savedUsers
    }
    private var screenMode = ScreenMode.users {
        didSet {
            switch screenMode {
            case .users:
                savedUsersTable.isHidden = true
                usersTable.isHidden = false
                
            case .savedUsers:
                savedUsersTable.isHidden = false
                usersTable.isHidden = true
            }
        }
    }
    
    //MARK: - IBActions
    @IBAction func doChangeTab(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            screenMode = .users
        case 1:
            screenMode = .savedUsers
        default:
            break
        }
    }
    
    //MARK: - UISearchBarDelegate
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        usersTVManager.endSearch()
        savedUsersTVManager.endSearch()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            usersTVManager.endSearch()
            savedUsersTVManager.endSearch()
        } else if (searchText.count >= 3) {
            let usersSearchResult = ResourceManager.shared.users.filter{$0.email.lowercased().starts(with: searchText.lowercased())}
            usersTVManager.searchResult(data: usersSearchResult)
            let savedUsersSearchResult = UserEntityManager.shared.search(text: searchText.lowercased())
            savedUsersTVManager.searchResult(data: savedUsersSearchResult)
        }
    }
    
    //MARK: - UsersTableViewManagerDelegate
    func loadMore() {
        loadUsersList()
    }
    
    func selectItem(item: UserProtocol) {    
        selectedUser = item
        self.performSegue(withIdentifier: "sgu_userDetails", sender: nil)
    }
    
    //MARK: - class lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        screenMode = .users
        
        segmentedControl.setTitle(StringConstants.user, forSegmentAt: 0)
        segmentedControl.setTitle(StringConstants.savedUsers, forSegmentAt: 1)
        
        searchBar.placeholder = StringConstants.search
        usersTVManager = UsersTableViewManager.init(with: usersTable)
        usersTVManager.delegate = self
        
        savedUsersTVManager = UsersTableViewManager.init(with: savedUsersTable, infiniteLoad: false)
        savedUsersTVManager.delegate = self
        
        searchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
        loadUsersList()
        loadSavedUsersList()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        searchBar.resignFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destVC = segue.destination as? UserDetailsViewContrller {
            destVC.user = selectedUser
        }
    }
    
    //MARK: - class helpers
    private func loadUsersList() {
        var page = 1
        if let info = ResourceManager.shared.info {
            page = info.page + 1
        }
        NetworkManager.shared.getUser(perPage: page, page: curPage) { result, succeeded in
            if succeeded {
                self.curPage += 1
                DispatchQueue.main.async {[weak self] in
                    self?.usersTVManager.reloadData(data: result!.users)
                }
//                print(result)
            }
        }
    }
    
    private func loadSavedUsersList() {
        let savedUsers = UserEntityManager.shared.fetchAll()
        savedUsersTVManager.reloadData(data: savedUsers!)
    }
}

