//
//  MemeTableViewController.swift
//  meme-app-v2
//
//  Created by Danilo Gomes on 05/09/2017.
//  Copyright © 2017 Danilo Gomes. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController {
    
    var memes : [Meme]?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes!.count
    }
    
    func loadMemes(){
        self.memes = AppDelegate.sharedInstance().memes
        self.tableView.reloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadMemes()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        let meme = memes![indexPath.row]
        cell.textLabel?.text = "\(meme.topText!) ... \(meme.bottomText!)"
        cell.imageView?.image = meme.memedImage
        cell.imageView?.contentMode = .scaleAspectFit
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if "addMeme" == segue.identifier {
//            let nc = segue.destination as! UINavigationController
//            let vc = nc.viewControllers[0] as! EditMemeViewController
//            vc.memes = memes
//        } else if "editMeme" == segue.identifier {
//            let nc = segue.destination as! UINavigationController
//            let vc = nc.viewControllers[0] as! EditMemeViewController
//            vc.memes = memes
//        }
    }
    
}
