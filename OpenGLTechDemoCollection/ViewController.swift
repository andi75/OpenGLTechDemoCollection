//
//  ViewController.swift
//  OpenGLTechDemoCollection
//
//  Created by Andreas Umbach on 05.08.2016.
//  Copyright © 2016 Andreas Umbach. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    override var acceptsFirstResponder: Bool {
        return true
    }
    
    @IBOutlet weak var techDemoView: TechDemoView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.techDemoView?.techDemo =
            // Reflections()
            OGL4Cube()

        self.techDemoView?.createContext()
        // Do any additional setup after loading the view.
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func mirroredCubeSelected(sender: NSMenuItem) {
        self.techDemoView?.techDemo = Reflections()
        self.techDemoView?.createContext()
        self.techDemoView?.needsDisplay = true
    }
    
    @IBAction func openGL4CubeSelected(sender: NSMenuItem) {
        self.techDemoView?.techDemo = OGL4Cube()
        self.techDemoView?.createContext()
        self.techDemoView?.needsDisplay = true
    }

}

