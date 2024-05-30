
import UIKit

class MainViewController: BaseController {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.rowHeight = UIScreen.main.bounds.size.width + 100
        return tableView
    }()
    
    var viewModel: MainViewModelType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        bindData()
    }
    
    override func addSubviews() {
        super.addSubviews()
        view.addSubview(tableView)
    }
    
    override func configureConstraints() {
        super.configureConstraints()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupTableView() {
        tableView.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.identifier)

        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func bindData() {
        viewModel.onReload = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    deinit {
        printDeinit(self)
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         viewModel.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: MainTableViewCell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.identifier, for: indexPath) as? MainTableViewCell else { return UITableViewCell() }
        cell.configure(with: viewModel.items[indexPath.row])
        return cell
    }
}

extension MainViewController: UITableViewDelegate {
    
}
