//
//  ViewController.swift
//  Food Finder
//
//  Created by Scarlet on 20/9/2018.
//  Copyright © 2018 Scarlet. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let foodList = ["KFC", "McDonald", "薩莉亞", "Pizza", "扑野家", "PIAGO Food Court", "秀吉", "Mos", "Suckway", "柒唔夠"]
    let history = NSMutableArray()
    let latest4 = NSMutableArray()
    
    var db: SQLiteConnect?
    var answer = ""
    
    @IBOutlet weak var result: UILabel!
    @IBOutlet weak var historyList: UITableView!
    @IBAction func choose(_ sender: UIButton) {
        let historyList = NSMutableArray()
        let sqlitePath = urls[urls.count-1].absoluteString + "sqlite3.db"
        var base = 10
        let chooseList = NSMutableArray()
        
        db = SQLiteConnect(path: sqlitePath)
        if let mydb = db{
            let sql = mydb.fetch("History", cond: nil, order: nil)
            while sqlite3_step(sql) == SQLITE_ROW{
                historyList.add(String(cString: sqlite3_column_text(sql, 0)))
            }
        }
        
        for item in foodList{
            for history in latest4{
                if item == (history as! String){
                    base = 0
                    continue
                }
            }
            for _ in 0...base{
                chooseList.add(item)
            }
        }
        
        let index = Int.random(in: 0..<chooseList.count)
        
        answer = chooseList.shuffled()[index] as! String
        
        let alert = UIAlertController(title: "今日食依個啦屌你", message: answer + "\n\n 法官大人", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "我屌", style: .default, handler: { _ in
            if let mydb = self.db{
                self.history.removeAllObjects()
                let _ = mydb.insert("History", rowInfo: ["Name" : "'" + self.answer + "'"])
                let sql = mydb.fetch("History", cond: nil, order: nil)
                while sqlite3_step(sql) == SQLITE_ROW{
                    self.history.add(String(cString: sqlite3_column_text(sql, 0)))
                }
            }
            self.historyList.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "你屌埋我個份", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return history.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = historyList.dequeueReusableCell(withIdentifier: "BasicCell", for: indexPath)
        let histroy = history.reversed()
        myCell.textLabel?.textAlignment = .center
        myCell.textLabel?.text = histroy[indexPath.row] as? String
        
        return myCell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        historyList.delegate = self
        historyList.dataSource = self
        
        let sqlitePath = urls[urls.count-1].absoluteString + "sqlite3.db"
        print(sqlitePath)
        db = SQLiteConnect(path: sqlitePath)
        if let mydb = db{
            let _ = mydb.createTable("History", columnsInfo: ["Name text"])
            let sql = mydb.fetch("History", cond: nil, order: nil)
            while sqlite3_step(sql) == SQLITE_ROW{
                history.add(String(cString: sqlite3_column_text(sql, 0)))
            }
        }
        
            for i in 0...4{
                if history.count >= 4{
                    latest4.add(history.reversed()[i])
                }else{
                    latest4.add("")
                }
            }
        
    }

}

