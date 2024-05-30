import UIKit

class MainTableViewCell: BaseTableViewCell {
    
    lazy var imgView: UIImageView = {
        var view = UIImageView()
        view.image = UIImage(named: "preloader")
        return view
    }()
    
    lazy var textTitleLabel: UILabel = {
        var label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = #colorLiteral(red: 0.09019607843, green: 0.09019607843, blue: 0.09019607843, alpha: 1)
        label.text = "Generator with no\nlimitations"
        return label
    }()
    
    lazy var textDescriptionLabel: UILabel = {
        var label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = #colorLiteral(red: 0.09019607843, green: 0.09019607843, blue: 0.09019607843, alpha: 1)
        label.textAlignment = .center
        label.text = "cdwcnmwk"
        return label
    }()
    
    override func configureView() {
        super.configureView()
        contentView.addSubview(imgView)
        contentView.addSubview(textTitleLabel)
        contentView.addSubview(textDescriptionLabel)
    }
    
    override func makeConstraints() {
        super.makeConstraints()
        // Disable autoresizing mask translation for each view
        imgView.translatesAutoresizingMaskIntoConstraints = false
        textTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        textDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        // imgView Constraints
        NSLayoutConstraint.activate([
            imgView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            imgView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imgView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imgView.heightAnchor.constraint(equalTo: imgView.widthAnchor)
        ])

        // textTitleLabel Constraints
        NSLayoutConstraint.activate([
            textTitleLabel.topAnchor.constraint(equalTo: imgView.bottomAnchor, constant: 10),
            textTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            textTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30)
        ])

        // textDescriptionLabel Constraints
        NSLayoutConstraint.activate([
            textDescriptionLabel.topAnchor.constraint(equalTo: textTitleLabel.bottomAnchor, constant: 8),
            textDescriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            textDescriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30)
        ])
    }
    
    func configure(with model: TestItemModel) {
        textTitleLabel.text = model.title
        textDescriptionLabel.text = model.description
        showLoader()
        guard let url = URL(string: model.imageURL) else { return }
        ImageCachingService.shared.load(from: url) { [weak self] image in
            DispatchQueue.main.async {
                self?.imgView.image = image
                self?.hideLoader()
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
