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
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resetTracking()
        view.setGradientBackground(colors: [UIColor.grayBlue.cgColor, UIColor.extraLightGray.cgColor], locations: [0.0, 1.0], startPoint: CGPoint(x: 1, y: 0), endPoint: CGPoint(x: 0, y: 1))
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
        
        // Prevents the device from going to sleep
        UIApplication.shared.isIdleTimerDisabled = true
        resetTracking()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    

    // MARK: - Private properties
    
    private var session: ARSession {
        return sceneView.session
    }
    private var count: Float = 0.0
    private var timer = Timer()
    private var timerIsRunning: Bool = false
    private var mask: Mask?
    private var isPaused = true
    private var isDisplayingMask = true
    /// Holds the ARFaceAnchor, which has information about the pose, topology, and expression of a face detected in a face-tracking AR session.
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
    private var highestResult: Float = 0.0
    
    
    // MARK: - Public properties
    
    var exerciseCopy = [FacialExercise]()
    var exercisesWithResults = [String: Float]()
    
    
    // MARK: - UI Objects
    
    let exerciseCompleteView = ExerciseCompleteView()
    
    let detectFaceLabel: UILabel = {
        let label = UILabel()
        label.font = Appearance.appFont(style: .title1, size: 24)
        label.textAlignment = .center
        label.textColor = .white
        label.text = "Adjust the camera so your face is fully visible"
        label.sizeToFit()
        label.numberOfLines = 0
        
        return label
    }()
    
    let repeatCountLabel: UILabel = {
        let label = UILabel()
        label.font = Appearance.appFont(style: .title1, size: 24)
        label.textAlignment = .center
        label.textColor = .white
        
        return label
    }()
    
    private lazy var sceneView: ARSCNView = {
        let view = ARSCNView()
        view.layer.masksToBounds = true
        view.clipsToBounds = true
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
    
    private let swapButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "refresh").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(swap), for: .touchUpInside)
        button.alpha = 0
        
        return button
    }()
    
    private let maskSceneView: SCNView = {
        let scnview = SCNView()
        scnview.backgroundColor = .clear
        scnview.rendersContinuously = true
        scnview.scene = SCNScene()
        scnview.isHidden = true
        scnview.alpha = 0
//        scnview.layer.borderColor = UIColor.black.cgColor
//        scnview.layer.borderWidth = 5.0
        
        return scnview
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .turquoise
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
    
        return view
    }()
    
    private let blurEffect = UIBlurEffect(style: .dark)
    var blurredEffectView: UIVisualEffectView?
    
    private let pauseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "pause"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handlePause), for: .touchUpInside)
        button.alpha = 0
        return button
    }()
    
    private let resumeButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = Appearance.appFont(style: .title1, size: 20)
        button.setTitle("RESUME", for: .normal)
        button.addTarget(self, action: #selector(handleResume), for: .touchUpInside)
        
        return button
    }()
    
    private let statusTrackView: UIView = {
        let view = UIView()
        view.backgroundColor = .rgb(red: 218, green: 231, blue: 236)
        view.alpha = 0
        
        return view
    }()
    
    private let statusFillView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.alpha = 0
        
        return view
    }()
    
    private var statusFillViewHeightConstraint: NSLayoutConstraint?
    
    private let tickMark: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        
        return view
    }()
    
    private var lastExpression: Float = 0.0

    var containerViewBottomAnchor: NSLayoutConstraint?
    
    var sceneViewTrailingAnchor: NSLayoutConstraint?
    var sceneViewLeadingAnchor: NSLayoutConstraint?
    var sceneViewBottomAnchor: NSLayoutConstraint?
    var sceneViewTopAnchor: NSLayoutConstraint?
    
    var maskViewTrailingAnchor: NSLayoutConstraint?
    var maskViewLeadingAnchor: NSLayoutConstraint?
    var maskViewBottomAnchor: NSLayoutConstraint?
    var maskViewTopAnchor: NSLayoutConstraint?
}


