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
    
    var exercises = [FacialExercise]() {
        didSet {
            if exercises.count > 0 {
                count = exercises[0].holdCount
            } else {
                updateMessage(text: "Successfully completed exercises for today!")
            }
        }
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        resetTracking()
        view.backgroundColor = UIColor.rgb(red: 163, green: 215, blue: 255)
        setupViews()
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
    
    private lazy var sceneView: ARSCNView = {
        let view = ARSCNView()
        view.layer.cornerRadius = 10.0
        view.layer.masksToBounds = true
        view.delegate = self
        
        return view
    }()
    
    private let checkmarkAnimation: LOTAnimationView = {
        let view = LOTAnimationView(name: "checkmark")
        view.contentMode = .scaleAspectFit
        view.backgroundColor = .clear
        
        return view
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = Appearance.appFont(style: .title1, size: 20)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "Detect face geometry"
        
        return label
    }()
    
    private let progressView: UIProgressView = {
        let pv = UIProgressView(progressViewStyle: .bar)
        pv.progress = 1
        pv.trackTintColor = UIColor.rgb(red: 163, green: 215, blue: 255)
        pv.tintColor = UIColor.white
        return pv
    }()
    
    private let maskSceneView: SCNView = {
        let scnview = SCNView()
        scnview.backgroundColor = .clear
        scnview.rendersContinuously = true
        scnview.scene = SCNScene()
//        scnview.layer.borderColor = UIColor.black.cgColor
//        scnview.layer.borderWidth = 5.0
        
        return scnview
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 129, green: 199, blue: 255)
    
        return view
    }()
    
    private let statusTrackView: UIView = {
        let view = UIView()
        view.backgroundColor = .rgb(red: 218, green: 231, blue: 236)
        
        return view
    }()
    
    private let statusFillView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        
        return view
    }()
    
    private var statusFillViewHeightConstraint: NSLayoutConstraint?
    
    private let tickMark: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        
        return view
    }()
    
    private var lastExpression: Float = 0.0
}

// MARK: - Private Methods
private extension ExcerciseViewController {
    
    func setupViews() {
        view.addSubview(containerView)
        containerView.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, size: CGSize(width: 0, height: self.view.frame.height / 4))
        
