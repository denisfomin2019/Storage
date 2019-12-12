
import UIKit

class UserDefaultsVC: UIViewController {
    
    
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    
    
    @IBAction func firstNameEdited(_ sender: Any) {
        Persistance.shared.firstName = firstNameTF.text
    }
    
    @IBAction func lastNameEdited(_ sender: Any) {
        Persistance.shared.lastName = lastNameTF.text
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstNameTF.text = Persistance.shared.firstName
        lastNameTF.text = Persistance.shared.lastName
    }

}

