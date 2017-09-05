//
//  MemeCollectionViewController.swift
//  meme-app-v2
//
//  Created by Danilo Gomes on 05/09/2017.
//  Copyright © 2017 Danilo Gomes. All rights reserved.
//

import UIKit

private let reuseIdentifier = "meme"

class MemeCollectionViewController: UICollectionViewController {

    var memes : [Meme]?
    var selectedMeme : Meme?
    
    func loadMemes(){
        self.memes = AppDelegate.sharedInstance().memes
        self.collectionView!.reloadData()
    }
    
    @IBAction func didTapOnAddButton(_ sender: Any) {
        navigateToEditor(meme: nil)
    }
    
    func navigateToEditor(meme : Meme?){
        self.selectedMeme = meme
        self.performSegue(withIdentifier: "showEditor", sender: self)
    }
    
    func navigateToDetails(meme : Meme?){
        self.selectedMeme = meme
        self.performSegue(withIdentifier: "showDetails", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadMemes()
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let mes = self.memes {
            return mes.count
        }
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        let memeCell = cell as! MemeCollectionViewCell
        let row = memes![indexPath.row]
        memeCell.imageView.image = row.memedImage
        
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let meme = memes![indexPath.row]
        navigateToDetails(meme: meme)
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
    
    
}
