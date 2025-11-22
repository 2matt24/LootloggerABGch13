// ItemStore.swift

import UIKit

class ItemStore {

    var expensiveItems = [Item]() // For items > $50
    var cheapItems = [Item]()     // For items <= $50
    var allItems = [Item]()
    let itemArchiveURL: URL = {
        let documentsDirectories =
            FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        return documentDirectory.appendingPathComponent("items.plist")
    }()
    
    
    
    @discardableResult func createItem() -> Item {
        let newItem = Item(random: true)
        
        // Append to the correct section array
        if newItem.valueInDollars > 50 {
            expensiveItems.append(newItem)
        } else {
            cheapItems.append(newItem)
        }
        
        

        return newItem
    }
    
    
    func removeItem(item: Item) {
        // Check and remove from the expensive array first
        if let index = expensiveItems.firstIndex(of: item) {
            expensiveItems.remove(at: index)
        }
        // If not found in expensive, check and remove from the cheap array
        else if let index = cheapItems.firstIndex(of: item) {
            cheapItems.remove(at: index)
        }
        
    }
    
    
    func item(for section: Int) -> [Item] {
        return section == 0 ? expensiveItems : cheapItems
    }
    
    
    func moveItem(from sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let itemToMove: Item

        // 1. Get the item and remove it from the source array
        if sourceIndexPath.section == 0 {
            itemToMove = expensiveItems[sourceIndexPath.row]
            expensiveItems.remove(at: sourceIndexPath.row)
        } else {
            itemToMove = cheapItems[sourceIndexPath.row]
            cheapItems.remove(at: sourceIndexPath.row)
        }

        // 2. Insert the item into the destination array
        if destinationIndexPath.section == 0 {
            expensiveItems.insert(itemToMove, at: destinationIndexPath.row)
        } else {
            cheapItems.insert(itemToMove, at: destinationIndexPath.row)
        }
    }
    
    
    /*func saveChanges() -> Bool {
        
        let allItemsToSave = expensiveItems + cheapItems

        do {
            
            let encoder = PropertyListEncoder()
            
            
            let data = try encoder.encode(allItemsToSave)
            
            
            
            print("Successfully encoded and saved all items.")
            return true // Return true if everything succeeded
            
        } catch {
            
            print("Error encoding or saving items: \(error)")
            return false // Return false if an error occurred
        }
    } */
    
    @objc func saveChanges() -> Bool {
        
        
        print("Saving items to: \(itemArchiveURL)")
        
        do {
            let encoder = PropertyListEncoder()
            
            let data = try encoder.encode(allItems)
            try data.write(to: itemArchiveURL, options: [.atomic])
            print("Saved all of the items")
            return true
            
        } catch let encodingError {
            print("Error encoding allItems: \(encodingError)")
            return false
        }

       
    }
    
    
    init() {
        do {
                let data = try Data(contentsOf: itemArchiveURL)
                let unarchiver = PropertyListDecoder()
                let items = try unarchiver.decode([Item].self, from: data)
                allItems = items
            } catch {
                print("Error reading in saved items: \(error)")
            }
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(saveChanges),
                                       name: UIScene.didEnterBackgroundNotification,
                                       object: nil)
    }
    
    
    
}


