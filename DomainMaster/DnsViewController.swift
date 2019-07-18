//
//  Created by Andrew Schools on 6/6/19.
//  Copyright © 2019 iTalkToComputers. All rights reserved.
//

import Foundation
import AppKit

class DnsViewController : ViewController, NSTableViewDataSource, NSTableViewDelegate, NSComboBoxDelegate {
    @IBOutlet weak var dnsProgressBar: NSProgressIndicator!
    @IBOutlet weak var lookupBtn: NSButton!
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var dnsDomain: NSComboBox!
    
    var data: [DnsRow] = []
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        dnsDomain.delegate = self
        addUrlCacheToComboBox()
    }
    
    func addUrlCacheToComboBox() {
        let urls = UrlCache.get()
        for i in urls {
            dnsDomain.addItem(withObjectValue: i)
        }
    }
    
    @IBAction func lookUp(_ sender: Any) {
        startLookup()
    }
    
    func startLookup() {
        lookupBtn.isEnabled = false
        dnsProgressBar.isHidden = false
        dnsProgressBar.startAnimation(self.view)
        UrlCache.add(url: dnsDomain.stringValue)
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.data = DnsHelper.dnsLookUp(domain: self.dnsDomain.stringValue)
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.lookupBtn.isEnabled = true
                self.dnsProgressBar.isHidden = true
            }
        }
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if (tableView.tableColumns[0] == tableColumn) {
            if let cell = tableView.makeView(
                withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "domain"),
                owner: nil
            ) as? NSTableCellView {
                cell.textField?.stringValue = self.data[row].domain
                return cell
            }
        }
        else if (tableView.tableColumns[1] == tableColumn) {
            if let cell = tableView.makeView(
                withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "ttl"),
                owner: nil
            ) as? NSTableCellView {
                cell.textField?.stringValue = String(self.data[row].ttl)
                return cell
            }
        }
        else if (tableView.tableColumns[2] == tableColumn) {
            if let cell = tableView.makeView(
                withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "type"),
                owner: nil
            ) as? NSTableCellView {
                cell.textField?.stringValue = self.data[row].type
                return cell
            }
        }
        else if (tableView.tableColumns[3] == tableColumn) {
            if let cell = tableView.makeView(
                withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "ip"),
                owner: nil
            ) as? NSTableCellView {
                cell.textField?.stringValue = self.data[row].ip
                return cell
            }
        }
        return nil
    }
    
    @IBAction func comboOnChange(_ sender: Any) {
        if dnsDomain.stringValue != "" {
            startLookup()
        }
    }
}