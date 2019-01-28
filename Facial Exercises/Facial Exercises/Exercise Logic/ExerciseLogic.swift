//
//  ExerciseLogic.swift
//  Facial Exercises
//
//  Created by Simon Elhoej Steinmejer on 27/01/19.
//  Copyright © 2019 Vuk Radosavljevic. All rights reserved.
//

import Foundation

protocol ExerciseLogicDelegate: class {
    func updateProgressBar(value: Float)
    func didCompleteAllExercises()
}

class ExerciseLogic {
    
    
    init(exercises: [FacialExercise]) {
        self.exercises = exercises
    }
    
    var delegate: ExerciseLogicDelegate?
    
    
    // MARK: - Private Properties
    
    /// Timer for the 'exercise hold'
    private var timer: Timer?
    /// If timer is currently paused
    private var timerIsPaused = true {
        didSet {
            if timerIsPaused {
                timer?.invalidate()
            }
        }
    }
    
    /// Total time elapsed for current exercise
    /// - Note: Includes completed repetitions as well
    private var timeElapsed: Float = 0.0 {
        didSet {
            if timeElapsed >= currentExercise.holdCount * Float(currentExercise.repeatCount) {
                // Current exercise has been completed
                // Increments exercise index
                currentExerciseIndex += 1
            }
        }
    }
    
    /// User selected exercises
    private var exercises: [FacialExercise]
    
    /// The highest reached score for current exercise
    private var highestResult: Float = 0.0
    
    // The exercise index that the user is on
    private var currentExerciseIndex: Int = 0 {
        didSet {
            if currentExerciseIndex >= exercises.count {
                // All exercises have been completed
                delegate?.didCompleteAllExercises()
                // Resets timeElapsed to 0.0
                timeElapsed = 0.0
            }
        }
    }
    
    /// Which exercise the user is currently doing
    private var currentExercise: FacialExercise {
        return exercises[currentExerciseIndex]
    }
    /// The threshold of the current exercise
    var exerciseThreshold: Float {
        return LevelHelper.getThreshold(for: currentExercise.expression)
    }
    
    
    // MARK: - Public Methods
    
    /// Calls delegate method to update progress bar
    /// - Note: To be called when timer is running
    @objc func updateProgressBar() {
        timeElapsed += 0.5
        let progress = timeElapsed / (Float(currentExercise.repeatCount) * currentExercise.holdCount)
        delegate?.updateProgressBar(value: progress)
    }
    
    /// To be called by delegate in render didUpdate function
    func checkExpressionSuccess(expression: Float, exercise: FacialExercise) {
        //if experession is above threshold = let timer run
        //else pause timer
        if expression >= exerciseThreshold {
            if timerIsPaused {
                // calls function every 0.5 seconds -- holds a strong reference to self until timer is invalidated
                // selector is run after time interval is reached
                timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(updateProgressBar), userInfo: nil, repeats: true)
            } // else timer is already running and calling selector every 0.5 seconds
        } else {
            // TODO: Refactor else statemt
            // Old logixc
//            if timer.isValid {
//                timer.invalidate()
//                if count != 0 && count != exercise.holdCount {
//                    updateCountLabel()
//                } else if count == 0 {
//                    exercise.repeatCount -= 1
//                    if exercise.repeatCount == 0 {
//                        isPaused = true
//                        exercisesWithResults[exercise.title] = highestResult
//                        highestResult = 0.0
//                        exercises.remove(at: 0)
//                        if exercises.count > 0 {
//                            exerciseCompleteView.showCelebrationView()
//                            detectFaceLabel.text = "\(exercises[0].title)"
//                            updateMessage(text: "\(exercises[0].description)")
//                            detectFaceLabel.text = exercises[0].title
//                        }
//                        resetProgressView()
//                        isPaused = false
//                    } else {
//                        count = exercise.holdCount
//                        resetProgressView()
//                        updateMessage(text: exercise.description)
        }
    }
    
}
