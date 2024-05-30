
import UIKit

class SplashViewController: BaseController {
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activity =  UIActivityIndicatorView(style: .large)
        activity.translatesAutoresizingMaskIntoConstraints = false
        activity.color = .gray
        return activity
    }()
    
    var viewModel: SplashViewModelType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func addSubviews() {
        super.addSubviews()
        view.addSubview(activityIndicator)
    }
    
    override func configureConstraints() {
        super.configureConstraints()
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        self.showActivityIndicator()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            self.transitionToMainScreen()
        })
        
    }
    
    func showActivityIndicator() {
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
    }
    
    func hideActivityIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    
    func transitionToMainScreen() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.viewModel.route(to: .main)
        })
    }
    
    deinit {
        hideActivityIndicator()
        print("SplashViewController - deinit")
    }
}
