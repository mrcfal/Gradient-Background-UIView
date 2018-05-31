//
//  ViewController.swift
//  Gradient Background UIView
//
//  Created by Marco Falanga on 31/05/18.
//  Copyright © 2018 Marco Falanga. All rights reserved.
//

import UIKit

enum Symbol {
    case plus
    case minus
}

class ViewController: UIViewController {

    @IBOutlet weak var b2: UILabel!
    @IBOutlet weak var g2: UILabel!
    @IBOutlet weak var r2: UILabel!
    @IBOutlet weak var b1: UILabel!
    @IBOutlet weak var g1: UILabel!
    @IBOutlet weak var r1: UILabel!
    
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet var buttons: [UIButton]!
    
    var rgb1: (CGFloat, CGFloat, CGFloat) = (0, 0, 0) {
        didSet {
            colorOne = colorFromRGB(rgb1)
        }
    }
    var rgb2: (CGFloat, CGFloat, CGFloat) = (0, 0, 0) {
        didSet {
            colorTwo = colorFromRGB(rgb2)
        }
    }
    
    var colorOne = UIColor()
    var colorTwo = UIColor()
    
    @IBAction func longPressure(_ sender: UILongPressGestureRecognizer) {
        if let button = sender.view {
            if let b = button as? UIButton {
                buttonTapped(b as! UIButton)
            }
        }
    }
    @IBAction func buttonTapped(_ sender: UIButton) {
        var symbol = Symbol.plus
        
        switch sender.tag {
        case 0, 2, 4, 6, 8, 10:
            symbol = .plus
        case 1, 3, 5, 7, 9, 11:
            symbol = .minus
        default:
            break
        }
        
        var tag = 0
        switch sender.tag {
        case 0,1:
            tag = 0
        case 2,3:
            tag = 1
        case 4,5:
            tag = 2
        case 6,7:
            tag = 3
        case 8,9:
            tag = 4
        case 10,11:
            tag = 5
        default:
            break
        }
        
        changeLabel(symbol: symbol, tag: tag)
    }
    
    func changeLabel(symbol: Symbol, tag: Int) {
        var label = r1
        
        switch tag {
        case 0:
            label = r1
        case 1:
            label = g1
        case 2:
            label = b1
        case 3:
            label = r2
        case 4:
            label = g2
        case 5:
            label = b2
        default:
            break
        }
        
        var value = Int((label?.text)!)!
        
        switch symbol {
        case .minus:
            if value == 0 {
                break
            }
            value -= 1
        case .plus:
            if value == 255 {
                break
            }
            value += 1
        default:
            break
        }
        
        label?.text = String(value)
        
        rgb1 = (CGFloat(Int(r1.text!)!),CGFloat(Int(g1.text!)!),CGFloat(Int(b1.text!)!))
        rgb2 = (CGFloat(Int(r2.text!)!),CGFloat(Int(g2.text!)!),CGFloat(Int(b2.text!)!))
        
        createGradientView(view: gradientView, colors: [colorOne, colorTwo])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rgb1 = (CGFloat(Int(r1.text!)!),CGFloat(Int(g1.text!)!),CGFloat(Int(b1.text!)!))
        rgb2 = (CGFloat(Int(r2.text!)!),CGFloat(Int(g2.text!)!),CGFloat(Int(b2.text!)!))
        
        colorOne = colorFromRGB(rgb1)
        colorTwo = colorFromRGB(rgb2)
        
        createGradientView(view: gradientView, colors: [colorOne, colorTwo])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setup()
    }
    
    func colorFromRGB(_ values: (CGFloat, CGFloat, CGFloat)) -> UIColor {
        return UIColor(red: values.0/255, green: values.1/255, blue: values.2/255, alpha: 1.0)
    }
    
    func createGradientView(view: UIView, colors: [UIColor] = [.blue]) {
        
        let width = view.frame.width
        let height = view.frame.height
        
        //gradient
        var colorsCGColor: [CGColor] = []
        var colorLocations: [CGFloat] = [0.0, 1.0]
        
        //set step of gradient
        let step: CGFloat = CGFloat(1) / CGFloat(colors.count - 1)
        var element = step
        if colors.count > 2 {
            for _ in 0...colors.count - 2 {
                colorLocations.append(CGFloat(element))
                element = element + step
            }
        }
        //set cgColors
        for color in colors {
            colorsCGColor.append(color.cgColor)
        }

        let point1 = CGPoint(x: 0, y: 0)
        let point2 = CGPoint(x: width, y: 0)
        let point3 = CGPoint(x: width, y: height)
        let point4 = CGPoint(x: 0, y: height)
        
        let path = CGMutablePath()
        path.move(to: point1)
        path.addLine(to: point2)
        path.addLine(to: point3)
        path.addLine(to: point4)
        path.closeSubpath()
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: width, height: height)
        gradientLayer.colors = colorsCGColor
        
        let shapeMask = CAShapeLayer()
        shapeMask.path = path
        gradientLayer.mask = shapeMask
        gradientLayer.position = CGPoint(x: 0 + width/2, y: view.frame.height - height/2)
        
        view.layer.addSublayer(gradientLayer)
    }
    
    func setup() {
        for b in buttons {
            b.clipsToBounds = true
            b.backgroundColor = .white
            b.layer.cornerRadius = 20
        }
    }
}

