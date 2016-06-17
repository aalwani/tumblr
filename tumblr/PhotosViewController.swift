//
//  PhotosViewController.swift
//  tumblr
//
//  Created by Aanya Alwani on 6/16/16.
//  Copyright © 2016 Aanya Alwani. All rights reserved.
//

import UIKit
import AFNetworking

class PhotosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var image: UIImage!
    
    @IBOutlet weak var imageView21: UIImageView!
    
    var posts: [NSDictionary] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 240
        tableView.delegate=self
        tableView.dataSource=self
                let url = NSURL(string:"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) in
            if let data = data {
                if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(data, options:[]) as? NSDictionary {
                    print("responseDictionary: \(responseDictionary)")
                    
                    // Recall there are two fields in the response dictionary, 'meta' and 'response'.
                    // This is how we get the 'response' field
                    let responseFieldDictionary = responseDictionary["response"] as! NSDictionary
                    
                    // This is where you will store the returned array of posts in your posts property
                    // self.posts = responseFieldDictionary["posts"] as! [NSDictionary]
                    
                    self.posts = responseFieldDictionary["posts"] as! [NSDictionary] //check this
                    self.tableView.reloadData()
                }
            }
        });
        task.resume()
        
        // Do any additional setup after loading the view.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
            return posts.count
       
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath:   NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("PhotoCell") as! PhotoCell
        let post = posts[indexPath.row]
        let timestamp = post["timestamp"] as? String
        let photos = post.valueForKeyPath("photos") as? [NSDictionary]
        if let photos = post.valueForKeyPath("photos") as? [NSDictionary] {
            // photos is NOT nil, go ahead and access element 0 and run the code in the curly braces
        } else {
            // photos is nil. Good thing we didn't try to unwrap it!
        }
        let imageUrlString = photos![0].valueForKeyPath("original_size.url") as? String
        let imageUrl = NSURL(string: imageUrlString!)!
        if let imageUrl = NSURL(string: imageUrlString!) {
            cell.posterView.setImageWithURL(imageUrl)
        } else {
            // NSURL(string: imageUrlString!) is nil. Good thing we didn't try to unwrap it!
        }

        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let photoDetailViewController = segue.destinationViewController as! PhotoDetailsViewController
        
        let indexPath = tableView.indexPathForCell(sender as! UITableViewCell)
        let post = posts[indexPath!.row]
        let photos = post["photos"] as? [NSDictionary]
        let imageUrlString = photos![0].valueForKeyPath("original_size.url") as? String
        let imageUrl = NSURL(string: imageUrlString!)!
        //var vc = segue.destinationViewController as! PhotoDetailsViewController
        photoDetailViewController.image = self.imageView21.image
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
