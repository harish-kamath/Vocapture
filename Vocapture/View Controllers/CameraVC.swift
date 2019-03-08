//
//  CameraVC.swift
//  Vocapture
//
//  Created by Harish Kamath on 1/24/19.
//  Copyright © 2019 Harish Kamath. All rights reserved.
//

import UIKit
import ARKit
import CoreML
import Vision
import Accelerate

<<<<<<< HEAD
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
=======
class CameraVC: UIViewController, ARSCNViewDelegate,UIGestureRecognizerDelegate,ARSessionDelegate,AVCaptureVideoDataOutputSampleBufferDelegate {
>>>>>>> 71fe5a3772baf98e8f10244e06476b48843d7d72

    @IBOutlet weak var LearningButton: UIButton!
    @IBOutlet weak var LearningIconLabel: UILabel!
    @IBOutlet weak var ModulesButton: UIButton!
    @IBOutlet weak var ModulesIconLabel: UILabel!
    @IBOutlet weak var SettingsButton: UIButton!
    @IBOutlet weak var SettingsIconLabel: UILabel!
    @IBOutlet weak var InfoButton: UIButton!
    
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var cameraView: UIView!
    
    @IBOutlet weak var modeButton: UIButton!
    @IBOutlet weak var modeUpdateLabel: UILabel!
    var animView:UIView!
    
    var detectingWords:[String] = ["person"]
    
    var lang = Language(name: "Spanish", abbreviation: "es")
    let languages = [Language(name: "English", abbreviation: "en"),Language(name: "Irish", abbreviation: "ga"), Language(name: "Italian", abbreviation: "it"), Language(name: "Spanish", abbreviation: "es"), Language(name: "German", abbreviation: "de"), Language(name: "Turkish", abbreviation: "tr"), Language(name: "Vietnamese", abbreviation: "vi"), Language(name: "Swahili", abbreviation: "sw"), Language(name: "Portuguese", abbreviation: "pt")]
    var words: [String: Int] = [:]
    
    var isExploring = true
    
    
    
    private lazy var cameraLayer: AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
    private lazy var captureSession: AVCaptureSession = {
        let session = AVCaptureSession()
        session.sessionPreset = AVCaptureSession.Preset.hd1280x720
        
        guard
            let backCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
            let input = try? AVCaptureDeviceInput(device: backCamera)
            else { return session }
        session.addInput(input)
        return session
    }()
    
    
    let semaphore = DispatchSemaphore(value: 1)
    var lastExecution = Date()
    var pred:[Prediction]!
    var screenHeight: Double?
    var screenWidth: Double?
    let ssdPostProcessor = SSDPostProcessor(numAnchors: 1917, numClasses: 90)
    var visionModel:VNCoreMLModel?
    
    
    let numBoxes = 100
    var boundingBoxes: [BoundingBox] = []
    let multiClass = true
    
    
    var node: SCNNode?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
        tap.delegate = self // This is not required
        
        self.cameraView.addGestureRecognizer(tap)
        //self.sceneView.addGestureRecognizer(tap)
        //self.sceneView.delegate = self
        //self.sceneView.session.delegate = self
        
