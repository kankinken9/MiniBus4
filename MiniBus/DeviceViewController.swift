//
//  DeviceViewController.swift
//  MiniBus
//
//  Created by kenkan on 14/1/2022.
//

import UIKit
import CoreData

class DeviceViewController: UITableViewController {
    var devices : [Device]?;
    
    
    @IBAction func cancel(segue : UIStoryboardSegue){
    }
    @IBAction func save(segue : UIStoryboardSegue){
        if let source = segue.source as? AddEditViewController,
           let context = self.manageObjectContext {
            if let device = source.theDevice {
                //for edit
                device.texteng = source.textengTF.text
                device.textzhone = source.textzhoneTF.text
                device.textzhtwo = source.textzhtwoTF.text
            } else if let newDevice = NSEntityDescription.insertNewObject(forEntityName: "Device",
                                                                          into: context) as? Device {
                //for new device
                newDevice.texteng = source.textengTF.text
                newDevice.textzhone = source.textzhoneTF.text
                newDevice.textzhtwo = source.textzhtwoTF.text
            }
            do {
                try context.save();
            } catch  {
                print("can't save");
            }
            self.searchAndReloadTable(query: "")
        }
    }
    
    var manageObjectContext : NSManagedObjectContext? {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            return appDelegate.persistentContainer.viewContext
        }
        return nil;
    }
    
    func searchAndReloadTable(query:String){
        if let manageObjectContext = self.manageObjectContext {
            let fetchRequest = NSFetchRequest<Device>(entityName: "Device");
            if query.count > 0 {
                let predicate = NSPredicate(format: "name contains[cd] %@", query)
            }
            do {
                let theDevices = try manageObjectContext.fetch(fetchRequest)
                self.devices = theDevices
                self.tableView.reloadData()
            } catch {
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.searchAndReloadTable(query: "")
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if let devices = self.devices {
            return devices.count
        }
        return 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        // Configure the cell...
        if let device = self.devices?[indexPath.row] {
            cell.textLabel?.text = "\(device.textzhtwo!) \(device.texteng!)"
            cell.detailTextLabel?.text = "\(device.textzhone!)"
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditSegue" {
            if let navVC = segue.destination as? UINavigationController {
                if let addEditVC = navVC.topViewController as? AddEditViewController {
                    if let indexPath = tableView.indexPathForSelectedRow {
                        if let devices = self.devices {
                            addEditVC.theDevice = devices[indexPath.row]
                        }
                    } }
            } }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle:
                            UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let device  = self.devices?.remove(at: indexPath.row) {
                manageObjectContext?.delete(device)
                try? self.manageObjectContext?.save()
            }
            self.tableView.deleteRows(at: [indexPath], with: .fade);
        }
    }

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
