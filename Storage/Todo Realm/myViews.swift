

import UIKit

class myTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        textLabel?.textColor = .white
    
    }

}

class myTableView: UITableView {

    override func awakeFromNib() {
        super.awakeFromNib()
        separatorStyle = .none
    
    }

}


