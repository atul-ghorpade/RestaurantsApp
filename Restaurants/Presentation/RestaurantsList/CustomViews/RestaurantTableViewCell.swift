//

import UIKit

struct RestaurantCellViewModel: CellViewModel, Equatable {
    let imageURL: URL?
    let name: String
    let status: String?
}

final class RestaurantTableViewCell: UITableViewCell {
    @IBOutlet private weak var restaurantImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var statusLabel: UILabel!

    static let identifier = String(describing: RestaurantTableViewCell.self)

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        layoutIfNeeded()
    }

    func setup(viewModel: RestaurantCellViewModel) {
        restaurantImageView.image = nil
        if let url = viewModel.imageURL {
            restaurantImageView.downloadAndShowImage(url: url)
        }
        nameLabel.text = viewModel.name
        if let statusString = viewModel.status {
            statusLabel.isHidden = false
            statusLabel.text = statusString
        } else {
            statusLabel.isHidden = true
        }
    }
}

//TODO: This code should not be here inside a view as it contains logic to download from remote URL, added temporarily, remove it! Also support logic to cancel download once cell is reused for other rows
extension UIImageView {
    fileprivate func downloadAndShowImage(url: URL) {
        let urlRequest = URLRequest(url: url)
        URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
            guard error == nil, let data = data else {
                return
            }
            DispatchQueue.main.async {
                self.image = nil
            }
            let image = UIImage(data: data)
            DispatchQueue.main.async { [weak self] in
                self?.image = image
            }
        }.resume()
    }
}
