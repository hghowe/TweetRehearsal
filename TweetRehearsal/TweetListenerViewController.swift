//
//  TweetListenerViewController.swift
//  TweetRehearsal
//
//  Created by Harlan.Howe on 4/26/15.
//  Copyright (c) 2015 Harlan.Howe. All rights reserved.
//

import UIKit
import Social
import Accounts

class TweetListenerViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate {

    var searchTerm:String?
    var theAlert:UIAlertController?
    var currentSearchTerm:String?
    var tweetsToShow:Array<String> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func viewWillAppear(animated: Bool) {
        performSearch()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return tweetsToShow.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! UITableViewCell

        cell.textLabel!.text = tweetsToShow[indexPath.row]
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func handleReload(sender: UIBarButtonItem) {
        
        println("Reload")
        
        
        theAlert = UIAlertController.init(title: "Update Search",
            message: "What should I search for?",
            preferredStyle: .Alert)

        theAlert!.addTextFieldWithConfigurationHandler(nil)
        let searchAction = UIAlertAction(title:"Search", style: .Default, handler: startSearch)
        let cancelAction = UIAlertAction(title:"Cancel", style: .Cancel, handler: nil)
        
        theAlert!.addAction(searchAction)
        theAlert!.addAction(cancelAction)
        
        presentViewController(theAlert!, animated: true, completion: nil)
        
    }
    
    func startSearch(action: UIAlertAction!)
    {
        currentSearchTerm = (theAlert!.textFields as! Array<UITextField>)[0].text.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        performSearch()
    }
    
    func performSearch()
    {
        let accountCollection = ACAccountStore()
        let twitterAccountType = accountCollection.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        accountCollection.requestAccessToAccountsWithType(twitterAccountType, options: nil, completion:
            { (success: Bool, error: NSError!) -> Void in
                if success
                {
                    let arrayOfAccounts = accountCollection.accountsWithAccountType(twitterAccountType)
                    if arrayOfAccounts.count > 0
                    {
                        let twitterAccount = arrayOfAccounts.last as! ACAccount
                        if let searchTerm = self.currentSearchTerm
                        {
                            let parameterDictionary = ["q":searchTerm] // what are we asking for?
                            let requestURL = NSURL(string: "https://api.twitter.com/1.1/search/tweets.json") // where are we asking?
                            /*let parameterDictionary = ["screen_name":"@hghowe",
                                                       "include_rts":"0",
                                                       "trim_user":"1",
                                                       "count":"20",
                                                        ]
                            let requestURL = NSURL(string: "https://api.twitter.com/1.1/statuses/user_timeline.json")
    */
                            
                            let postRequest = SLRequest(forServiceType: SLServiceTypeTwitter,requestMethod: SLRequestMethod.GET, URL: requestURL, parameters: parameterDictionary) // combine these last two together...
                            
                            postRequest.account = twitterAccount  // and authorize the request.
                            
                            postRequest.performRequestWithHandler({ // now ask... and process the result.
                                (responseData: NSData!,
                                    urlResponse: NSHTTPURLResponse!,
                                    error: NSError!) -> Void in
                                
                                var err: NSError?
                                var results = [AnyObject]()
                                if let results = NSJSONSerialization.JSONObjectWithData(responseData, options: NSJSONReadingOptions.MutableLeaves, error: &err) as? [String:AnyObject]
                                {
                                    self.tweetsToShow.removeAll(keepCapacity: false)
                                    if let statusResults:Array<Dictionary<String,AnyObject>> = results["statuses"] as? Array<Dictionary<String,AnyObject>>
                                    {
                                        for tweet in statusResults
                                        {
                                            self.tweetsToShow.append(tweet["text"] as! String)
                                        }
                                    }
                                    dispatch_async(dispatch_get_main_queue())
                                        { self.tableView.reloadData()}
                                }
                                else
                                {
                                    println("error loading search results.")
                                }
                            })
                        }
                        else
                        {
                            println("Nothing to search for right now.")
                        }
                        
                    }
                }
            }
        
        
        
        )
        
        
    }
    
}
