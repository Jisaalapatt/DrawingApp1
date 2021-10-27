//
//  SettingsViewController.swift
//  DrawingApp
//
//  Created by Jisa Gigi on 10/26/21.
//

import UIKit

protocol SettingsViewControllerDelegate : class{
    func settingsViewControllerFinished(_ settingsViewController:SettingsViewController)
}

class SettingsViewController: UIViewController {

    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var bLabel: UILabel!
    @IBOutlet weak var bSize: UISlider!
    @IBOutlet weak var oLabel: UILabel!
    @IBOutlet weak var opacity: UISlider!
    @IBOutlet weak var redSlider: UISlider!
    
    @IBOutlet weak var rLabel: UILabel!
    @IBOutlet weak var blueSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var gLabel: UILabel!
    @IBOutlet weak var blueLabel: UILabel!
    
    var brushWidth : CGFloat = 40.0
    var red :CGFloat = 0.0
    var blue :CGFloat = 0.0
    var green :CGFloat = 0.0
    
    var delegate: SettingsViewControllerDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updatePrevview()
        bLabel.text = String(format: "Brush Size: %.0f", brushWidth)
        bSize.value = Float(brushWidth)
        
        
        redSlider.value = Float(red*255)
        blueSlider.value = Float(blue*255)
        greenSlider.value = Float(green*255)
        rLabel.text =  String(format: "%.0f/255", redSlider.value)
        blueLabel.text =  String(format: "%.0f/255", blueSlider.value)
        gLabel.text =  String(format: "%.0f/255", greenSlider.value)

        
        // Do any additional setup after loading the view.
    }
    @IBAction func redChange(_ sender: Any) {
        red=CGFloat(redSlider.value / 255)
        rLabel.text =  String(format: "%.0f/255", redSlider.value)
        self.updatePrevview()
        bLabel.text = String(format: "Brush Size: %.0f", brushWidth)
        bSize.value = Float(brushWidth)
    }
    
    @IBAction func blueChange(_ sender: Any) {
        blue=CGFloat(blueSlider.value / 255)
        blueLabel.text =  String(format: "%.0f/255", blueSlider.value)
        self.updatePrevview()
    }
   
    @IBAction func greenChange(_ sender: Any) {
        green=CGFloat(greenSlider.value / 255)
        gLabel.text =  String(format: "%.0f/255", greenSlider.value)
        self.updatePrevview()
    }
    @IBAction func brushSize(_ sender: Any) {
        brushWidth = CGFloat(bSize.value)
        bLabel.text = String(format: "Brush Size: %.0f", brushWidth)
        self.updatePrevview()
    }
    
    @IBAction func OpacityChange(_ sender: Any) {
    }
    
    @IBAction func exit(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        self.delegate?.settingsViewControllerFinished(self)
    }
    func updatePrevview(){
        UIGraphicsBeginImageContext(imageView.frame.size)
        
        let context = UIGraphicsGetCurrentContext()
        context?.setLineCap(CGLineCap.round)
        context?.setLineWidth(brushWidth)
        context?.setStrokeColor(red:red,green: green,blue: blue,alpha: 1)
        context?.move(to: CGPoint(x: imageView.frame.width/2, y: imageView.frame.height/2))
        context?.addLine(to: CGPoint(x: imageView.frame.width/2, y: imageView.frame.height/2))
        context?.strokePath()
        imageView.image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
    }
}