// MARK: - Private Methods

private extension ExcerciseViewController {
    
    @objc func handleResume() {
        blurredEffectView?.removeFromSuperview()
        isPaused = false
    }
    
//    @objc func handleRestart() {
//        blurredEffectView?.removeFromSuperview()
//        exercises = exerciseCopy
//        resetProgressView()
//        resetTracking()
//    }
    
    @objc func handleQuit() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func handlePause() {
        isPaused = true
        blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView?.frame = view.frame
        view.addSubview(blurredEffectView!)
        
     
        let resumeButton = UIButton(type: .system)
        resumeButton.titleLabel?.font = Appearance.appFont(style: .title1, size: 22)
        resumeButton.setTitle("RESUME", for: .normal)
        resumeButton.addTarget(self, action: #selector(handleResume), for: .touchUpInside)
        resumeButton.titleLabel?.contentMode = .center
        resumeButton.backgroundColor = UIColor.white
        resumeButton.tintColor = UIColor.black
        resumeButton.layer.cornerRadius = 10.0

//        let restartButton = UIButton(type: .system)
//        restartButton.titleLabel?.font = Appearance.appFont(style: .title1, size: 22)
//        restartButton.setTitle("RESTART", for: .normal)
//        restartButton.addTarget(self, action: #selector(handleRestart), for: .touchUpInside)
//        restartButton.titleLabel?.contentMode = .center
//        restartButton.backgroundColor = UIColor.white
//        restartButton.tintColor = UIColor.black
//        restartButton.layer.cornerRadius = 10.0
        
        let quitButton = UIButton(type: .system)
        quitButton.titleLabel?.font = Appearance.appFont(style: .title1, size: 22)
        quitButton.setTitle("QUIT", for: .normal)
        quitButton.addTarget(self, action: #selector(handleQuit), for: .touchUpInside)
        quitButton.titleLabel?.contentMode = .center
        quitButton.backgroundColor = UIColor.white
        quitButton.setTitleColor(.red, for: .normal)
        quitButton.tintColor = UIColor.black
        quitButton.layer.cornerRadius = 10.0
        
        resumeButton.frame = CGRect(x: view.center.x - 150, y: view.center.y - 40, width: 300, height: 40)
//        restartButton.frame = CGRect(x: view.center.x - 150, y: view.center.y - 20, width: 300, height: 40)
        quitButton.frame = CGRect(x: view.center.x - 150, y: view.center.y + 40, width: 300, height: 40)
       
        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        let vibrancyEffectView = UIVisualEffectView(effect: vibrancyEffect)
        vibrancyEffectView.frame = view.bounds
        
        vibrancyEffectView.contentView.addSubview(resumeButton)
//        vibrancyEffectView.contentView.addSubview(restartButton)
        vibrancyEffectView.contentView.addSubview(quitButton)
        blurredEffectView?.contentView.addSubview(vibrancyEffectView)
    }
    
    func setupViews() {
        view.addSubview(detectFaceLabel)
        detectFaceLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 50, left: 30, bottom: 0, right: 30))
        
        view.addSubview(containerView)
        containerView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: (self.view.frame.height / 4) + 10))
        containerViewBottomAnchor = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: (self.view.frame.height / 4) + 10)
        containerViewBottomAnchor?.isActive = true
        
        containerView.addSubview(descriptionLabel)
        descriptionLabel.anchor(top: containerView.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 22, left: 12, bottom: 0, right: 12))
        
        progressView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(progressView)
        progressView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        progressView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        progressView.widthAnchor.constraint(equalToConstant: view.frame.width / 2).isActive = true
        progressView.heightAnchor.constraint(equalToConstant: 10).isActive = true
        
        sceneView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sceneView)
        sceneViewLeadingAnchor = sceneView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40)
        sceneViewLeadingAnchor?.isActive = true
        sceneViewTrailingAnchor = sceneView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        sceneViewTrailingAnchor?.isActive = true
        sceneViewTopAnchor = sceneView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 200)
        sceneViewTopAnchor?.isActive = true
        sceneViewBottomAnchor = sceneView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -220)
        sceneViewBottomAnchor?.isActive = true
        
        maskSceneView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(maskSceneView)
        maskViewLeadingAnchor = maskSceneView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40)
        maskViewLeadingAnchor?.isActive = true
        maskViewTrailingAnchor = maskSceneView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        maskViewTrailingAnchor?.isActive = true
        maskViewTopAnchor = maskSceneView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 120)
        maskViewTopAnchor?.isActive = true
        maskViewBottomAnchor = maskSceneView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -280)
        maskViewBottomAnchor?.isActive = true
