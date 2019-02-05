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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self

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
            let plane = SCNPlane(width: 0.5, height: 0.4)
            guard let IDVC = storyboard?.instantiateViewController(withIdentifier: "ItemDetailVC") as? ItemDetailVC else {print("No VC Found"); return}
            plane.firstMaterial?.diffuse.contents = IDVC.view
            let planeNode = SCNNode(geometry: plane)
            node.addChildNode(planeNode)
        }
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
