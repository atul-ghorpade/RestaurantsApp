//

import UIKit

protocol RestaurantsListView: ViewProtocol {
    var presenter: RestaurantsListPresenterProtocol! { get set }
    func changeViewState(viewState: RestaurantsListViewState)
}

final class RestaurantsListViewController: UIViewController, RestaurantsListView {
    var presenter: RestaurantsListPresenterProtocol!

    @IBOutlet private weak var tableView: UITableView!
    
    static var storyboardName: String {
        "RestaurantsList"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        presenter.viewLoaded()
    }

    private func setupViews() {
        tableView.register(UINib(nibName: String(describing: RestaurantTableViewCell.self),
                                 bundle: nil),
                           forCellReuseIdentifier: RestaurantTableViewCell.identifier)
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
    }

    func changeViewState(viewState: RestaurantsListViewState) {
        switch viewState {
        case .clear:
            break
        case .loading:
            tableView.isUserInteractionEnabled = false
        case .render:
            tableView.isUserInteractionEnabled = true
            tableView.reloadData()
        }
    }
}

extension RestaurantsListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfRowsInSection(section: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RestaurantTableViewCell.identifier,
                                                       for: indexPath) as? RestaurantTableViewCell ,
              let cellViewModel = presenter.viewModelForCell(at: indexPath) as? RestaurantCellViewModel else {
            assertionFailure("Cannot dequeue reusable cell \(RestaurantTableViewCell.self) with reuseIdentifier: \(RestaurantTableViewCell.identifier))")
            return UITableViewCell()
        }

        cell.setup(viewModel: cellViewModel)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectRow(indexPath: indexPath)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if tableView.contentOffset.y > (tableView.contentSize.height - tableView.frame.size.height) {
            presenter.didScrollBeyondCurrentPage()
        }
    }
}
