//
//  FixProcess.swift
//  ScanSafe.Mac
//
//  Created by Gao on 6/9/17.
//  Copyright © 2017 Git in Sky. All rights reserved.
//

import Cocoa

class FixProcessViewController: NSViewController {
    @IBOutlet weak var processingCollection: NSCollectionView!
    @IBOutlet weak var fixedCollection: NSCollectionView!
    
    override func viewDidLoad() {
        //processingCollection.delegate = self
        //processingCollection.dataSource = self
    }
}

/*extension FixProcessViewController: NSCollectionViewDataSource {
    
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return 25
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = collectionView.makeItem(withIdentifier: "RaidaStatusView", for: indexPath)
        guard let collectionViewItem = item as? CollectionViewItem else {return item}
        
        return item
    }
}*/
