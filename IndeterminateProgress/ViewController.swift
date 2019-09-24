//
//  ViewController.swift
//  IndeterminateProgress
//
//  Created by Marharyta Lytvynenko on 24.09.2019.
//  http://www.popcornomnom.com
//  Copyright © 2019 damnLekker. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private weak var slideThrough: IndeterminateProgressView!
    @IBOutlet private weak var pinPong: IndeterminateProgressView! {
        didSet {
            //here you can setup pinPong properties
        }
    }
}

