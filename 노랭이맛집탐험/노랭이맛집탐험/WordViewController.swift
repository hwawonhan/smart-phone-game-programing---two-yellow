//
//  WordViewController.swift
//  노랭이맛집탐험
//
//  Created by kpugame on 2018. 5. 25..
//  Copyright © 2018년 hwawonhan. All rights reserved.
//

import UIKit


class WordViewController: UITableViewController, XMLParserDelegate {
    @IBOutlet var tbData: UITableView!
    
    //var parser: XMLParser = XMLParser(contentsOf:(URL(string:"https://openapi.naver.com/v1/search/local.xml?query=종로맛집"))!)!
    var parser = XMLParser()
    var posts = NSMutableArray()
    var elements = NSMutableDictionary()
    var element = NSString()
    var title1 = NSMutableString()
    var date = NSMutableString()
    var foodRestaurants:[Restaurant] = foodData
    
    func beginParsing()
    {
        
        posts = []
        let coment = "종로한식"
        let api = "https://openapi.naver.com/v1/search/local.xml?query=\(coment)&display=5&start=1&sort=random"
        let encoding = api.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = URL(string: encoding!)
        
        var request = URLRequest.init(url: url!)
        request.setValue("1qO9XJIT5mR1O3sz_u6J", forHTTPHeaderField: "X-Naver-Client-Id")
        request.setValue("bZcbo3uiSX", forHTTPHeaderField: "X-Naver-Client-Secret")
        request.httpMethod = "get"
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
            //error 나면 뒤져라
            guard error == nil && data != nil else {
                if let err = error {
                    print(err.localizedDescription)
                }
                return
            }
            
           
            
            //error 안났으면 data 내놔라
            if let _data = data {
                if let strData = NSString(data: _data, encoding: String.Encoding.utf8.rawValue) {
                    let str = String(strData)
                    
                    
                    // Main thread에서 출력하기 위해서는 아래에서
                    DispatchQueue.main.async {
                        //self.라벨.text = str
                        print(str)
                    }
                }
            }else{
                print("data nil")
            }
        })
        task.resume()
        
    }
    
    
    

    func parser(_ parser: XMLParser, didStartElement elementName:
        String, namespaceURI: String?, qualifiedName qName: String?,
                attributes attributeDict: [String : String])
    {
        element = elementName as NSString
        if (elementName as NSString).isEqual(to: "item")
        {
            elements = NSMutableDictionary()
            elements = [:]
            title1 = NSMutableString()
            title1 = ""
            date = NSMutableString()
            date = ""
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if element.isEqual(to: "title") {
            title1.append(string)
        } else if element.isEqual(to: "address") {
            date.append(string)
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
        if (elementName as NSString).isEqual(to: "item") {
            if !title1.isEqual(nil) {
                elements.setObject(title1, forKey: "title" as NSCopying)
            }
            if !date.isEqual(nil) {
                elements.setObject(date, forKey: "address" as NSCopying)
            }
            posts.add(elements)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        beginParsing()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return posts.count
    }

    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = (posts.object(at: indexPath.row) as AnyObject).value(forKey: "title") as! NSString as String
        cell.detailTextLabel?.text = (posts.object(at: indexPath.row) as AnyObject).value(forKey: "address") as! NSString as String
        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
