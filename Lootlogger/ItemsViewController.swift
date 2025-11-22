import UIKit

class ItemsViewController: UITableViewController {
    
    var itemStore: ItemStore!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 65
    }
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // Section 0: Expensive items, Section 1: Cheap items
        return 2
    }
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
       
        let items = itemStore.item(for: section)
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Items Worth More Than $50"
        } else {
            return "Items Worth $50 or Less"
        }
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell",
                                                 for: indexPath)
        
        
        let items = itemStore.item(for: indexPath.section)
        let item = items[indexPath.row]
        
        cell.textLabel?.text = item.name
        cell.detailTextLabel?.text = "$\(item.valueInDollars)"
        
        return cell
    }
    
    
    
    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
        
    
        let newItem = itemStore.createItem()
        
        
        let targetSection = newItem.valueInDollars > 50 ? 0 : 1
        
       
        let itemsInTargetSection = itemStore.item(for: targetSection)
        
        
        if let index = itemsInTargetSection.firstIndex(of: newItem) {
            let indexPath = IndexPath(row: index, section: targetSection)
            
            
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
    
    @IBAction func toggleEditingMode(_ sender: UIButton) {
        if isEditing {
            sender.setTitle("Edit", for: .normal)
            setEditing(false, animated: true)
        } else {
            sender.setTitle("Done", for: .normal)
            setEditing(true, animated: true)
        }
    }
    
   
    
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            // Get the item from the correct section array
            let items = itemStore.item(for: indexPath.section)
            let item = items[indexPath.row]
            
            
            itemStore.removeItem(item: item)
            
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView,
                            moveRowAt sourceIndexPath: IndexPath,
                            to destinationIndexPath: IndexPath) {
        
        
        itemStore.moveItem(from: sourceIndexPath, to: destinationIndexPath)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tableView.reloadData()
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case "showItem":
          
            if let indexPath = tableView.indexPathForSelectedRow {
                
               
                let items = itemStore.item(for: indexPath.section)
                
                
                let item = items[indexPath.row]
                
               
                let detailViewController = segue.destination as! DetailViewController
                detailViewController.item = item
            }
        default:
            
            break
        }
    }
}
