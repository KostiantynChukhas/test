
import UIKit

extension UICollectionViewCell: NibLoadableView {}

extension UICollectionView {
   
    func register(_ cells: [String]) {
        cells.forEach {
            register(UINib(nibName: $0, bundle: nil), forCellWithReuseIdentifier: $0)
        }
    }
    
    func setDataSource(_ dataSource: UICollectionViewDataSource, delegate: UICollectionViewDelegate? = nil) {
        self.dataSource = dataSource
        self.delegate = delegate
    }
    
    func dequeue<T: UICollectionViewCell>(id: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath) as? T else {
              return UICollectionViewCell() as! T
          }
          return cell
      }
}
