////
////  GameViewController.swift
////  Snake
////
////  Created by João de Vasconcelos on 30/10/2016.
////  Copyright © 2016 João de Vasconcelos. All rights reserved.
////
//
//import UIKit
//import SpriteKit
//import GameplayKit
//
//class GameViewController: UIViewController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        // Load 'GameScene.sks' as a GKScene. This provides gameplay related content
//        // including entities and graphs.
//        if let scene = GKScene(fileNamed: "GameScene") {
//            
//            // Get the SKScene from the loaded GKScene
//            if let sceneNode = scene.rootNode as! GameScene? {
//                
//                // Copy gameplay related content over to the scene
//                sceneNode.entities = scene.entities
//                sceneNode.graphs = scene.graphs
//                
//                // Set the scale mode to scale to fit the window
//                sceneNode.scaleMode = .aspectFill
//                
//                // Present the scene
//                if let view = self.view as! SKView? {
//                    view.presentScene(sceneNode)
//                    
//                    view.ignoresSiblingOrder = true
//                    
//                    view.showsFPS = true
//                    view.showsNodeCount = true
//                }
//            }
//        }
//    }
//
//    override var shouldAutorotate: Bool {
//        return true
//    }
//
//    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
//        if UIDevice.current.userInterfaceIdiom == .phone {
//            return .allButUpsideDown
//        } else {
//            return .all
//        }
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Release any cached data, images, etc that aren't in use.
//    }
//
//    override var prefersStatusBarHidden: Bool {
//        return true
//    }
//}









//
//  Snake
//
//  GameViewController.swift
//
//  Created by João de Vasconcelos.
//  Copyright (c) 2014 João de Vasconcelos. All rights reserved.
//

import SpriteKit
import iAd

class GameViewController: UIViewController, ADBannerViewDelegate {
    
    var bannerView:ADBannerView?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let scene = GameScene(size: view.bounds.size)
        let skView = self.view as! SKView
        
        scene.scaleMode = .aspectFill
        
        skView.ignoresSiblingOrder = true
        
        //        self.canDisplayBannerAds = true
        //        self.bannerView?.delegate = self
        //        self.bannerView?.hidden = true
        
        skView.presentScene(scene)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func bannerViewDidLoadAd(_ banner: ADBannerView!) {
        self.bannerView?.isHidden = false
    }
    
    func bannerViewActionShouldBegin(_ banner: ADBannerView!, willLeaveApplication willLeave: Bool) -> Bool {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "pauseGameNotification"), object:nil)
        return willLeave
    }
    
    func bannerView(_ banner: ADBannerView!, didFailToReceiveAdWithError error: Error!) {
        self.bannerView?.isHidden = true
    }
    
}
