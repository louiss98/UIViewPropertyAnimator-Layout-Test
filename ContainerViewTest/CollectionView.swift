//
//  CollectionView.swift
//  ContainerViewTest
//
//  Created by Stefan Louis on 8/15/18.
//  Copyright © 2018 Stefan Louis. All rights reserved.
//

import UIKit

class TestCollectionView: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    
    private func setupCollectionView() {
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 0
            flowLayout.headerReferenceSize =  CGSize(width: 0, height: 0)
        }
        
        collectionView?.isPagingEnabled = true
        collectionView?.contentInsetAdjustmentBehavior = .never
        collectionView?.backgroundColor = UIColor.clear
        collectionView?.contentInset = UIEdgeInsets.zero
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.delegate = self
        
        collectionView?.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        collectionView?.layer.cornerRadius = 12
        collectionView?.clipsToBounds = true
        
        collectionView?.isScrollEnabled = false

        navigationController?.isNavigationBarHidden = true
        
        view.backgroundColor = UIColor.blue
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        collectionView?.register(InteriorCollectionView.self, forCellWithReuseIdentifier: cellId)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! InteriorCollectionView
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
}

class InteriorCollectionView: UICollectionViewCell, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let testcellId = "testCellId"
    
    lazy var cellCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        
        collectionView.isPagingEnabled = true
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.backgroundColor = UIColor.green
        collectionView.contentInset = UIEdgeInsets.zero
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        collectionView.layer.cornerRadius = 12
        collectionView.clipsToBounds = true
        collectionView.isScrollEnabled = false

        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .vertical
            flowLayout.minimumLineSpacing = 0
            flowLayout.headerReferenceSize =  CGSize(width: 0, height: 0)
        }
        
        return collectionView
    }()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: testcellId, for: indexPath) as! TestCell
        cell.backgroundColor = .random()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width, height: frame.height / 6)
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        cellCollectionView.register(TestCell.self, forCellWithReuseIdentifier: testcellId)
        addSubview(cellCollectionView)
        cellCollectionView.frame = self.bounds
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class TestCell: UICollectionViewCell {
}
