import UIKit
import SVProgressHUD
import DZNEmptyDataSet

class RepositoryViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var arrayRepositories = [Repository]()
    var arrayRepositoriesFiltered = [Repository]()
    var idleTimer = Timer()
    var repositorySelected: Repository?
    var page = 1
    let searchBar:UISearchBar = UISearchBar()
    var isFilterName = false
    var refreshControl: UIRefreshControl!
    var buttonSearch: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView()
        configSearch()
        configRefresh()
        NotificationCenter.default.addObserver(self, selector: #selector(RepositoryViewController.internetStatusChanged), name: NSNotification.Name(rawValue: Constants.InternetStatus.StatusChanged), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        RepositoryController.sharedInstance.delegate = self
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
        if !isFilterName {
            navigationController?.visibleViewController?.title = "Github JavaPop"
        }
    }
    
    func configTableView() {
        tableView.estimatedRowHeight = 100
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.tableFooterView?.isHidden = true
        tableView.tableHeaderView = UIView(frame: CGRect.zero)
        tableView.tableHeaderView?.isHidden = true
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func internetStatusChanged() {
        tableView.reloadEmptyDataSet()
        if InternetMonitor.sharedInstance.isConnectedToNetworkAtTheMoment() {
            initialSearch()
        } else {
            arrayRepositories.removeAll()
            arrayRepositoriesFiltered.removeAll()
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
        page = 1
        loadRepositories()
    }
    
    func initialSearch() {
        cancelSearch()
        page = 1
        loadRepositories()
    }
    
    
    func configRefresh(){
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(RepositoryViewController.refresh(_:)), for: UIControlEvents.valueChanged)
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
        page = 1
        navigationController?.visibleViewController?.navigationItem.titleView = nil
        navigationController?.visibleViewController?.title = "Github JavaPop"
        navigationController?.visibleViewController?.navigationItem.rightBarButtonItems = [buttonSearch!]
        tableView.reloadData()
    }
    
    func loadRepositories() {
        if isFilterName {
            filterByName()
        } else {
            RepositoryController.sharedInstance.findRepositories(page: page)
        }
    }
    
    func filterByName() {
        if let text = searchBar.text {
            arrayRepositoriesFiltered = arrayRepositories.filter({ repository -> Bool in
                guard let fullName = repository.fullName else {
                    return true
                }
                return fullName.lowercased().contains(text.lowercased())
            })
        }
        stopRefresh()
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segue.DetailRepositorySegue {
            let vc = segue.destination as! PullRequestViewController
            vc.repositoryDetailed = repositorySelected
        }
    }
    
    func stopIdleTimer () {
        idleTimer.invalidate()
    }
    
    func timerLoadRepositoriesByName() {
        if let search = searchBar.text {
            if !search.isBlank() {
                page = 1
                loadRepositories()
            }
        }
    }
}

extension RepositoryViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "noInternet")
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "No repositories Founded"
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

extension RepositoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        if maximumOffset - currentOffset <= 20.0 {
            page = page + 1
            loadRepositories()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFilterName {
            return arrayRepositoriesFiltered.count
        } else {
            return arrayRepositories.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cell.RepositoryCell, for: indexPath) as! RepositoryCell
        if isFilterName {
            cell.configure(arrayRepositoriesFiltered[indexPath.row])
        } else {
            cell.configure(arrayRepositories[indexPath.row])
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
            repositorySelected = arrayRepositoriesFiltered[indexPath.row]
        } else {
            repositorySelected = arrayRepositories[indexPath.row]
        }
        performSegue(withIdentifier: Constants.Segue.DetailRepositorySegue, sender: self)
    }
}


extension RepositoryViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        stopIdleTimer()
        idleTimer = Timer.scheduledTimer(timeInterval: 0.8, target: self, selector: #selector(timerLoadRepositoriesByName), userInfo: nil, repeats: false)
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        stopIdleTimer()
        if let search = searchBar.text {
            if !search.isBlank() {
                page = 1
                loadRepositories()
                searchBar.resignFirstResponder()
            }
        }
    }
}

extension RepositoryViewController: DelegateRepository {
    func repositoriesNotFoundWith(error: String) {
        _ = SweetAlert().showAlert("Error!", subTitle: error, style: AlertStyle.error)
        stopRefresh()
    }
    
    func repositoriesFoundWithSuccess(repositories: [Repository]) {
        if !isFilterName {
            if page == 1 {
                arrayRepositories = repositories
            } else {
                arrayRepositories.append(contentsOf: repositories)
            }
        }
        arrayRepositoriesFiltered = arrayRepositories
        tableView.reloadData()
        stopRefresh()
    }
}
