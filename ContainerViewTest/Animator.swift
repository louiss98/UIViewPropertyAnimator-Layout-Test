//
//  Animator.swift
//  ContainerViewTest
//
//  Created by Stefan Louis on 8/15/18.
//  Copyright © 2018 Stefan Louis. All rights reserved.
//

import UIKit


extension ViewController {
    
    @objc func handlePresentPanGesture(gestureRecognizer: UIPanGestureRecognizer) {
        
        let translation = gestureRecognizer.translation(in: testViewController.view)
        var fractionComplete = translation.y / (view.bounds.height - 55)
        let translatedY = self.view.center.y + translation.y
        
        var progress: CGFloat!
        
        fractionComplete = foregroundIsExpanded ? fractionComplete : -fractionComplete
        if foregroundIsExpanded == true {
            progress = (translatedY / view.center.y) - 1
        } else {
            progress = 1 - (translatedY / view.center.y)
        }
        
        progress = max(0.001, min(0.999, progress))
            
            switch gestureRecognizer.state {
            case .began:
                //print("began")
                startInteractiveTransition(gestureRecognizer: gestureRecognizer, state: nextState, duration: duration)
            case .changed:
                //print("changed")
                updateInteractiveTransition(gestureRecognizer: gestureRecognizer, fractionComplete: progress)
            case .ended:
                //print("ended")
                continueInteractiveTransition(fractionComplete: progress)
            default:
                break
            }
    }
    
    // MARK: Begin Animation
    
    func startInteractiveTransition(gestureRecognizer: UIPanGestureRecognizer, state: ForegroundState, duration: TimeInterval) {
        
        //empty or isn't running
        if runningAnimations.isEmpty {
            animateTransitionIfNeeded(state: state, duration: duration)
        }
        
        for animator in runningAnimations {
            animator.pauseAnimation()
            animationProgressWhenInterrupted = animator.fractionComplete
        }
    }
    
    // MARK: Animate Transition
    
    func animateTransitionIfNeeded(state: ForegroundState, duration: TimeInterval) {
        
        guard runningAnimations.isEmpty else {
            print("running animations not empty! will not start new")
            return
        }
        
        view.layoutIfNeeded()

        
        let containerFrameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
            [unowned self] in
            
            switch state {
            case .expanded:
                self.foregroundCollapsedConstraint?.isActive = false
                self.foregroundExpandedConstraint?.isActive = true
                self.view.layoutIfNeeded()
            case .collapsed:
                self.foregroundExpandedConstraint?.isActive = false
                self.foregroundCollapsedConstraint?.isActive = true
                self.view.layoutIfNeeded()
            }
        }
        
        containerFrameAnimator.scrubsLinearly = true
        
        containerFrameAnimator.addCompletion {  [weak self] (position) in
            
            if position == .start {
                switch state {
                case .collapsed:
                    self?.foregroundCollapsedConstraint?.isActive = false
                    self?.foregroundExpandedConstraint?.isActive = true
                    self?.foregroundIsExpanded = true
                    self?.view.layoutIfNeeded()
                case .expanded:
                    self?.foregroundExpandedConstraint?.isActive = false
                    self?.foregroundCollapsedConstraint?.isActive = true
                    self?.foregroundIsExpanded = false
                    self?.view.layoutIfNeeded()
                }
                
            } else if position == .end {
                switch state {
                case .collapsed:
                    self?.foregroundExpandedConstraint?.isActive = false
                    self?.foregroundCollapsedConstraint?.isActive = true
                    self?.foregroundIsExpanded = false
                    
                case .expanded:
                    self?.foregroundCollapsedConstraint?.isActive = false
                    self?.foregroundExpandedConstraint?.isActive = true
                    self?.foregroundIsExpanded = true
                    
                }
            }
            self?.runningAnimations.removeAll()
        }
        
            containerFrameAnimator.startAnimation()
            self.runningAnimations.append(containerFrameAnimator)

    }
    
    func updateInteractiveTransition(gestureRecognizer: UIPanGestureRecognizer, fractionComplete: CGFloat) {
        
        for animator in runningAnimations {
            if animator.isRunning {
                return
            }
        }
        
        if runningAnimations.isEmpty {
            print("running animations empty. will begin interactive transition.")
            startInteractiveTransition(gestureRecognizer: gestureRecognizer, state: nextState, duration: duration)
        }
        for animator in runningAnimations {
            animator.pauseAnimation()
            animator.fractionComplete = fractionComplete + animationProgressWhenInterrupted
        }
    }
    
    // MARK: Continue Transition
    
    func continueInteractiveTransition(fractionComplete: CGFloat) {
        
        for animator in runningAnimations {
            if animator.isRunning {
                return
            }
        }
        
        panGestureRecognizer.isEnabled = false
        
        switch nextState {
            
        case .collapsed:
            
            if fractionComplete > 0.5 {
                for animator in runningAnimations {
                    animator.pauseAnimation()
                    animator.isReversed = false
                }
            } else { //did not complete
                for animator in runningAnimations {
                    animator.pauseAnimation()
                    animator.isReversed = true
                }
            }
            
        case .expanded:
            if fractionComplete > 0.5 {
                for animator in runningAnimations {
                    animator.pauseAnimation()
                    animator.isReversed = false
                }
            } else {
                for animator in runningAnimations {
                    animator.pauseAnimation()
                    animator.isReversed = true
                }
            }
        }
        
        panGestureRecognizer.isEnabled = true
        
        let springParam = UISpringTimingParameters(dampingRatio: 1)
        
        for animator in runningAnimations {
            let fraction = animator.fractionComplete
            
            animator.continueAnimation(withTimingParameters: springParam, durationFactor: fraction)
            
        }
        print("Is the foreground expanded? : \(foregroundIsExpanded)")
    }
    
    
    
    

    
    
}
