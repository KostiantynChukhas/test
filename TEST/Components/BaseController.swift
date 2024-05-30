
import Foundation
import UIKit

class BaseController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        addSubviews()
        configureConstraints()
    }
    
    func addSubviews() { }
    func configureConstraints() {  }
    
    
    deinit { printDeinit(self) }
    
}
