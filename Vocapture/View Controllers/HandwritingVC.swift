/// Copyright (c) 2018 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit

let translator = ROGoogleTranslate(with: "AIzaSyAe6wO_cOPMMnhWa2_lvspJhUhDGixkrJU")


struct Language:Codable {
  var name: String
  var abbreviation: String
    init(name : String, abbreviation : String) {
        self.name = name
        self.abbreviation = abbreviation
    }
    
    init?(dictionary : [String:String]) {
        guard let title = dictionary["title"],
            let abbr = dictionary["abbr"] else { return nil }
        self.init(name: title, abbreviation: abbr)
    }
    
    var propertyListRepresentation : [String:String] {
        return ["title" : self.name, "abbr" : self.abbreviation]
    }
}

class HandWritingVC: UIViewController {
  
  
  @IBOutlet weak var mainImageView: UIImageView!
  @IBOutlet weak var tempImageView: UIImageView!
  @IBOutlet weak var checkButton: UIButton!
  @IBOutlet weak var IBLabel: UILabel!
  @IBOutlet weak var CorrectLabel: UILabel!
  @IBOutlet weak var ICLabel: UILabel!
  weak var timer: Timer?
  
  var label: String = ""
  var isCorrect: Bool = false
  var pureLabel: String = ""
    var transLabel: String = ""
  
  var lastPoint = CGPoint.zero
  var color = UIColor.black
  var brushWidth: CGFloat = 10.0
  var opacity: CGFloat = 1.0
  var swiped = false
  
  func setText(){
    IBLabel.text = self.label
  }
  
 
  
  override func viewDidLoad() {
    

    
    ComputerVisionOCR.shared.configure(
      apiKey:"b44ef5ba627e4977beea59ddde3c05af",
      baseUrl: "https://eastus.api.cognitive.microsoft.com/vision/v2.0")
    checkButton.isEnabled = false
    IBLabel.adjustsFontSizeToFitWidth = true
     IBLabel.text = label.capitalizingFirstLetter()
    IBLabel.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
    
    
    CorrectLabel.adjustsFontSizeToFitWidth = true
    CorrectLabel.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
    CorrectLabel.isHidden = true
    
    
    ICLabel.adjustsFontSizeToFitWidth = true
    ICLabel.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
    ICLabel.isHidden = true

    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    let s  = self.presentingViewController as! CameraVC
    
    if(s.lang.abbreviation != "en"){
    let p = ROGoogleTranslateParams(source: "en",
                                    target: s.lang.abbreviation,
                                    text: self.label)
    translator.translate(params: p){(result) in
      self.pureLabel = self.label
      self.transLabel = result
      self.label  = self.label.capitalizingFirstLetter() + " :: "+result
      print("Translated")
      print(self.label)
      DispatchQueue.main.async {
        self.setText()
      }
    }
    }
    
    //IBLabel.isHidden = !(s.words[label]! <= 0)
  }
  
