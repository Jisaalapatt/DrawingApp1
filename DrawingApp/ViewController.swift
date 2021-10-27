//
//  ViewController.swift
//  DrawingApp
//
//  Created by Jisa Gigi on 10/25/21.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var stack2: UIStackView!
    
    @IBOutlet weak var stack1: UIStackView!
    @IBOutlet weak var reveal: UIButton!
    @IBOutlet weak var secondImage: UIImageView!
    
    @IBOutlet weak var brushSize: UILabel!
    var swiped : Bool = false
    var lastPoint = CGPoint.zero
    
    var red: CGFloat = 0.0
    var green : CGFloat = 0.0
    var blue: CGFloat = 0.0
    
    var brushWidth : CGFloat  = 5.0
    var oopacity: CGFloat = 1.0
    @IBOutlet weak var minusBtn: UIButton!
    @IBOutlet weak var plusBtn: UIButton!
    
    var hideState = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        reveal.isHidden = true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        swiped = false
        if let touch = touches.first as UITouch? {
            lastPoint = touch.location(in: self.view)
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        swiped = true
        if let touch = touches.first as UITouch?{
            let currentPoint = touch.location(in: view)
            drawLine(lastPoint, toPoint: currentPoint)
            lastPoint = currentPoint
        }
        
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if !swiped {
            drawLine(lastPoint, toPoint: lastPoint)
            
            
        }
        UIGraphicsBeginImageContext(secondImage.frame.size)
        
        imageView.image?.draw(in: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height), blendMode: CGBlendMode.normal, alpha:1.0)
        
        
        secondImage.image?.draw(in: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height), blendMode: CGBlendMode.normal, alpha:oopacity)
        
        imageView.image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        secondImage.image = nil
        
    }
    
    func drawLine(_ fromPoint: CGPoint, toPoint: CGPoint ){
        
        UIGraphicsBeginImageContext(view.frame.size)
        
        let context = UIGraphicsGetCurrentContext()
        secondImage.image?.draw(in: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        
        context?.move(to: CGPoint(x: fromPoint.x, y: fromPoint.y))
        context?.addLine(to: CGPoint(x: fromPoint.x, y: fromPoint.y) )
        context?.setLineCap(CGLineCap.round)
        
        context?.setLineWidth(brushWidth)
        context?.setStrokeColor(red:red, green:green, blue:blue, alpha:oopacity)
        context?.setBlendMode(CGBlendMode.normal)
        context?.strokePath()
        
        secondImage.image = UIGraphicsGetImageFromCurrentImageContext()
        secondImage.alpha = oopacity
        
        UIGraphicsEndImageContext()
        
    }

    @IBAction func red(_ sender: Any) {
        (red, green,blue) = (255,0,0)
        
    }
    
    @IBAction func green(_ sender: Any) {
        (red, green,blue) = (0,255,0)

    }
    @IBAction func blue(_ sender: Any) {
        (red, green,blue) = (0,0,255)

    }
    
    @IBAction func black(_ sender: Any) {
        (red, green,blue) = (0,0,0)

    }
    
    @IBAction func eraser(_ sender: Any) {
        (red, green,blue) = (255,255,255)

    }
    @IBAction func decrement(_ sender: Any) {
        
        brushWidth -= 1
        self.brushSizeFn()
    }
    
    
    @IBAction func incremment(_ sender: Any) {
        
        brushWidth += 1
        self.brushSizeFn()

    }
    
    func brushSizeFn(){
        
        brushSize.text = String(format: "%.0f", brushWidth)
        if brushWidth == 100 {
            plusBtn.isEnabled = false
            plusBtn.alpha = 0.0
        }
        else if brushWidth == 1 {
            minusBtn.isEnabled = false
            minusBtn.alpha = 0.0
            
        }else{
            plusBtn.isEnabled = true
            plusBtn.alpha = 1.0
            minusBtn.isEnabled = true
            minusBtn.alpha = 1.0
        }
    }
    @IBAction func reset(_ sender: Any) {
        
        imageView.image = nil
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let settingVC = segue.destination as! SettingsViewController
        settingVC.delegate = self
        settingVC.brushWidth = brushWidth
        
        settingVC.red = red
        settingVC.blue = blue
        settingVC.green = green
        
        settingVC.oopacity = oopacity

        
    }
    @IBAction func save(_ sender: Any) {
        UIGraphicsBeginImageContext(imageView.bounds.size)
        imageView.image?.draw(in: CGRect(x: 0, y: 0, width: imageView.frame.size.width, height: imageView.frame.size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        let activvity = UIActivityViewController(activityItems : [image!],applicationActivities: nil)
        present(activvity, animated: true, completion: nil)
        
        
        
        
    }
    
    @IBAction func reveal(_ sender: Any) {
        stack1.isHidden = false
        stack2.isHidden = false
        reveal.isHidden = true
        reveal.alpha = 0.25
    }
    @IBAction func hide(_ sender: Any) {
        stack1.isHidden = true
        stack2.isHidden = true
        reveal.isHidden = false
    }
    
}

extension ViewController: SettingsViewControllerDelegate{
    func settingsViewControllerFinished(_ settingsViewController:SettingsViewController){
        self.brushWidth = settingsViewController.brushWidth
        self.red = settingsViewController.red
        self.green = settingsViewController.green
        self.blue = settingsViewController.blue
        
        self.oopacity = settingsViewController.oopacity
        self.brushSizeFn()
    }

}