        containerView.addSubview(descriptionLabel)
        descriptionLabel.anchor(top: containerView.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 12, left: 12, bottom: 0, right: 12))
        
        progressView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(progressView)
        progressView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        progressView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        progressView.widthAnchor.constraint(equalToConstant: view.frame.width / 2).isActive = true
        
        view.addSubview(sceneView)
        sceneView.centerInSuperview(size: CGSize(width: view.frame.width / 2, height: view.frame.width / 2))
        
        view.addSubview(maskSceneView)
        maskSceneView.anchor(top: nil, leading: nil, bottom: sceneView.topAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 50, right: 0), size: CGSize(width: 100, height: 100))
        maskSceneView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        
        view.addSubview(checkmarkAnimation)
        checkmarkAnimation.anchor(top: sceneView.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 12, left: 0, bottom: 0, right: 0), size: CGSize(width: 80, height: 80))
        checkmarkAnimation.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(statusTrackView)
        statusTrackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: containerView.topAnchor, trailing: nil, padding: UIEdgeInsets(top: 40.0, left: 30.0, bottom: 40.0, right: 0.0), size: CGSize(width: 5.0, height: 0.0))
        
        statusTrackView.addSubview(statusFillView)
        statusFillView.anchor(top: nil, leading: statusFillView.superview?.leadingAnchor, bottom: statusFillView.superview?.bottomAnchor, trailing: statusFillView.superview?.trailingAnchor)
        
        statusFillViewHeightConstraint = statusFillView.heightAnchor.constraint(equalToConstant: 0.0)
        statusFillViewHeightConstraint?.isActive = true
        
        // view.addSubview(tickMark)
        // tickMark.anchor(top: nil, leading: nil, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 0.0, left: 0.0, bottom: statusViewTrack.bounds.size.height * 0.6, right: 0.0), size: CGSize(width: statusViewTrack.bounds.size.width + 6.0, height: 4.0))
        // tickMark.centerXAnchor.constraint(equalTo: statusViewTrack.centerXAnchor)
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
            let progress = Float(count / exercises[0].holdCount)
            print("the count is \(count) and the progress is \(progress)")
            DispatchQueue.main.async {
                self.progressView.progress = progress
            }
            updateCountLabel()
        } else if count == 0 {
            timer.invalidate()
            DispatchQueue.main.async {
//                self.progressView.progress = 0.0
                self.exercises.remove(at: 0)
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
    
    //Resets the progress view back to 1 on the main queue, used for begining a new exercise or repeating an exercise from the beginning
    func resetProgressView() {
        DispatchQueue.main.async {
            self.progressView.progress = 1
        }
    }
    
    func updateCountLabel() {
        switch Int(count) {
        case 0:
            updateMessage(text: "Repition Complete")
        case 1:
            updateMessage(text: "Hold for \(Int(count)) more second")
        default:
            updateMessage(text: "Hold for \(Int(count)) more seconds")
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
                self.updateMessage(text: "Face successfully found")
                
                self.checkmarkAnimation.isHidden = true
                self.createFaceGeometry()
                
                var maskTransform = CATransform3DIdentity
                maskTransform = CATransform3DScale(maskTransform, 2.0, 2.0, 1.01)
                maskTransform = CATransform3DTranslate(maskTransform, 0, 100, 0)
                
//                var sceneViewTransform = CATransform3DIdentity
//                sceneViewTransform = CATransform3DScale(maskTransform, 0.1, 0.1, 1)
//                sceneViewTransform = CATransform3DTranslate(maskTransform, 100, 0, 0)
                
                UIView.animate(withDuration: 1.0, delay: 0, options: [.curveEaseIn], animations: {
                    self.maskSceneView.layer.transform = maskTransform
                    self.sceneView.transform = CGAffineTransform(translationX: 0, y: -200)
//                    self.sceneView.alpha = 0.0
                }, completion: { (_) in
                    let impactGenerator = UIImpactFeedbackGenerator(style: .heavy)
                    impactGenerator.impactOccurred()
                    self.updateMessage(text: self.exercises[0].description)
                })
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
        
        //Will crash when you are done with exercises need to present result view controller when done to stop from crashing
        let exercise = exercises[0]
        
        guard let expression = blendShapes[exercise.expressions.first!] as? Float else {return}
        
        if expression - lastExpression >= 0.015 || expression - lastExpression <= -0.015 {
            DispatchQueue.main.async {
                
                let statusFillHeight = self.statusTrackView.bounds.height * CGFloat(expression)
                self.statusFillViewHeightConstraint?.constant = statusFillHeight
                
                UIView.animate(withDuration: 0.5) {
                    self.view.layoutIfNeeded()
                }
                
                // let isAboveThreshold = expression >= LevelHelper.getThreshold(for: exercise.expressions.first!)
                let isAboveThreshold = expression > 0.6
                self.statusFillView.backgroundColor = isAboveThreshold ? .selectedGreen : .red
            }
        }
        
        lastExpression = expression
        
        //If the expression is above point 6 and the timer is not running, it starts the timer for the count, which is equal to the holdLength of the exercise
        
        if expression > 0.6 {
            if !timer.isValid {
                startTimer(for: count)
            }
        } else {
            if timer.isValid {
                timer.invalidate()
                if count != 0 && count != exercise.holdCount {
                    updateCountLabel()
                } else if count == 0 {
                    exercise.repeatCount -= 1
                    if exercise.repeatCount == 0 {
                        exercises.remove(at: 0)
                        if exercises.count > 0 {
                            updateMessage(text: exercises[0].description)
                        }
                        resetProgressView()
                    } else {
                        count = exercise.holdCount
                        resetProgressView()
                        updateMessage(text: exercise.description)
                    }
                }
            }
        }
    }
}


//if expression > 0.6 {
//    if !timerIsRunning {
//        startTimer(for: count)
//        timerIsRunning = true
//    }
//} else {
//    if timerIsRunning {
//        timer.invalidate()
//        if count != 0 && count != exercise.holdCount {
//            updateMessage(text: "Hold for \(Int(count)) more seconds")
//        } else if count == 0 {
//            exercise.repeatCount -= 1
//            if exercise.repeatCount == 0 {
//                exercises.remove(at: 0)
//                updateMessage(text: exercises[0].description)
//                resetProgressView()
//            } else {
//                count = exercise.holdCount
//                resetProgressView()
//                updateMessage(text: exercise.description)
//            }
//        }
//        timerIsRunning = false
//    }
//}
