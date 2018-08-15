//
//  ViewController.swift
//  ContainerViewTest
//
//  Created by Stefan Louis on 8/15/18.
//  Copyright © 2018 Stefan Louis. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {
    
    enum ForegroundState {
        case expanded
        case collapsed
    }
    
    var foregroundIsExpanded: Bool = true
    
    var nextState: ForegroundState {
        return foregroundIsExpanded ? .collapsed : .expanded
    }
    
    var runningAnimations = [UIViewPropertyAnimator]()
    var animationProgressWhenInterrupted: CGFloat = 0.0
    let duration: TimeInterval = 0.5
    
    var panGestureRecognizer: UIPanGestureRecognizer!
    
    var foregroundExpandedConstraint: NSLayoutConstraint!
    var foregroundCollapsedConstraint: NSLayoutConstraint!
    
    let testViewController: TestCollectionView = {
        let vc = TestCollectionView(collectionViewLayout: UICollectionViewFlowLayout())
        return vc
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = .white
        
        setupforegroundViewController(foregroundViewController: testViewController)
        
        let bottomView = UIView()
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.backgroundColor = .red
        view.addSubview(bottomView)
        bottomView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
        bottomView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        bottomView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
/* Uncomment and comment the code below to observe the layout issue. Notice the extra spacing above the bottom view. */
        
//        let height =  view.safeAreaLayoutGuide.layoutFrame.height - 50 - 15
//        let cellHeight = ((height) / 6)
//
//        foregroundCollapsedConstraint = NSLayoutConstraint(item: testViewController.view, attribute: .top, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1, constant: (-cellHeight) * 2 - 50)
    }
    
    func setupforegroundViewController(foregroundViewController: UIViewController) {
        
        addChildViewController(foregroundViewController)
        foregroundViewController.didMove(toParentViewController: self)
        
        guard let foregroundView = foregroundViewController.view else { return }
        foregroundView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(foregroundView)
        
        foregroundExpandedConstraint = foregroundView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15)
        
        let height =  view.safeAreaLayoutGuide.layoutFrame.height - 50 - 15
        let cellHeight = ((height) / 6)
        foregroundCollapsedConstraint = NSLayoutConstraint(item: foregroundView, attribute: .top, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1, constant: (-cellHeight) * 2 - 50)
        
        let foregroundViewControllerViewConstraints = [
            foregroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            foregroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            foregroundView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, constant: -50 - 15),
            foregroundExpandedConstraint!
        ]
        
        NSLayoutConstraint.activate(foregroundViewControllerViewConstraints)
        
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePresentPanGesture(gestureRecognizer:)))
        panGestureRecognizer.minimumNumberOfTouches = 1
        panGestureRecognizer.delegate = self
        panGestureRecognizer.cancelsTouchesInView = false
        panGestureRecognizer.isEnabled = true
        foregroundViewController.view.addGestureRecognizer(panGestureRecognizer)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

