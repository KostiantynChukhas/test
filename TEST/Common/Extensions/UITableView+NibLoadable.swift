

import UIKit

extension UITableViewCell: NibLoadableView {}

extension UITableViewCell {
    static var reuseIdentifier: String { return String(describing: self) }
}

extension UITableView {
    func registerNib<T: UITableViewCell>(cellType _: T.Type) {
        register(UINib(nibName: T.nibName, bundle: nil), forCellReuseIdentifier: T.reuseIdentifier)
    }

    func dequeCell<T: UITableViewCell>(for indexPath: IndexPath) -> T? {
        guard let cell = dequeueReusableCell(withIdentifier: T.nibName, for: indexPath) as? T else {
            return nil
        }

        return cell
    }
    
    func register<T: UITableViewCell>(cell: T.Type) {
        register(T.nib, forCellReuseIdentifier: T.identifier)
    }
    
    func dequeueReusableCell<T: Reusable>(
        ofType cellType: T.Type,
        at indexPath: IndexPath
    ) -> T where T: UITableViewCell {
        
        
        guard let cell = dequeueReusableCell(withIdentifier: cellType.reuseID, for: indexPath) as? T else {
            fatalError("❌ Failed attempt create reuse cell \(cellType.reuseID)")
        }
        return cell
    }
}

public protocol Reusable {
    static var reuseID: String { get }
}

public extension Reusable {
    static var reuseID: String {
        return String(describing: self)
    }
}
