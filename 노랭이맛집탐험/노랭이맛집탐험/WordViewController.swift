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
    var parser = XMLParser()
    var posts = NSMutableArray()
    var elements = NSMutableDictionary()
    var element = NSString()
    var name = NSMutableString()
    var adress = NSMutableString()
    var category = NSMutableString()
    var telephone = NSMutableString()
    var location:String = ""
    var foodtype:String = ""
    var roadadress = NSMutableString()
    var index:Int = 1
    var foodRestaurants:[Restaurant] = foodData
    func beginParsing()
    {
        
        posts = []
        let api = "https://openapi.naver.com/v1/search/local.xml?query=\(location)\(foodtype)&display=30&start=1&sort=random"
        let encoding = api.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = URL(string: encoding!)
        print(api)
        var request = URLRequest.init(url: url!)
        request.setValue("1qO9XJIT5mR1O3sz_u6J", forHTTPHeaderField: "X-Naver-Client-Id")
        request.setValue("bZcbo3uiSX", forHTTPHeaderField: "X-Naver-Client-Secret")
        request.httpMethod = "get"
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
            //error check
            guard error == nil && data != nil else {
                if let err = error {
                    print(err.localizedDescription)
                }
                return
            }
            
            DispatchQueue.main.async {
                self.parser = XMLParser(data: data!)
                self.parser.delegate = self
                self.parser.parse()
                self.tbData.reloadData()
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
            name = NSMutableString()
            name = ""
            adress = NSMutableString()
            adress = ""
            category = NSMutableString()
            category = ""
            telephone = NSMutableString()
            telephone = ""
            roadadress = NSMutableString()
            roadadress = ""
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        if element.isEqual(to: "title") {
            name.append(String(string.components(separatedBy: ["<",">","b","/"]).joined()))
        } else if element.isEqual(to: "address") {
            adress.append(String(string.components(separatedBy: ["<",">","b","/"]).joined()))
        } else if element.isEqual(to: "category") {
            category.append(String(string.components(separatedBy: ["<",">","b","/"]).joined()))
        } else if element.isEqual(to: "telephone") {
            telephone.append(String(string.components(separatedBy: ["<",">","b","/"]).joined()))
        } else if element.isEqual(to: "roadAddress") {
            roadadress.append(String(string.components(separatedBy: ["<",">","b","/"]).joined()))
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
        
        if (elementName as NSString).isEqual(to: "item") {
            if !name.isEqual(nil) {
                elements.setObject(name, forKey: "title" as NSCopying)
            }
            if !adress.isEqual(nil) {
                elements.setObject(adress, forKey: "address" as NSCopying)
            }
            if !element.isEqual(nil) {
                elements.setObject(category, forKey: "category" as NSCopying)
            }
            if !element.isEqual(nil) {
                elements.setObject(telephone, forKey: "telephone" as NSCopying)
            }
            if !element.isEqual(nil) {
                elements.setObject(roadadress, forKey: "roadAddress" as NSCopying)
            }
            posts.add(elements)
        }
    }
    
    @IBAction func doneToSelectViewController(segue:UIStoryboardSegue) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToDetailView" {
            if let navController = segue.destination as? UINavigationController {
                if let imageviewcontroller = navController.topViewController as?
                    ImageViewController {
                    imageviewcontroller.posts = self.posts
                    imageviewcontroller.myindex = self.index
                    imageviewcontroller.location = self.location
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        beginParsing()
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

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
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
