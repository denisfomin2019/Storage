
import UIKit


class TodoRealmVC: UIViewController {
    
    var warningLabel = UILabel()
    let items = Persistance.shared.loadItem()
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func addBtnPressed(_ sender: Any) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Назовите новую задачу", message: "", preferredStyle:.alert)
        let action = UIAlertAction(title: "Добавить задачу", style: .default) { action in
            let newItem = TodoItem()
            
            if textField.text != "" {
                newItem.title = textField.text!
            } else {
                newItem.title = "Без названия"
                
            }

            Persistance.shared.saveItem(newItem)
            self.tableView.isHidden = false
            self.warningLabel.isHidden = true
            self.tableView.reloadData()
        }
            
            alert.addAction(action)
            alert.addTextField { alertTF in
                textField = alertTF
                textField.placeholder = "Введите название"
   
            }
        
            present(alert,animated: true,completion: nil)
    }
        

    override func viewDidLoad() {
        super.viewDidLoad()
        
        createNoItemsMessage()
        
        if items!.count == 0 {
            showEmptyList()
            
        } else { tableView.isHidden = false
            tableView.reloadData()
            
        }
    }
    
    
    func createNoItemsMessage() {
        
        warningLabel.text = "У вас пока нет задач"
        warningLabel.textColor = .darkGray
        warningLabel.textAlignment = .center
        warningLabel.isHidden = true
        warningLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(warningLabel)

        warningLabel.widthAnchor.constraint(equalToConstant: 250).isActive = true
        warningLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        warningLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        warningLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        
    }

    func showEmptyList() {
                
        tableView.isHidden = true
        warningLabel.isHidden = false
    }
}


extension TodoRealmVC: UITableViewDataSource, UITableViewDelegate{
    
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items!.count
    }
    
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! myTableViewCell
        cell.textLabel?.text = items?[indexPath.row].title
        return cell
              
     }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }

    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { _, _, complete in
            
            Persistance.shared.deleteItem((self.items?[indexPath.row])!)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            
            if self.items!.count == 0 {
                self.showEmptyList()
            }
            
            complete(true)
        }
        
        deleteAction.image = UIImage(named: "delete-icon")
        deleteAction.backgroundColor = .red
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    private func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UIContextualAction]? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { _, _,_  in
            Persistance.shared.deleteItem((self.items?[indexPath.row])!)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            deleteAction.backgroundColor = .red
            return [deleteAction]
    }
}
