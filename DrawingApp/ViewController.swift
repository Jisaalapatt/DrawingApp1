//
//  ViewController.swift
//  DrawingApp
//
//  Created by Jisa Gigi on 10/25/21.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var brushSize: UILabel!
    var swiped : Bool = false
    var lastPoint = CGPoint.zero
    
    var red: CGFloat = 0.0
    var green : CGFloat = 0.0
    var blue: CGFloat = 0.0
    
    var brushWidth : CGFloat  = 5.0
    
    @IBOutlet weak var minusBtn: UIButton!
    @IBOutlet weak var plusBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
    }
    
    func drawLine(_ fromPoint: CGPoint, toPoint: CGPoint ){
        
        UIGraphicsBeginImageContext(view.frame.size)
        let context = UIGraphicsGetCurrentContext()
        imageView.image?.draw(in: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        context?.move(to: CGPoint(x: fromPoint.x, y: fromPoint.y))
        context?.addLine(to: CGPoint(x: fromPoint.x, y: fromPoint.y) )
        context?.setLineCap(CGLineCap.round)
        
        context?.setLineWidth(brushWidth)
        context?.setStrokeColor(red:red, green:green, blue:blue, alpha:1)
        context?.setBlendMode(CGBlendMode.normal)
        context?.strokePath()
        imageView.image = UIGraphicsGetImageFromCurrentImageContext()
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

        
    }
}

extension ViewController: SettingsViewControllerDelegate{
    func settingsViewControllerFinished(_ settingsViewController:SettingsViewController){
        self.brushWidth = settingsViewController.brushWidth
        self.red = settingsViewController.red
        self.green = settingsViewController.green
        self.blue = settingsViewController.blue

        self.brushSizeFn()
    }

}
