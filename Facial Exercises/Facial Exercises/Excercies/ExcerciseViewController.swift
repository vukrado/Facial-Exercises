//
//  ExcerciseViewController.swift
//  Facial Exercises
//
//  Created by Vuk Radosavljevic on 1/3/19.
//  Copyright © 2019 Vuk Radosavljevic. All rights reserved.
//

import UIKit
import ARKit
import Lottie

class ExcerciseViewController: UIViewController {

    // MARK: - Properties
    private var session: ARSession {
        return sceneView.session
    }
    private var count: Float = 0.0
    private var timer = Timer()
    private var timerIsRunning: Bool = false
    private var mask: Mask?
    //Will hold the ARFaceAnchor - which has information about the pose, topology, and expression of a face detected in a face-tracking AR session.
    private var faceNode: SCNNode?
    
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScenes()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        UIApplication.shared.isIdleTimerDisabled = false
        sceneView.session.pause()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //Prevents the device from going to sleep
        UIApplication.shared.isIdleTimerDisabled = true
        resetTracking()
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - IBOutlets
    @IBOutlet weak var sceneView: ARSCNView! {
        didSet {
            sceneView.layer.cornerRadius = 10.0
            sceneView.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var checkmarkAnimation: LOTAnimationView! {
        didSet {
            checkmarkAnimation.animation = "checkmark"
            checkmarkAnimation.contentMode = .scaleAspectFit
        }
    }
    @IBOutlet weak var maskSceneView: SCNView!
    
    
    
    
}

// MARK: - Private Methods
private extension ExcerciseViewController {
    
    // Tag: SceneKit Setup
    func setupScenes() {
        //Sets the views delegate to self
        sceneView.delegate = self
        maskSceneView.backgroundColor = .clear
        maskSceneView.scene = SCNScene()
        maskSceneView.rendersContinuously = true
    }
    

    
    // Tag: ARFaceTrackingConfiguration
    func resetTracking() {
        guard ARFaceTrackingConfiguration.isSupported else {
            fatalError("Face Tracking not supported on this device")
        }
        
        let configuration = ARFaceTrackingConfiguration()
        
        //Default Settings
        configuration.isLightEstimationEnabled = true
        configuration.providesAudioData = false
        
        //Resets the tracking and removes any exisiting anchors anytime the session is started
        session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    func startTimer(for length: Float) {
        count = length
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateProgressBar(length:)), userInfo: nil, repeats: true)
    }
    
    @objc func updateProgressBar(length: Float) {
        if count > 0 {
            count -= 1
            let progress = Float(count / 15.0)
            print("the count is \(count) and the progress is \(progress)")
            DispatchQueue.main.async {
                self.progressView.progress = progress
            }
        } else if count == 0 {
            timer.invalidate()
            DispatchQueue.main.async {
                self.progressView.progress = 0.0
            }
        }
    }
    
    func createFaceGeometry() {
        updateMessage(text: "Creating face geometry")
        
        let device = sceneView.device!
        let maskGeometry = ARSCNFaceGeometry(device: device)!
        mask = Mask(geometry: maskGeometry)
        maskSceneView.scene?.rootNode.addChildNode(mask!)
        mask?.position = SCNVector3(0.0, 0.0, 0.0)
    }
    
    // Tag: Update UI
    func updateMessage(text: String) {
        DispatchQueue.main.async {
            self.descriptionLabel.text = text
        }
    }
}


extension ExcerciseViewController: ARSCNViewDelegate {
    // Tag: ARNodeTracking
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        faceNode = node
        
    }
    

    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard let device = sceneView.device else {
            return nil
        }
        
        let faceGeometry = ARSCNFaceGeometry(device: device)
        
        let node = SCNNode(geometry: faceGeometry)
        
        node.geometry?.firstMaterial?.fillMode = .lines

        DispatchQueue.main.async {
            self.checkmarkAnimation.play { (_) in
                self.checkmarkAnimation.isHidden = true
                self.createFaceGeometry()
                
                var maskTransform = CATransform3DIdentity
                maskTransform = CATransform3DScale(maskTransform, 2.0, 2.0, 1.01)
                maskTransform = CATransform3DTranslate(maskTransform, 0, 100, 0)
                
                var sceneViewTransform = CATransform3DIdentity
                sceneViewTransform = CATransform3DScale(maskTransform, 0.1, 0.1, 1)
                sceneViewTransform = CATransform3DTranslate(maskTransform, 100, 0, 0)
                UIView.animate(withDuration: 1.0, delay: 0, options: [.curveEaseIn], animations: {
                    self.maskSceneView.layer.transform = maskTransform
                    self.sceneView.layer.transform = sceneViewTransform
                }, completion: nil)
            }
        }
        
        return node
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor,
            let faceGeometry = node.geometry as? ARSCNFaceGeometry else {
                return
        }
        
        faceGeometry.update(from: faceAnchor.geometry)
        mask?.update(withFaceAnchor: faceAnchor)
        
        //Test for Raising eyebrows
        let blendShapes = faceAnchor.blendShapes
        guard let eyebrowsUp = blendShapes[.browInnerUp] as? Float else {return}
        if eyebrowsUp > 0.6 {
            if !timerIsRunning {
                startTimer(for: 15.0)
                timerIsRunning = true
            }
        } else {
            if timerIsRunning {
                timer.invalidate()
            }
        }
    }
    
    
}
