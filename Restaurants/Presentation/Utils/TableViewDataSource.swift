import Foundation

protocol TableViewDataSource {
    func numberOfRowsInSection(section: Int) -> Int
    func viewModelForCell(at indexPath: IndexPath) -> CellViewModel?
}

extension TableViewDataSource {
    func numberOfRowsInSection(section: Int) -> Int {
        return 0
    }

    func viewModelForCell(at indexPath: IndexPath) -> CellViewModel? {
        return nil
    }
}

protocol CellViewModel {
}
