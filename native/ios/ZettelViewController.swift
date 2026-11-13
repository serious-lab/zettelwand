//
//  ZettelViewController.swift
//  Zettelwand
//
//  Meldet das eigene Texterkennungs-Plugin bei Capacitor an.
//  In Main.storyboard muss der "Bridge View Controller" diese Klasse verwenden
//  (Identity Inspector → Custom Class → ZettelViewController, Module: App).
//

import UIKit
import Capacitor

class ZettelViewController: CAPBridgeViewController {
    override open func capacitorDidLoad() {
        bridge?.registerPluginInstance(VisionOCRPlugin())
    }
}
