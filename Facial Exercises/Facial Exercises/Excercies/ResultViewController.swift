//
//  ResultViewController.swift
//  Facial Exercises
//
//  Created by De MicheliStefano on 03.01.19.
//  Copyright © 2019 Vuk Radosavljevic. All rights reserved.
//

/**
 A view controller which shows the results of the user's exercise session.
 - Author: Stefano Demicheli
 */

import UIKit

class ResultViewController: UIViewController {
    
    // MARK: - Public properties
    
    var completedExercises = [Exercise]()
    var shouldCelebrate = true
    
    // MARK: - Private properties
    
    private let headerView: HeaderResultsView = {
        let view = HeaderResultsView(score: 50)
        view.backgroundColor = UIColor.lightGray
        view.layer.cornerRadius = 12
        return view
    }()
    
    private let exerciseResultsView: ExerciseResultsCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 12
        let cv = ExerciseResultsCollectionView(collectionViewLayout: layout)
        return cv
    }()
    
    private let blurEffect: UIVisualEffectView = {
        let frost = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        frost.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return frost
    }()
    
    private let sidePadding: CGFloat = 20.0
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.setGradientBackground(colors: [UIColor.rgb(red: 166, green: 255, blue: 203).cgColor, UIColor.rgb(red: 18, green: 216, blue: 250).cgColor, UIColor.rgb(red: 31, green: 162, blue: 255).cgColor], locations: [0.0, 0.5, 1.0], startPoint: CGPoint(x: 1, y: 0), endPoint: CGPoint(x: 0, y: 1))
        
        setupViews()
        
        if shouldCelebrate { setupEmitterView() }
    }
    
    // MARK: - Configuration
    
    private func setupViews() {
        view.addSubview(blurEffect)
        blurEffect.fillSuperview()
        
        view.addSubview(headerView)
        headerView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 50, left: sidePadding, bottom: 0, right: sidePadding), size: CGSize(width: 0, height: 150))
        
        view.addSubview(exerciseResultsView)
        exerciseResultsView.anchor(top: headerView.bottomAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: sidePadding, left: sidePadding, bottom: sidePadding, right: sidePadding))
    }
    
    private func setupEmitterView() {
        let rect = CGRect(x: 0.0, y: -90.0, width: view.bounds.width, height: 50.0)
        let emitter = CAEmitterLayer()
        emitter.frame = rect
        emitter.emitterShape = CAEmitterLayerEmitterShape.point
        emitter.emitterPosition = CGPoint(x: rect.width/2, y: rect.height/2)
        emitter.emitterSize = rect.size
        view.layer.addSublayer(emitter)
        
        emitter.emitterCells = [CAEmitterCell]()
        
        let emitterCell = CAEmitterCell()
        emitterCell.contents = UIImage(named: "star")?.cgImage
        emitterCell.color = UIColor.red.cgColor
        emitterCell.birthRate = 100
        emitterCell.lifetime = 5
        emitterCell.yAcceleration = 100.0
        emitterCell.xAcceleration = 10.0
        emitterCell.zAcceleration = 10.0
        emitterCell.spin = 5.0
        emitterCell.velocity = 350.0
        emitterCell.velocityRange = 200.0
        emitterCell.emissionLongitude = .pi * 0.5
        emitterCell.emissionRange = .pi * 0.5
        emitterCell.scale = 1.0
        emitterCell.scaleRange = 0.5
        
        emitter.emitterCells?.append(emitterCell)
    }
    
}

private class HeaderResultsView: UIView {
    
    var score: Int = 0
    
    private let title: UILabel = {
        let label = UILabel()
        label.font = Appearance.appFont(style: .body, size: 24.0)
        label.textColor = .white
        label.textAlignment = .center
        label.text = "Total Score"
        return label
    }()
    
    private let scoreLabel: UILabel = {
        let label = UILabel()
        label.font = Appearance.boldAppFont(style: .body, size: 45.0)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let padding: CGFloat = 12.0
    
    init(frame: CGRect = CGRect.zero, score: Int) {
        super.init(frame: frame)
        self.score = score
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(title)
        title.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: padding, left: padding, bottom: 0.0, right: padding))
        
        addSubview(scoreLabel)
        scoreLabel.anchor(top: title.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: padding, left: padding, bottom: 0.0, right: padding))
        scoreLabel.text = String(score)
    }
    
}

private class ExerciseResultsCollectionView: UICollectionView {
    
    static private var cellId = "ExerciseResultCell"
    