  func startTimer() {
    timer?.invalidate()   // stops previous timer, if any
    
    let seconds = 2.75
    timer = Timer.scheduledTimer(timeInterval: seconds, target: self, selector: #selector(endPresent), userInfo: nil, repeats: false)
  }
  
  func stopTimer() {
    timer?.invalidate()
  }
  
 
  
  // MARK: - Actions
  
  @IBAction func resetPressed(_ sender: Any) {
    mainImageView.image = nil
  }
  
  @IBAction func sharePressed(_ sender: Any) {
    guard let image = mainImageView.image else {
      return
    }
    let activity = UIActivityViewController(activityItems: [image], applicationActivities: nil)
    present(activity, animated: true)
  }
  
  @objc @IBAction func endPresent(){
    self.dismiss(animated: true, completion: nil)
  }
  
  @IBAction func finished(_ sender: Any){
    print("Finished image drawing!")
    let img = imageRotatedByDegrees(oldImage: mainImageView.image!, deg: CGFloat(270))
    
    let imgData = img.jpegData(compressionQuality: 1.0)
    
    ComputerVisionOCR.shared.requestOCRString(imgData!) { parseResult in
      guard let parseResult = parseResult else { print("No text found!")
        return }
      debugPrint(parseResult) // Each line is a String in the resulting array
    }
    while(ComputerVisionOCR.shared.label == ""){}
    print("Found entry! \(ComputerVisionOCR.shared.previousLabel)")
    finishedDraw()
    
  }
  
  func finishedDraw(){
    IBLabel.isHidden = false
    
    let entered = ComputerVisionOCR.shared.previousLabel.uppercased()
    let correct = transLabel.uppercased()
    
    print("Entered: \(entered)")
    print("Correct: \(correct)")
    
    if(entered.levenshtein(correct) < 4){
      self.mainImageView.backgroundColor = UIColor.green
      CorrectLabel.isHidden = false
      isCorrect = true
    }
    else {
      self.mainImageView.backgroundColor = UIColor.red
      ICLabel.isHidden = false
      isCorrect = false
    }
    
    
    let k = UserDefaults.standard.string(forKey: "VCPLens")!+"-"+pureLabel
    let currCount = UserDefaults.standard.integer(forKey: k)
    if(isCorrect){
        if(currCount < 5){
            UserDefaults.standard.set(currCount+1, forKey: k)
        }
    }
    else{
        if(currCount > -5){
            UserDefaults.standard.set(currCount - 1, forKey: k)
        }
    }
    print("Current Count:")
    print(k)
    print(UserDefaults.standard.integer(forKey: k))
    
    
    
    self.mainImageView.alpha = 0.4
    startTimer()
    
    
    
  }
  
  @IBAction func pencilPressed(_ sender: UIButton) {
    guard let pencil = Pencil(tag: sender.tag) else {
      return
    }
    color = pencil.color
    if pencil == .eraser {
      opacity = 1.0
    }
  }
  
  func drawLine(from fromPoint: CGPoint, to toPoint: CGPoint) {
    checkButton.isEnabled = true
    UIGraphicsBeginImageContext(view.frame.size)
    guard let context = UIGraphicsGetCurrentContext() else {
      return
    }
    tempImageView.image?.draw(in: view.bounds)
    
    context.move(to: fromPoint)
    context.addLine(to: toPoint)
    
    context.setLineCap(.round)
    context.setBlendMode(.normal)
    context.setLineWidth(brushWidth)
    context.setStrokeColor(color.cgColor)
    
    context.strokePath()
    
    tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
    tempImageView.alpha = opacity
    
    UIGraphicsEndImageContext()
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else {
      return
    }
    swiped = false
    lastPoint = touch.location(in: view)
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else {
      return
    }
    swiped = true
    let currentPoint = touch.location(in: view)
    drawLine(from: lastPoint, to: currentPoint)
    
    lastPoint = currentPoint
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    if !swiped {
      // draw a single point
      drawLine(from: lastPoint, to: lastPoint)
    }
    
    // Merge tempImageView into mainImageView
    UIGraphicsBeginImageContext(mainImageView.frame.size)
    mainImageView.image?.draw(in: view.bounds, blendMode: .normal, alpha: 1.0)
    tempImageView?.image?.draw(in: view.bounds, blendMode: .normal, alpha: opacity)
    mainImageView.image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    tempImageView.image = nil
  }
  func imageRotatedByDegrees(oldImage: UIImage, deg degrees: CGFloat) -> UIImage {
    //Calculate the size of the rotated view's containing box for our drawing space
    let rotatedViewBox: UIView = UIView(frame: CGRect(x: 0, y: 0, width: oldImage.size.width, height: oldImage.size.height))
    let t: CGAffineTransform = CGAffineTransform(rotationAngle: degrees * CGFloat.pi / 180)
    rotatedViewBox.transform = t
    let rotatedSize: CGSize = rotatedViewBox.frame.size
    //Create the bitmap context
    UIGraphicsBeginImageContext(rotatedSize)
    let bitmap: CGContext = UIGraphicsGetCurrentContext()!
    //Move the origin to the middle of the image so we will rotate and scale around the center.
    bitmap.translateBy(x: rotatedSize.width / 2, y: rotatedSize.height / 2)
    //Rotate the image context
    bitmap.rotate(by: (degrees * CGFloat.pi / 180))
    //Now, draw the rotated/scaled image into the context
    bitmap.scaleBy(x: 1.0, y: -1.0)
    bitmap.draw(oldImage.cgImage!, in: CGRect(x: -oldImage.size.width / 2, y: -oldImage.size.height / 2, width: oldImage.size.width, height: oldImage.size.height))
    let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    return newImage
  }
}

extension String {
  func capitalizingFirstLetter() -> String {
    return prefix(1).uppercased() + dropFirst()
  }
  
  mutating func capitalizeFirstLetter() {
    self = self.capitalizingFirstLetter()
  }
}


