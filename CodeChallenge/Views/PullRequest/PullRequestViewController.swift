//
//  PullRequestViewController.swift
//  CodeChallenge
//
//  Created by Fabricio Oliveira on 2/3/17.
//  Copyright © 2017 Fabricio Oliveira. All rights reserved.
//

import UIKit
import SVProgressHUD
import DZNEmptyDataSet

class PullRequestViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var labelOpened: UILabel!
    @IBOutlet weak var labelClosed: UILabel!
    
    let searchBar: UISearchBar = UISearchBar()
    var repositoryDetailed: Repository!
    var arrayPullRequests = [PullRequest]()
    var arrayPullRequestsFiltered = [PullRequest]()
    var isFilterName = false
    var refreshControl: UIRefreshControl!
    var buttonSearch: UIBarButtonItem!
    var pullRequestSelected: PullRequest!
    var idleTimer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView()
        configSearch()
        configRefresh()
        NotificationCenter.default.addObserver(self, selector: #selector(RepositoryViewController.internetStatusChanged), name: NSNotification.Name(rawValue: Constants.InternetStatus.StatusChanged), object: nil)
        navigationController?.navigationBar.topItem?.title = ""
        initialSearch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        PullRequestController.sharedInstance.delegate = self
        if !isFilterName {
            navigationController?.visibleViewController?.title = repositoryDetailed.fullName
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        RepositoryController.sharedInstance.delegate = nil
        if isFilterName {
            searchBar.resignFirstResponder()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func configTableView() {
        tableView.estimatedRowHeight = 100
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.tableFooterView?.isHidden = true
        let px = 2 / UIScreen.main.scale
        let frame = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: px)
        let line = UIView(frame: frame)
        tableView.tableHeaderView = line
        line.backgroundColor = tableView.separatorColor
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func internetStatusChanged() {
        tableView.reloadEmptyDataSet()
        if InternetMonitor.sharedInstance.isConnectedToNetworkAtTheMoment() {
            labelClosed.isHidden = false
            labelOpened.isHidden = false
            initialSearch()
        } else {
            labelClosed.isHidden = true
            labelOpened.isHidden = true
            arrayPullRequests.removeAll()
            arrayPullRequestsFiltered.removeAll()
            tableView.emptyDataSetSource = self
            tableView.emptyDataSetDelegate = self
            tableView.reloadData()
            tableView.reloadEmptyDataSet()
        }
    }
    
    func stopRefresh(){
        refreshControl.endRefreshing()
        SVProgressHUD.dismiss()
    }
    
    func refresh(_ sender:AnyObject) {
        loadPullRequests()
    }
    
    func initialSearch() {
        cancelSearch()
        loadPullRequests()
    }
    
    func configRefresh() {
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(PullRequestViewController.refresh(_:)), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    func configSearch() {
        buttonSearch = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(RepositoryViewController.showSearch))
        navigationController?.visibleViewController?.navigationItem.rightBarButtonItems = [buttonSearch!]
        searchBar.delegate = self
        searchBar.barTintColor = Constants.Color.ColorNavigation
        searchBar.searchBarStyle = .prominent
        searchBar.isTranslucent = false
        let searchTextField: UITextField? = searchBar.value(forKey: "searchField") as? UITextField
        if searchTextField!.responds(to: #selector(getter: UITextField.attributedPlaceholder)) {
            let attributeDict = [NSForegroundColorAttributeName: UIColor.darkGray]
            searchTextField!.attributedPlaceholder = NSAttributedString(string: "Find by Name", attributes: attributeDict)
        }
        searchBar.tintColor = UIColor.white
        searchBar.subviews[0].subviews.flatMap(){ $0 as? UITextField }.first?.tintColor = UIColor.blue
    }
    
    func showSearch() {
        isFilterName = true
        navigationController?.visibleViewController?.navigationItem.titleView = searchBar
        navigationController?.visibleViewController?.navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.done, target: self, action:#selector(RepositoryViewController.cancelSearch))]
        searchBar.becomeFirstResponder()
    }
    
    func cancelSearch() {
        searchBar.resignFirstResponder()
        searchBar.text = ""
        isFilterName = false
        stopIdleTimer()
        navigationController?.visibleViewController?.navigationItem.titleView = nil
        navigationController?.visibleViewController?.title = repositoryDetailed.fullName
        navigationController?.visibleViewController?.navigationItem.rightBarButtonItems = [buttonSearch!]
        tableView.reloadData()
        PullRequestController.sharedInstance.calculateOpenAndClosedRequests(pullRequests: arrayPullRequests)
        
    }
    
    func loadPullRequests() {
        if isFilterName {
            filterByName()
        } else {
            PullRequestController.sharedInstance.findPullRequestsBy(repository: repositoryDetailed)
        }
    }
    
    func reloadEmptyTableView() {
        if isFilterName == true {
            if arrayPullRequestsFiltered.count == 0 && tableView.emptyDataSetDelegate == nil && tableView.emptyDataSetSource == nil {
                tableView.emptyDataSetSource = self
                tableView.emptyDataSetDelegate = self
            }
        } else {
            if arrayPullRequests.count == 0 && tableView.emptyDataSetDelegate == nil && tableView.emptyDataSetSource == nil {
                tableView.emptyDataSetSource = self
                tableView.emptyDataSetDelegate = self
            }
        }
    }
    
    func filterByName() {
        if let text = searchBar.text {
            arrayPullRequestsFiltered = arrayPullRequests.filter({ pullRequest -> Bool in
                guard let title = pullRequest.title else {
                    return true
                }
                return title.lowercased().contains(text.lowercased())
            })
        }
        reloadEmptyTableView()
        stopRefresh()
        tableView.reloadData()
        PullRequestController.sharedInstance.calculateOpenAndClosedRequests(pullRequests: arrayPullRequestsFiltered)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segue.DetailRepositorySegue {
            
        }
    }
    
    func stopIdleTimer () {
        idleTimer.invalidate()
    }
    
    func timerLoadPullRepositoryByName() {
        guard let searchText = searchBar.text else {
            return
        }
        if !searchText.isBlank() {
            loadPullRequests()
        }
    }
}

extension PullRequestViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "noInternet")
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "No pull requests founded"
        let attribs = [
            NSFontAttributeName: UIFont.boldSystemFont(ofSize: 18),
            NSForegroundColorAttributeName: UIColor.darkGray
        ]
        
        return NSAttributedString(string: text, attributes: attribs)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "Check your internet status or change your filters"
        
        let para = NSMutableParagraphStyle()
        para.lineBreakMode = NSLineBreakMode.byWordWrapping
        para.alignment = NSTextAlignment.center
        
        let attribs = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 14),
            NSForegroundColorAttributeName: UIColor.lightGray,
            NSParagraphStyleAttributeName: para
        ]
        
        return NSAttributedString(string: text, attributes: attribs)
    }
    
    func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return -57
    }
}