        self.cameraView?.layer.addSublayer(self.cameraLayer)
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "MyQueue"))
        self.captureSession.addOutput(videoOutput)
        self.captureSession.startRunning()
        
        setupVision()
        
        setupBoxes()
        
        self.cameraView.addGestureRecognizer(tap)
        
        screenWidth = Double(view.frame.width)
        screenHeight = Double(view.frame.height)
        
        LearningIconLabel.alpha = 0
        ModulesIconLabel.alpha = 0
        SettingsIconLabel.alpha = 0
        
        modeUpdateLabel.alpha = 0
        
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
        //sceneView.session.run(configuration)
        
        // Run the view's session
        //sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        //sceneView.session.pause()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.cameraLayer.frame = self.cameraView?.bounds ?? .zero
    }
    /*
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
 */
    
    @objc func handleTap(sender: UITapGestureRecognizer? = nil) {
        let point = sender?.location(in: self.view)
        let x = point!.x
        let y = point!.y
        
        for p in pred {
            let z = p.finalPrediction
            let t = z.toCGRect(imgWidth: self.screenWidth!, imgHeight: self.screenWidth!, xOffset: 0, yOffset: (self.screenHeight! - self.screenWidth!)/2)
            let a = t.minX
            let b = t.maxX
            let c = t.minY
            let d = t.maxY
            //print(self.ssdPostProcessor.classNames![p.detectedClass])
            //print("X: \(x) Y: \(y)")
            //print("X: \(a) \(b) Y: \(c) \(d)")
            if((x >= a && x <= b) && (y >= c && y <= d)){
                print(self.ssdPostProcessor.classNames![p.detectedClass])
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "labelChooser") as! HandWritingVC
                controller.label = self.ssdPostProcessor.classNames![p.detectedClass]
                self.present(controller, animated: true, completion: {
                    print("Done")
                })
                break
            }
        }
        
        // handling code
    }
    
    
    @IBAction func expandMenu(_ sender:UIButton){
        if(LearningButton.alpha < 1){
            UIView.animate(withDuration: 0.2, animations: {
            self.LearningButton.alpha = 1
            self.LearningButton.frame = self.LearningButton.frame.offsetBy(dx: 0.0, dy: -20.0)
                self.LearningButton.isEnabled = true
            self.LearningIconLabel.alpha = 1
            self.LearningIconLabel.frame = self.LearningIconLabel.frame.offsetBy(dx: 0.0, dy: -20.0)
                
            self.ModulesButton.alpha = 0
                self.ModulesButton.frame = self.ModulesButton.frame.offsetBy(dx: 0.0, dy: -20.0)
                self.ModulesButton.isEnabled = false
            self.ModulesIconLabel.alpha = 0
                self.ModulesIconLabel.frame = self.ModulesIconLabel.frame.offsetBy(dx: 0.0, dy: -20.0)
                
            self.SettingsButton.alpha = 0
                self.SettingsButton.frame = self.SettingsButton.frame.offsetBy(dx: 0.0, dy: -20.0)
                self.SettingsButton.isEnabled = false
            self.SettingsIconLabel.alpha = 0
                self.SettingsIconLabel.frame = self.SettingsIconLabel.frame.offsetBy(dx: 0.0, dy: -20.0)
                
                
            self.InfoButton.tintColor = UIColor.white
            }, completion: nil)
        }
        else{
            UIView.animate(withDuration: 0.2, animations: {
                self.LearningButton.alpha = 0
                self.LearningButton.frame = self.LearningButton.frame.offsetBy(dx: 0.0, dy: 20.0)
                self.LearningButton.isEnabled = false
                self.LearningIconLabel.alpha = 0
                self.LearningIconLabel.frame = self.LearningIconLabel.frame.offsetBy(dx: 0.0, dy: 20.0)
                
                self.ModulesButton.alpha = 0
                self.ModulesButton.frame = self.ModulesButton.frame.offsetBy(dx: 0.0, dy: 20.0)
                self.ModulesButton.isEnabled = false
                self.ModulesIconLabel.alpha = 0
                self.ModulesIconLabel.frame = self.ModulesIconLabel.frame.offsetBy(dx: 0.0, dy: 20.0)
                
                self.SettingsButton.alpha = 0
                self.SettingsButton.frame = self.SettingsButton.frame.offsetBy(dx: 0.0, dy: 20.0)
                self.SettingsButton.isEnabled = false
                self.SettingsIconLabel.alpha = 0
                self.SettingsIconLabel.frame = self.SettingsIconLabel.frame.offsetBy(dx: 0.0, dy: 20.0)
                
                self.InfoButton.tintColor = UIColor.lightGray
            }, completion: nil)
            
        }
    }
    
    @IBAction func changeMode(){
        var modeImg:UIImage = UIImage()
        if(animView.backgroundColor == UIColor.purple.withAlphaComponent(0.6)){
            animView.backgroundColor = UIColor.blue.withAlphaComponent(0.6)
            modeImg = UIImage(named: "LearningModeIcon")!
            modeUpdateLabel.text = "Learning"
            isExploring = false
        }
        else{
            animView.backgroundColor = UIColor.purple.withAlphaComponent(0.6)
            modeImg = UIImage(named: "ToolModeIcon")!
            modeUpdateLabel.text = "Explore"
            isExploring = true
        }
        
        self.view.sendSubviewToBack(animView)
        self.view.sendSubviewToBack(cameraView)
        
        DispatchQueue.main.async {
            
            UIView.animate(withDuration: 0.4, delay: 0, options: .curveLinear, animations: {
                self.modeButton.alpha = 0
                self.modeUpdateLabel.alpha = 1
            }, completion: nil)
            self.modeButton.setImage(modeImg, for: .normal)
            UIView.animate(withDuration: 0.4, delay: 1.3, options: .curveLinear, animations: {
                self.modeButton.alpha = 1
                self.modeUpdateLabel.alpha = 0
            }, completion: nil)
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.animView.frame = CGRect(x: -self.view.frame.width/2, y: -self.view.frame.height/2, width: self.view.frame.width*2, height: self.view.frame.height*2)
        }, completion: {finished in
            
            UIView.animate(withDuration: 0.5, delay: 1.3, options: .curveLinear, animations: {
                self.animView.alpha = 0
            }, completion: {finished in
                self.animView.alpha = 1
                self.animView.frame = CGRect(x: self.modeButton.frame.midX, y: self.modeButton.frame.midY, width: 0, height: 0)
            })
        })
    }
    
    @IBAction func setLanguage(_ sender:Any){
        var picker: TCPickerViewInput = TCPickerView()
        picker.title = "Language"
        var values = languages.map{TCPickerView.Value(title: $0.name, isChecked: ($0.name == self.lang.name))}
        picker.values = values
        picker.delegate = self as? TCPickerViewOutput
        picker.selection = .single
        picker.completion = { (selectedIndexes) in
            for i in selectedIndexes {
                for l in self.languages{
                    if(l.name == values[i].title){
                        self.lang = l
                    }
                }
            }
        }
        picker.show()
    }

    
    /*
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        let pixelBuffer = frame.capturedImage
        let scale = CMTimeScale(NSEC_PER_SEC)
        let pts = CMTime(value: CMTimeValue(frame.timestamp * Double(scale)),
                         timescale: scale)
        var timingInfo = CMSampleTimingInfo(duration: CMTime.invalid,
                                            presentationTimeStamp: pts,
                                            decodeTimeStamp: CMTime.invalid)
        
        var vidDesc: CMVideoFormatDescription? = nil
        CMVideoFormatDescriptionCreateForImageBuffer(allocator: kCFAllocatorDefault, imageBuffer: pixelBuffer, formatDescriptionOut: &vidDesc)
        
        var sB:CMSampleBuffer? = nil
        CMSampleBufferCreateReadyWithImageBuffer(allocator: kCFAllocatorDefault, imageBuffer: pixelBuffer, formatDescription: vidDesc!, sampleTiming: &timingInfo, sampleBufferOut: &sB)
        let sampleBuffer = sB!
        
        guard let visionModel = self.visionModel else {
            return
        }
        
        var requestOptions:[VNImageOption : Any] = [:]
        if let cameraIntrinsicData = CMGetAttachment(sampleBuffer, key: kCMSampleBufferAttachmentKey_CameraIntrinsicMatrix, attachmentModeOut: nil) {
            requestOptions = [.cameraIntrinsics:cameraIntrinsicData]
        }
        let orientation = CGImagePropertyOrientation(rawValue: UInt32(EXIFOrientation.rightTop.rawValue))
        
        let trackingRequest = VNCoreMLRequest(model: visionModel) { (request, error) in
            guard let predictions = self.processClassifications(for: request, error: error) else { return }
            DispatchQueue.main.async {
                self.drawBoxes(predictions: predictions)
            }
            self.semaphore.signal()
        }
        trackingRequest.imageCropAndScaleOption = VNImageCropAndScaleOption.centerCrop
        
        
        self.semaphore.wait()
        do {
            let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: orientation!, options: requestOptions)
            try imageRequestHandler.perform([trackingRequest])
        } catch {
            print(error)
            self.semaphore.signal()
            
        }
    }
 */
    
    
    
    
    func setupBoxes() {
        // Create shape layers for the bounding boxes.
        for _ in 0..<numBoxes {
            let box = BoundingBox()
            box.addToLayer(cameraView.layer)
            self.boundingBoxes.append(box)
        }
    }
    
    
    func setupVision() {
        guard let visionModel = try? VNCoreMLModel(for: ssd_mobilenet_feature_extractor().model)
            else { fatalError("Can't load VisionML model") }
        self.visionModel = visionModel
    }
    
    
    
    func drawBoxes(predictions: [Prediction]) {
        pred = predictions
        for (index, prediction) in predictions.enumerated() {
            if let classNames = self.ssdPostProcessor.classNames {
               //print("Class: \(classNames[prediction.detectedClass])")
                
                if(isExploring || detectingWords.contains(classNames[prediction.detectedClass])){
                
                let textColor: UIColor
                let textLabel = String(format: "%@", classNames[prediction.detectedClass])
                
                
                textColor = UIColor.white
                let rect = prediction.finalPrediction.toCGRect(imgWidth: self.screenWidth!, imgHeight: self.screenWidth!, xOffset: 0, yOffset: (self.screenHeight! - self.screenWidth!)/2)
                self.boundingBoxes[index].show(frame: rect,
                                               label: textLabel,
                                               color: UIColor.black, textColor: textColor)
            }
            }
        }
        for index in predictions.count..<self.numBoxes {
            self.boundingBoxes[index].hide()
        }
    }
    
    func processClassifications(for request: VNRequest, error: Error?) -> [Prediction]? {
        guard let results = request.results as? [VNCoreMLFeatureValueObservation] else {
            return nil
        }
        guard results.count == 2 else {
            return nil
        }
        guard let boxPredictions = results[1].featureValue.multiArrayValue,
            let classPredictions = results[0].featureValue.multiArrayValue else {
                return nil
        }
        let predictions = self.ssdPostProcessor.postprocess(boxPredictions: boxPredictions, classPredictions: classPredictions)
        return predictions
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        guard let visionModel = self.visionModel else {
            return
        }
        
        var requestOptions:[VNImageOption : Any] = [:]
        if let cameraIntrinsicData = CMGetAttachment(sampleBuffer, key: kCMSampleBufferAttachmentKey_CameraIntrinsicMatrix, attachmentModeOut: nil) {
            requestOptions = [.cameraIntrinsics:cameraIntrinsicData]
        }
        let orientation = CGImagePropertyOrientation(rawValue: UInt32(EXIFOrientation.rightTop.rawValue))
        
        let trackingRequest = VNCoreMLRequest(model: visionModel) { (request, error) in
            guard let predictions = self.processClassifications(for: request, error: error) else { return }
            DispatchQueue.main.async {
                self.drawBoxes(predictions: predictions)
            }
            self.semaphore.signal()
        }
        trackingRequest.imageCropAndScaleOption = VNImageCropAndScaleOption.centerCrop
        
        
        self.semaphore.wait()
        do {
            let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: orientation!, options: requestOptions)
            try imageRequestHandler.perform([trackingRequest])
        } catch {
            print(error)
            self.semaphore.signal()
            
        }
    }
    
    func sigmoid(_ val:Double) -> Double {
        return 1.0/(1.0 + exp(-val))
    }
    
    func softmax(_ values:[Double]) -> [Double] {
        if values.count == 1 { return [1.0]}
        guard let maxValue = values.max() else {
            fatalError("Softmax error")
        }
        let expValues = values.map { exp($0 - maxValue)}
        let expSum = expValues.reduce(0, +)
        return expValues.map({$0/expSum})
    }
    
    public static func softmax2(_ x: [Double]) -> [Double] {
        var x:[Float] = x.compactMap{Float($0)}
        let len = vDSP_Length(x.count)
        
        // Find the maximum value in the input array.
        var max: Float = 0
        vDSP_maxv(x, 1, &max, len)
        
        // Subtract the maximum from all the elements in the array.
        // Now the highest value in the array is 0.
        max = -max
        vDSP_vsadd(x, 1, &max, &x, 1, len)
        
        // Exponentiate all the elements in the array.
        var count = Int32(x.count)
        vvexpf(&x, x, &count)
        
        // Compute the sum of all exponentiated values.
        var sum: Float = 0
        vDSP_sve(x, 1, &sum, len)
        
        // Divide each element by the sum. This normalizes the array contents
        // so that they all add up to 1.
        vDSP_vsdiv(x, 1, &sum, &x, 1, len)
        
        let y:[Double] = x.compactMap{Double($0)}
        return y
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
    
    
    enum EXIFOrientation : Int32 {
        case topLeft = 1
        case topRight
        case bottomRight
        case bottomLeft
        case leftTop
        case rightTop
        case rightBottom
        case leftBottom
        
        var isReflect:Bool {
            switch self {
            case .topLeft,.bottomRight,.rightTop,.leftBottom: return false
            default: return true
            }
        }
    }

}
