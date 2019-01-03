//
//  ExcercisesViewController.swift
//  Facial Exercises
//
//  Created by Vuk Radosavljevic on 1/2/19.
//  Copyright © 2019 Vuk Radosavljevic. All rights reserved.
//

import UIKit
import ARKit

class ExcercisesViewController: UIViewController {

    // MARK: - View Management
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScene()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Prevents the device from going to sleep
        UIApplication.shared.isIdleTimerDisabled = true
        resetTracking()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        UIApplication.shared.isIdleTimerDisabled = false
        sceneView.session.pause()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    //Creates an ARSCNView Used For Face Tracking
    private let sceneView: ARSCNView = {
        let scene = ARSCNView()
        scene.showsStatistics = true
        return scene
    }()
    
    private var session: ARSession {
        return sceneView.session
    }
    
    
    private func setupScene() {
        sceneView.delegate = self
        view.addSubview(sceneView)
        
        sceneView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        
    }
    
    private func resetTracking() {
        guard ARFaceTrackingConfiguration.isSupported else {
            fatalError("Face tracking is not supported on this device")
        }
        let configuration = ARFaceTrackingConfiguration()
        
        //Default settings
        configuration.isLightEstimationEnabled = true
        configuration.providesAudioData = false
        
        //Resets the tracking and removes any exisiting anchors anytime the session is started
        session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        
    }

}

extension ExcercisesViewController: ARSCNViewDelegate {
    
}

