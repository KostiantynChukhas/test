import UIKit

class MainTableViewCell: BaseTableViewCell {
    
    lazy var imgView: UIImageView = {
        var view = UIImageView()
        view.image = UIImage(named: "Image")
        return view
    }()
    
    lazy var textTitleLabel: UILabel = {
        var label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = #colorLiteral(red: 0.09019607843, green: 0.09019607843, blue: 0.09019607843, alpha: 1)
        return label
    }()
    
    lazy var textDescriptionLabel: UILabel = {
        var label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = #colorLiteral(red: 0.09019607843, green: 0.09019607843, blue: 0.09019607843, alpha: 1)
        label.textAlignment = .center
        return label
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func configureView() {
        super.configureView()
        contentView.addSubview(containerView)
        containerView.addSubview(imgView)
        containerView.addSubview(textTitleLabel)
        containerView.addSubview(textDescriptionLabel)
    }
    
    override func makeConstraints() {
        super.makeConstraints()
        // Disable autoresizing mask translation for each view
        imgView.translatesAutoresizingMaskIntoConstraints = false
        textTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        textDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        // imgView Constraints
        NSLayoutConstraint.activate([
            imgView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            imgView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            imgView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            imgView.heightAnchor.constraint(equalTo: imgView.widthAnchor)
        ])
        
        // textTitleLabel Constraints
        NSLayoutConstraint.activate([
            textTitleLabel.topAnchor.constraint(equalTo: imgView.bottomAnchor, constant: 10),
            textTitleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 30),
            textTitleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -30)
        ])
        
        // textDescriptionLabel Constraints
        NSLayoutConstraint.activate([
            textDescriptionLabel.topAnchor.constraint(equalTo: textTitleLabel.bottomAnchor,constant:4.0),
            textDescriptionLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor,constant:-4.0),
            textDescriptionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor,constant: 5),
            textDescriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
    }
    
    func configure(with model: TestItemModel) {
        textTitleLabel.text = model.title
        textDescriptionLabel.text = model.description
        showLoader()
        loadImage(with: model)
    }
    
    private func loadImage(with model: TestItemModel) {
        guard let url = URL(string: model.imageURL) else { return }
        ImageCachingService.shared.load(from: url) { [weak self] image in
            DispatchQueue.main.async {
                self?.imgView.image = image
                self?.hideLoader()
                self?.layoutSubviews()
            }
        }
    }
    
    private func showLoader() {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.startAnimating()
        activityIndicator.tag = 123 // Set a tag to identify the loader later
        addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: activityIndicator.superview!.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: activityIndicator.superview!.centerYAnchor)
        ])
        
    }
    
    private func hideLoader() {
        if let loaderView = self.viewWithTag(123) as? UIActivityIndicatorView {
            loaderView.stopAnimating()
            loaderView.removeFromSuperview()
        }
    }
}
