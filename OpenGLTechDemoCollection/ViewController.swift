//
//  ViewController.swift
//  OpenGLTechDemoCollection
//
//  Created by Andreas Umbach on 05.08.2016.
//  Copyright © 2016 Andreas Umbach. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
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


}

