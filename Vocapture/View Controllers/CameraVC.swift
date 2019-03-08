//
//  CameraVC.swift
//  Vocapture
//
//  Created by Harish Kamath on 1/24/19.
//  Copyright © 2019 Harish Kamath. All rights reserved.
//

import UIKit
import ARKit

public var lenses = [
    "School" : ["person", "bicycle", "backpack", "book", "scissors", "clock", "cell phone",        "keyboard", "laptop", "chair", "dining table", "handbag", "umbrella", "bottle"],
    "Kitchen" : ["bottle", "person", "wine glass", "cup", "fork", "knife", "spoon", "bowl", "chair", "couch", "potted plant", "dining table", "microwave", "oven", "toaster", "sink", "refrigerator", "vase"],
    "Office" : ["person", "backpack", "clock", "cell phone", "keyboard", "laptop", "chair", "dining table", "handbag", "umbrella", "tie", "suitcase"],
    "Household" : ["microwave", "oven", "toaster", "sink", "refrigerator", "chair", "couch", "potted plant", "bed", "dining table", "toilet"],
    "Food" : ["banana", "apple", "sandwich", "orange", "broccoli", "carrot", "hot dog", "pizza", "donut", "cake"],
    "Bathroom" : ["hair drier", "toothbrush", "toilet", "sink", "potted plant"],
    "Recreation" : ["frisbee", "skis", "snowboard", "sports ball", "kite", "baseball bat", "baseball", "glove", "skateboard", "surfboard", "tennis racket"],
    "Animals" : ["bird", "cat", "dog", "horse", "sheep", "cow", "elephant", "bear", "zebra", "giraffe"],
    "Furniture" : ["chair", "couch", "potted plant", "bed", "dining table", "toilet", "microwave", "oven", "toaster", "sink", "refrigerator"],
    "Signals" : ["traffic light", "fire hydrant", "stop sign", "parking meter", "bench"],
    "Technology" : ["tv", "laptop", "mouse", "remote", "keyboard", "cell phone"],
    "Shopping" : ["backpack", "umbrella", "handbag", "tie", "vase", "bottle", "wine", "glass", "cup", "fork", "knife", "spoon", "bowl"],
    "Vehicles" : ["bicycle", "car", "motorcycle", "airplane", "bus", "train", "truck", "boat"],
]

class CameraVC: UIViewController, ARSCNViewDelegate {

    @IBOutlet weak var LearningButton: UIButton!
    @IBOutlet weak var ModulesButton: UIButton!
    @IBOutlet weak var SettingsButton: UIButton!
    @IBOutlet weak var InfoButton: UIButton!
    @IBOutlet weak var sceneView: ARSCNView!
    
    var node: SCNNode?
    
    
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
