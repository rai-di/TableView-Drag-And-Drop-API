//
//  EmojiTableViewController.swift
//  TableView Drag And Drop API
//
//  Created by DiRai on 11/09/20.
//  Copyright © 2020 DiRai. All rights reserved.
//

import UIKit
import MobileCoreServices

class EmojiTableViewController: UITableViewController, UITableViewDragDelegate, UITableViewDropDelegate {
    
    var emojiArray = [ "😀 😀 😀 😀 😀 😀 ",
                       "😇 😇 😇 😇 😇 😇",
                       "🙃 🙃 🙃 🙃 🙃 🙃",
                       "🤩 🤩 🤩 🤩 🤩 🤩",
                       "🥰 🥰 🥰 🥰 🥰 🥰",
                       "🤣 🤣 🤣 🤣 🤣 🤣",
                       "🥳 🥳 🥳 🥳 🥳 🥳",
                       "😜 😜 😜 😜 😜 😜" ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dragInteractionEnabled = true
        tableView.dragDelegate = self
        tableView.dropDelegate = self
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emojiArray.count
    }

    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let emoji = emojiArray[ indexPath.row ]
        let data = emoji.data(using: .utf8)
        let itemProvider = NSItemProvider()
        
        itemProvider.registerDataRepresentation(forTypeIdentifier: kUTTypePlainText as String, visibility: .all) { completion in
            completion(data, nil)
            return nil
        }

        return [
            UIDragItem(itemProvider: itemProvider)
        ]
    }
    
    func tableView(_ tableView: UITableView, canHandle session: UIDropSession) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        var destinationIndexPath : IndexPath
        if let indexPath = coordinator.destinationIndexPath {
            destinationIndexPath = indexPath
        }else{
            let section = tableView.numberOfSections - 1
            let row = tableView.numberOfRows(inSection: section)
            destinationIndexPath = IndexPath(row: row, section: section)
        }
        coordinator.session.loadObjects(ofClass: NSString.self) { items in
            guard let string = items.first as? String else{
                return
            }
            let sourceIndexPath = coordinator.items.first?.sourceIndexPath
             var updatedIndexPaths = [IndexPath]()
            if sourceIndexPath!.row < destinationIndexPath.row {
                updatedIndexPaths =  (sourceIndexPath!.row...destinationIndexPath.row).map { IndexPath(row: $0, section: 0) }
            } else if sourceIndexPath!.row > destinationIndexPath.row {
                updatedIndexPaths =  (destinationIndexPath.row...sourceIndexPath!.row).map { IndexPath(row: $0, section: 0) }
            }
            print( "updatedIndexPaths", updatedIndexPaths )
            print( "-------------" )
            tableView.beginUpdates()
            self.emojiArray.remove(at: sourceIndexPath!.row )
            self.emojiArray.insert(string, at: destinationIndexPath.row)
            //self.tableView.deleteRows(at: [sourceIndexPath!], with: .none)
            //self.tableView.insertRows(at: [destinationIndexPath], with: .none)
            self.tableView.reloadRows(at: updatedIndexPaths, with: .automatic)
            tableView.endUpdates()
         }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "emojiCell", for: indexPath)
        cell.textLabel!.text = emojiArray[ indexPath.row ]
        return cell
    }

    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
