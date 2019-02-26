//
//  CameraVC.swift
//  Vocapture
//
//  Created by Harish Kamath on 1/24/19.
//  Copyright © 2019 Harish Kamath. All rights reserved.
//

import UIKit
import ARKit

class CameraVC: UIViewController, ARSCNViewDelegate {

    @IBOutlet weak var LearningButton: UIButton!
    @IBOutlet weak var ModulesButton: UIButton!
    @IBOutlet weak var SettingsButton: UIButton!
    @IBOutlet weak var InfoButton: UIButton!
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var modeButton: UIButton!
    var animView:UIView!
    
    var node: SCNNode?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        
        animView = UIView(frame: CGRect(x: modeButton.frame.midX, y: modeButton.frame.midY, width: 0, height: 0))
        animView.layer.cornerRadius = self.view.frame.width/2
        animView.backgroundColor = UIColor.purple.withAlphaComponent(0.3)
        self.view.addSubview(animView)

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        guard let referenceObjects = ARReferenceObject.referenceObjects(inGroupNamed: "objects", bundle: nil) else {
            fatalError("Missing expected asset catalog resources.")
        }
        configuration.detectionObjects = referenceObjects
        sceneView.session.run(configuration)
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if anchor is ARObjectAnchor {
            print("Item Found!")
            let plane = SCNPlane(width: 0.3, height: 0.15)
            plane.cornerRadius = 0.01
            guard let IDVC = storyboard?.instantiateViewController(withIdentifier: "ItemDetailVC") as? ItemDetailVC else {print("No VC Found"); return}
            plane.firstMaterial?.diffuse.contents = IDVC.view
            let planeNode = SCNNode(geometry: plane)
            
            self.node = planeNode
            node.addChildNode(planeNode)
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        
        //1. Get The Current Node On Screen & The Camera Point Of View
        guard let nodeToPosition = self.node, let pointOfView = sceneView.pointOfView else { return }
        
        //2. Set The Position Of The Node 1m Away From The Camera
        nodeToPosition.simdPosition.z = pointOfView.presentation.worldPosition.z - 0.1
        
        //3. Get The Current Distance Between The SCNNode & The Camera
        let positionOfNode = SCNVector3ToGLKVector3(nodeToPosition.presentation.worldPosition)
        
        let positionOfCamera = SCNVector3ToGLKVector3(pointOfView.presentation.worldPosition)
        
        let distanceBetweenNodeAndCamera = GLKVector3Distance(positionOfNode, positionOfCamera)
        
        print(distanceBetweenNodeAndCamera)
        
    }
    
    
    @IBAction func expandMenu(_ sender:UIButton){
        if(LearningButton.alpha < 1){
            UIView.animate(withDuration: 0.2, animations: {
            self.LearningButton.alpha = 1
            self.LearningButton.frame = self.LearningButton.frame.offsetBy(dx: 0.0, dy: -20.0)
                self.LearningButton.isEnabled = true
                
            self.ModulesButton.alpha = 1
                self.ModulesButton.frame = self.ModulesButton.frame.offsetBy(dx: 0.0, dy: -20.0)
                self.ModulesButton.isEnabled = true
                
            self.SettingsButton.alpha = 1
                self.SettingsButton.frame = self.SettingsButton.frame.offsetBy(dx: 0.0, dy: -20.0)
                self.SettingsButton.isEnabled = true
                
                
            self.InfoButton.tintColor = UIColor.white
            }, completion: nil)
        }
        else{
            UIView.animate(withDuration: 0.2, animations: {
                self.LearningButton.alpha = 0
                self.LearningButton.frame = self.LearningButton.frame.offsetBy(dx: 0.0, dy: 20.0)
                self.LearningButton.isEnabled = false
                
                self.ModulesButton.alpha = 0
                self.ModulesButton.frame = self.ModulesButton.frame.offsetBy(dx: 0.0, dy: 20.0)
                self.ModulesButton.isEnabled = false
                
                self.SettingsButton.alpha = 0
                self.SettingsButton.frame = self.SettingsButton.frame.offsetBy(dx: 0.0, dy: 20.0)
                self.SettingsButton.isEnabled = false
                
                self.InfoButton.tintColor = UIColor.lightGray
            }, completion: nil)
            
        }
    }
    
    @IBAction func changeMode(){
        if(animView.backgroundColor == UIColor.purple.withAlphaComponent(0.3)){
            animView.backgroundColor = UIColor.green.withAlphaComponent(0.3)
            modeButton.setImage(UIImage(named: "ToolModeIcon"), for: .normal)
        }
        else{
            animView.backgroundColor = UIColor.purple.withAlphaComponent(0.3)
            modeButton.setImage(UIImage(named: "LearningModeIcon"), for: .normal)
        }
        UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveEaseOut, animations: {
            self.animView.frame = CGRect(x: -self.view.frame.width/2, y: -self.view.frame.height/2, width: self.view.frame.width*2, height: self.view.frame.height*2)
        }, completion: {finished in
            UIView.animate(withDuration: 0.5, delay: 0.2, options: .curveLinear, animations: {
                self.animView.alpha = 0
            }, completion: {finished in
                self.animView.alpha = 1
                self.animView.frame = CGRect(x: self.modeButton.frame.midX, y: self.modeButton.frame.midY, width: 0, height: 0)
            })
        })
    }
    
    
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
