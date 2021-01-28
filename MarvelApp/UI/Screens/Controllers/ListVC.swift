//
//  ListVC.swift
//  MarvelApp
//
//  Created by zeyad on 1/27/21.
//  Copyright © 2021 zeyad. All rights reserved.
//

import UIKit
/*
 i builded the ui programmaticly to prove my skills in using uikit elements , constraint system and autolayout system
 whiout using GUI of either storyboard or XIB files
 */
class ListVC: DataLoadingVC {
    
    //MARK:- UI + Vars
    let tableView = UITableView(frame: .zero)
    let searchBar = UISearchBar()
    
    var presenter: ListPresenter?
    
    //MARK:- Datasource
    var realmCharcters = [RCharcter]() //array of cached objects
    var apiCharcter = [MCharcter]()   // the array comes from api call
    
    //MARK:- Pagination
    var offset = 0
    var isLoading = false
    var hasMore = true
    
    //MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setSearchBar()
        configureUI()
        layoutUI()
        self.presenter = ListPresenter(delegate: self)
    }
    
    //MARK:- UI layout and configurations
    private func layoutUI(){
        self.title = "Marvel"
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func configureUI(){
        tableView.register(CharcterCell.self, forCellReuseIdentifier: CharcterCell.reuseID)
        tableView.backgroundColor = .red
        tableView.rowHeight = 250
        tableView.separatorStyle = .singleLine
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = searchBar
    }
    
    private func setSearchBar(){
        searchBar.delegate = self
        searchBar.frame = CGRect(x: 0, y: 0, width: 200, height: 70)
        searchBar.showsCancelButton = false
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.placeholder = " Search Here....."
        searchBar.tintColor = .black
        searchBar.sizeToFit()
    }
    
    //MARK:- Instanse Methods
    private func appendNewCharcters(charcters:[MCharcter]){
        for charcter in charcters {
            self.appendNewItem(charcter)
        }
    }
    
    //This func to insert updates to tableview with out need to reload the whole tableView data to enhance scrolling
    private func appendNewItem(_ charcter: MCharcter) {
        DispatchQueue.main.async {
            self.apiCharcter.append(charcter)
            let selectedIndexPath = IndexPath(row: self.apiCharcter.count - 1, section: 0)
            self.tableView.beginUpdates()
            self.tableView.insertRows(at: [selectedIndexPath], with: .automatic)
            self.tableView.endUpdates()
        }
    }
    
    private func showEmptyState(){
        if self.apiCharcter.count == 0 && self.realmCharcters.count == 0 {
            self.showEmptyStateView()
        }
    }
}
//MARK:- TableView
extension ListVC: UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if apiCharcter.count == 0 {
            return realmCharcters.count
        }else {
            return apiCharcter.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CharcterCell.reuseID, for: indexPath) as! CharcterCell
        if apiCharcter.count == 0 {
            cell.set(with: self.realmCharcters[indexPath.row])
        }else {
            cell.set(with: self.apiCharcter[indexPath.row])
        }
        return cell
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if apiCharcter.count != 0 {
            let contentHeight = scrollView.contentSize.height
            let height = scrollView.frame.height
            let offsetY = scrollView.contentOffset.y
            if offsetY > contentHeight - height {
                guard hasMore , !isLoading else {return}
                offset += 20
                self.presenter?.getCharcters(searchText: nil, offset: self.offset)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 0.4) {
            cell.transform = CGAffineTransform.identity
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if apiCharcter.count == 0 {
            self.presentAlertOnMainThread(title: "No Internet", messaeg: "You have to connect to Internet", buttonTitle: "ok")
        }else {
            let charcter = self.apiCharcter[indexPath.row]
            let vc = DetailsVC()
            vc.character = charcter
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
//MARK:- Presenter
extension ListVC: ListDelegate {
    func showProgressView() {
        self.showLoadingView()
        isLoading = true
    }
    
    func hideProgressView() {
        self.dismissLoadingView()
        isLoading = false
    }
    
    func requestSucceed(charcters: [MCharcter]) {
        DispatchQueue.main.async {
            if charcters.count < 20 {
                self.hasMore = false
            }
            self.tableView.reloadData()
            self.appendNewCharcters(charcters: charcters)
        }
    }
    
    func requestDidFailed(message: String) {
        self.presentAlertOnMainThread(title: "Server error", messaeg: message, buttonTitle: "OK")
        self.showEmptyState()
    }
    
    func dataRetrieved(charcters: [RCharcter]) {
        self.dismissLoadingView()
        self.apiCharcter.removeAll()
        self.realmCharcters = charcters
        self.tableView.reloadData()
        self.tableView.layoutSubviews()
    }
}
//MARK:- SearchBar
extension ListVC: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text , text.count != 0 {
            self.apiCharcter.removeAll()
            self.presenter?.getCharcters(searchText: text, offset: 0)
        }
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            self.apiCharcter.removeAll()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                searchBar.resignFirstResponder()
                self.hasMore = true
                self.presenter?.getCharcters(searchText: nil, offset: 0)
            }
        }
    }
}