extension PullRequestViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFilterName {
            return arrayPullRequestsFiltered.count
        } else {
            return arrayPullRequests.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cell.PullRequestCell, for: indexPath) as! PullRequestCell
        if isFilterName {
            cell.configure(arrayPullRequestsFiltered[indexPath.row])
        } else {
            cell.configure(arrayPullRequests[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isFilterName {
            pullRequestSelected = arrayPullRequestsFiltered[indexPath.row]
        } else {
            pullRequestSelected = arrayPullRequests[indexPath.row]
        }
        guard let urlPage = pullRequestSelected.htmlUrl else {
            _ = SweetAlert().showAlert("Error!", subTitle: "Could not open this pull request page.", style: AlertStyle.error)
            return
        }
        PullRequestController.sharedInstance.openPullRequestPage(urlPage: urlPage)
    }
}

extension PullRequestViewController: DelegatePullRequest {
    func pullRequestNotFoundWith(error: String) {
        _ = SweetAlert().showAlert("Error!", subTitle: error, style: AlertStyle.error)
        reloadEmptyTableView()
        stopRefresh()
    }
    
    func pullRequestFoundWithSuccess(pullRequests: [PullRequest]) {
        arrayPullRequests = pullRequests
        arrayPullRequestsFiltered = pullRequests
        tableView.reloadData()
        stopRefresh()
        PullRequestController.sharedInstance.calculateOpenAndClosedRequests(pullRequests: arrayPullRequests)
    }
    
    func totalOpenAndClosedRequests(open: Double, closed: Double) {
        labelOpened.text = String(format:"%.0f", open) + " opened"
        labelClosed.text = " / \(String(format:"%.0f", closed)) closed"
    }
}

extension PullRequestViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        stopIdleTimer()
        idleTimer = Timer.scheduledTimer(timeInterval: 0.8, target: self, selector: #selector(timerLoadPullRepositoryByName), userInfo: nil, repeats: false)
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        stopIdleTimer()
        guard let searchText = searchBar.text else {
            return
        }
        if !searchText.isBlank() {
            loadPullRequests()
            searchBar.resignFirstResponder()
        }
    }
}
