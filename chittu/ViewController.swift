//
//  ViewController.swift
//  chittu
//
//  Created by Vara Prasada Gopi Srinath Samudrala on 3/10/18.
//  Copyright © 2018 Vara Prasada Gopi Srinath Samudrala. All rights reserved.
//

import UIKit
import ARKit
import Each

class ViewController: UIViewController {
    var timer = Each(1).seconds
    var countdown = 10
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var play: UIButton!
    @IBOutlet weak var sceneView: ARSCNView!
    let configuration = ARWorldTrackingConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints,ARSCNDebugOptions.showWorldOrigin]
        self.sceneView.session.run(configuration)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self,action: #selector(handleTap))
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func play(_ sender: Any) {
        self.setTimer()
        self.addNode()
        self.play.isEnabled = false
    }
    
    @IBAction func reset(_ sender: Any) {
        self.timer.stop()
        self.restoreTimer()
        self.play.isEnabled = true
        sceneView.scene.rootNode.enumerateChildNodes{ (node,_) in
            node.removeFromParentNode()
        }
    }
    
    func addNode(){
        let jellyFishScene = SCNScene(named: "art.scnassets/Jellyfish.scn")
        let jellyfishNode = jellyFishScene?.rootNode.childNode(withName: "Jellyfish", recursively: false)
        jellyfishNode?.position = SCNVector3(
            randomNumbers(firstNum: -1 , secondNum: 1),
            randomNumbers(firstNum: -0.5 , secondNum: 0.5),
            randomNumbers(firstNum: -1 , secondNum: 1)
        )
        self.sceneView.scene.rootNode.addChildNode(jellyfishNode!)
    }
    @objc func handleTap(sender: UITapGestureRecognizer) {
        let sceneViewTappedOn = sender.view as! SCNView
        let touchCoordinates = sender.location(in: sceneViewTappedOn)
        let hitTest = sceneViewTappedOn.hitTest(touchCoordinates)
        if hitTest.isEmpty{
            print("Didn't touch")
        } else {
            if countdown > 0 {
                let results = hitTest.first!
                let node = results.node
                if node.animationKeys.isEmpty {
                    SCNTransaction.begin()
                    self.animateNode(node: node)
                    SCNTransaction.completionBlock = {
                        node.removeFromParentNode()
                        self.addNode()
                        self.restoreTimer()
                    }
                    SCNTransaction.commit()
                }
            }
        }
    }
    
    func animateNode(node: SCNNode) {
        let spin = CABasicAnimation(keyPath: "position")
        spin.fromValue = node.presentation.position
        spin.toValue = SCNVector3(0,0,node.presentation.position.z - 1)
        spin.duration = 0.07
        spin.autoreverses = true
        spin.repeatCount = 3
        node.addAnimation(spin, forKey: "position")
    }
    
    func randomNumbers(firstNum: CGFloat,secondNum: CGFloat) -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs(firstNum-secondNum) + min(firstNum,secondNum)
    }
    
    func setTimer()   {
        self.timer.perform { () -> NextStep in
            self.countdown -= 1
            self.timerLabel.text = String(self.countdown)
            if self.countdown == 0 {
                self.timerLabel.text = "you lose"
                return .stop
            }
            return .continue
        }
    }
    
    func restoreTimer(){
        self.countdown = 10
        self.timerLabel.text = String(self.countdown)
    }
    

}