//        maskSceneView.anchor(top: nil, leading: view.leadingAnchor, bottom: containerView.topAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 35, bottom: 70, right: 35), size: CGSize(width: 0, height: 350))

        view.addSubview(checkmarkAnimation)
        checkmarkAnimation.anchor(top: sceneView.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 12, left: 0, bottom: 0, right: 0), size: CGSize(width: 80, height: 80))
        checkmarkAnimation.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        view.addSubview(pauseButton)
        pauseButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 12, left: 0, bottom: 0, right: 20), size: CGSize(width: 30, height: 30))
        
        view.addSubview(swapButton)
        swapButton.anchor(top: pauseButton.bottomAnchor, leading: nil, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 20), size: CGSize(width: 30, height: 30))
         
        view.addSubview(statusTrackView)
        statusTrackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: containerView.topAnchor, trailing: nil, padding: UIEdgeInsets(top: 40.0, left: 30.0, bottom: 40.0, right: 0.0), size: CGSize(width: 5.0, height: 0.0))
        
        statusTrackView.addSubview(statusFillView)
        statusFillView.anchor(top: nil, leading: statusFillView.superview?.leadingAnchor, bottom: statusFillView.superview?.bottomAnchor, trailing: statusFillView.superview?.trailingAnchor)
        
        statusFillViewHeightConstraint = statusFillView.heightAnchor.constraint(equalToConstant: 0.0)
        statusFillViewHeightConstraint?.isActive = true
        containerView.addSubview(repeatCountLabel)
        repeatCountLabel.anchor(top: progressView.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 10, left: 10, bottom: 10, right: 10))
        // view.addSubview(tickMark)
        // tickMark.anchor(top: nil, leading: nil, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 0.0, left: 0.0, bottom: statusViewTrack.bounds.size.height * 0.6, right: 0.0), size: CGSize(width: statusViewTrack.bounds.size.width + 6.0, height: 4.0))
        // tickMark.centerXAnchor.constraint(equalTo: statusViewTrack.centerXAnchor)
    }
    
    @objc func swap() {
        maskViewLeadingAnchor?.constant = isDisplayingMask ? self.view.frame.width - 80 : 40
        maskViewTrailingAnchor?.constant = isDisplayingMask ? -20 : -40
        maskViewTopAnchor?.constant = isDisplayingMask ? 440 : 220
        maskViewBottomAnchor?.constant = isDisplayingMask ? -220 : -280
        
        sceneViewLeadingAnchor?.constant = isDisplayingMask ? 60 : self.view.frame.width - 80
        sceneViewTrailingAnchor?.constant = isDisplayingMask ? -60 : -20
        sceneViewTopAnchor?.constant = isDisplayingMask ? 220 : 440
        sceneViewBottomAnchor?.constant = isDisplayingMask ? -280 : -220
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }) { (completed) in
            self.isDisplayingMask = self.isDisplayingMask ? false : true
        }
    }
    
    func transitionAnimation() {
        self.checkmarkAnimation.isHidden = true
        self.createFaceGeometry()
        
        self.maskSceneView.isHidden = false
        self.containerViewBottomAnchor?.constant = 10
        self.sceneViewLeadingAnchor?.constant = self.view.frame.width - 80
        self.sceneViewTrailingAnchor?.constant = -20
        self.sceneViewTopAnchor?.constant = 440
        self.sceneViewBottomAnchor?.constant = -220
        
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        UIView.animate(withDuration: 1.0, delay: 0, options: [.curveEaseIn], animations: {
            self.maskSceneView.alpha = 1
            self.statusTrackView.alpha = 1
            self.statusFillView.alpha = 1
            self.pauseButton.alpha = 1
            self.swapButton.alpha = 1
        }, completion: { (_) in
            self.updateMessage(text: self.exercises[0].description)
            self.detectFaceLabel.text = self.exercises[0].title
        })
    }
    
    /// ARFaceTrackingConfiguration
    func resetTracking() {
        guard ARFaceTrackingConfiguration.isSupported else {
            fatalError("Face Tracking not supported on this device")
        }
        
        let configuration = ARFaceTrackingConfiguration()
        
        // Default Settings
        configuration.isLightEstimationEnabled = true
        configuration.providesAudioData = false
        
        // Resets the tracking and removes any exisiting anchors anytime the session is started
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
    
    /// Updates description UI
    func updateMessage(text: String) {
        DispatchQueue.main.async {
            self.descriptionLabel.text = text
        }
    }
    
    /// Resets the progress view back to 1 on the main queue, used for begining a new exercise or repeating an exercise from the beginning
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
    
    func checkExpressionSuccess(expression: Float, exercise: FacialExercise) {
        if expression > LevelHelper.getThreshold(for: exercise.expressions.first!) {
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
                        isPaused = true
                        exercisesWithResults[exercise.title] = highestResult
                        highestResult = 0.0
                        exercises.remove(at: 0)
                        if exercises.count > 0 {
                            exerciseCompleteView.showCelebrationView()
                            detectFaceLabel.text = "\(exercises[0].title)"
                            updateMessage(text: "\(exercises[0].description)")
                            detectFaceLabel.text = exercises[0].title
                        }
                        resetProgressView()
                        isPaused = false
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


// MARK: - ARSCNViewDelegate

extension ExcerciseViewController: ARSCNViewDelegate {
    
    // MARK: ARNodeTracking

    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard let device = sceneView.device else {
            return nil
        }
        
        let faceGeometry = ARSCNFaceGeometry(device: device)
        
        let node = SCNNode(geometry: faceGeometry)
        
        node.geometry?.firstMaterial?.fillMode = .lines

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            let impactGenerator = UIImpactFeedbackGenerator(style: .heavy)
            impactGenerator.impactOccurred()
            self.detectFaceLabel.text = "Face successfully found"
            self.checkmarkAnimation.play { (_) in
                self.transitionAnimation()
            }
        }

        isPaused = false
        return node
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        
        if isPaused {
            return
        }
        guard let faceAnchor = anchor as? ARFaceAnchor,
            let faceGeometry = node.geometry as? ARSCNFaceGeometry else {
                return
        }
        
        faceGeometry.update(from: faceAnchor.geometry)
        mask?.update(withFaceAnchor: faceAnchor)
        
        // Test for Raising eyebrows
        
        let blendShapes = faceAnchor.blendShapes
        
        if exercises.count > 0 {
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
            if expression > highestResult {
                highestResult = expression
            }
            // If the expression is above point 6 and the timer is not running, it starts the timer for the count, which is equal to the holdLength of the exercise
            DispatchQueue.main.async {
                self.checkExpressionSuccess(expression: expression, exercise: exercise)
            }
        } else {
            DispatchQueue.main.async {
                self.isPaused = true
                let resultsVc = ResultViewController()
                resultsVc.exercisesWithResults = self.exercisesWithResults
                self.navigationController?.pushViewController(resultsVc, animated: true)
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
