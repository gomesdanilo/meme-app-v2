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
    var selectedMeme : Meme?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func didTapOnAddButton(_ sender: Any) {
        self.navigateToEditor(meme: nil)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes!.count
    }
    
    func navigateToEditor(meme : Meme?){
        self.selectedMeme = meme
        self.performSegue(withIdentifier: "showEditor", sender: self)
    }
    
    func navigateToDetails(meme : Meme?){
        self.selectedMeme = meme
        self.performSegue(withIdentifier: "showDetails", sender: self)
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let meme = memes![indexPath.row]
        self.navigateToDetails(meme: meme)
    }
    
    func getEditMemeViewController(segue: UIStoryboardSegue) -> EditMemeViewController {
        let nc = segue.destination as! UINavigationController
        let vc = nc.viewControllers[0] as! EditMemeViewController
        return vc
    }

    func getDetailsViewController(segue: UIStoryboardSegue) -> DetailsViewController {
        let vc = segue.destination as! DetailsViewController
        return vc
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if "showEditor" == segue.identifier {
            let vc = getEditMemeViewController(segue: segue)
            vc.memeToEdit = self.selectedMeme
        } else if "showDetails" == segue.identifier {
            let vc = getDetailsViewController(segue: segue)
            vc.memedImage = self.selectedMeme?.memedImage
        }
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let action = UITableViewRowAction(style: .normal, title: "EDIT") { (action, indexPath) in
            let meme = self.memes![indexPath.row]
            self.navigateToEditor(meme: meme)
        }
        return [action]
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
    }
}