    override init(frame: CGRect = CGRect.zero, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        delegate = self
        dataSource = self
        backgroundColor = .clear
        showsHorizontalScrollIndicator = false
        contentInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        register(ExerciseResultCell.self, forCellWithReuseIdentifier: ExerciseResultsCollectionView.cellId)
        self.allowsSelection = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ExerciseResultsCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: ExerciseResultsCollectionView.cellId, for: indexPath) as! ExerciseResultCell
        cell.exerciseName = "Brow challenge"
        return cell
    }
}

extension ExerciseResultsCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width, height: 65)
    }
}


private class ExerciseResultCell: UICollectionViewCell {
    
    var exerciseName: String? {
        didSet {
            updateViews()
        }
    }
    
    private let blurEffect: UIVisualEffectView = {
        let frost = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffect.Style.regular))
        frost.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        frost.layer.cornerRadius = 8
        frost.layer.masksToBounds = true
        
        return frost
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        return stackView
    }()
    
    private let exerciseNameLabel: UILabel = {
        let label = UILabel()
        label.font = Appearance.appFont(style: .body, size: 17.0)
        label.numberOfLines = 2
        label.textColor = .white
        return label
    }()
    
    private let sidePadding: CGFloat = 12
    private let defaultBackgroundColor: UIColor = .clear
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = defaultBackgroundColor
        layer.cornerRadius = 8
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(blurEffect)
        blurEffect.fillSuperview()
        
        addSubview(mainStackView)
        mainStackView.addArrangedSubview(exerciseNameLabel)
        mainStackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 8, left: sidePadding, bottom: 8, right: sidePadding))
    }
    
    private func updateViews() {
        exerciseNameLabel.text = exerciseName
    }
    
}

class ProgressIndicator: UIView {
    
    // MARK: - Public properties
    
    var lineWidth: CGFloat = 40.0
    var bgLineWidth: CGFloat = 7.5
    var fgLineWidth: CGFloat = 12.0
    var bgColor = UIColor(white: 1.0, alpha: 0.5).cgColor
    var fgColor = UIColor.white.cgColor
    var progressValue: Double!
    var goalValue: Double!
    var progressPercentage: CGFloat {
        if (progressValue >= goalValue) {
            return 1.0
        }
        return CGFloat(progressValue) / CGFloat(goalValue)
    }
    var animationDuration: CFTimeInterval!
    
    // MARK: - Private properties
    
    private let bgLayer = CAShapeLayer()
    private let fgLayer = CAShapeLayer()
    private let margin: CGFloat = 20
    private var startValue = 0.0
    private let animationStartDate = Date()
    
    // MARK: - Init
    
    init(frame: CGRect, progress: Double, goal: Double, animationDuration: CFTimeInterval? = 1.2) {
        super.init(frame: frame)
        self.progressValue = progress
        self.goalValue = goal
        self.animationDuration = animationDuration
        setupViews()
        animateProgress()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupShapeLayer(bgLayer)
        setupShapeLayer(fgLayer)
    }
    
    // MARK: - Animation
    
    func animateProgress() {
        let activityAnimation = CABasicAnimation(keyPath: "strokeEnd")
        activityAnimation.fromValue = 0.0
        activityAnimation.toValue = progressPercentage
        activityAnimation.duration = animationDuration
        activityAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        fgLayer.add(activityAnimation, forKey: nil)
        
    }
    
    
    // MARK: - Configuration
    
    private func setupViews() {
        bgLayer.lineWidth = bgLineWidth
        bgLayer.fillColor = nil
        bgLayer.strokeColor = bgColor
        bgLayer.strokeEnd = 1.0
        layer.addSublayer(bgLayer)
        
        fgLayer.lineWidth = fgLineWidth
        fgLayer.fillColor = nil
        fgLayer.strokeColor = fgColor
        fgLayer.strokeEnd = progressPercentage
        layer.addSublayer(fgLayer)
        
        setupShapeLayer(bgLayer)
        setupShapeLayer(fgLayer)
    }
    
    private func setupShapeLayer(_ shapeLayer: CAShapeLayer) {
        shapeLayer.frame = self.bounds
        let startAngle = DegreesToRadians(value: 135.0)
        let endAngle = DegreesToRadians(value: 45.0)
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = self.bounds.width * 0.35
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeLayer.path = path.cgPath
    }
    
    private func DegreesToRadians (value:CGFloat) -> CGFloat {
        return value * CGFloat.pi / 180.0
    }
    
}
