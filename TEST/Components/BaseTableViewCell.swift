import UIKit

class BaseTableViewCell: UITableViewCell {
    
    static var identifierCell: String {
        String(describing: self)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
        makeConstraints()
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    func configureView() { }
    
    func makeConstraints() { }
}
