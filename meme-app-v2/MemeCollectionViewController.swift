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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register cell classes
        //self.collectionView!.register(MemeCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
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
    

}
