//
//  GameSceneViewController.swift
//  MatchEmNav
//
//  Created by Dylan Sarell on 10/29/23.
//  Mobile Apps Assignment 2 - Basic Matching Game with Navigation Controller

import UIKit

class GameSceneViewController: UIViewController {
    
    //@IBOutlet weak var label1: UILabel!
    @IBOutlet weak var scoreTimerLabel: UILabel! // Score and timer Label
    @IBOutlet weak var gameOverLabel: UILabel! // Game Over Label
    @IBOutlet var startButtonOutlet: UIButton! // The Start/retry button
    @IBOutlet weak var pauseButton: UIButton! // Pause/Resume Game Button
    
    var matchRect: [UIButton: Int] = [:] // Dictionary for Matching
    var matchButton: UIButton?
    
    var gameTimerInterval: TimeInterval = 1.0
    var newRectInterval: TimeInterval = 1.0
    var gameTimer: Timer?
    var newRectTimer: Timer?
    
    var gameRunning = false
    var gameTime = 12
    //var rectColors: UIColor
    var bigRec = false
    
    var buttonTag = 0
    var matchCount = 0 {
        didSet {
            self.updateLabel()
        }
    }
    var score = 0 {
        didSet {
            self.updateLabel()
        }
    }
    var timeRemaining = 12 {
        didSet {
            self.updateLabel()
        }
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.gameRunning = true
        self.pauseButton.setTitle("Pause", for: .normal)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //print("red\(#function)", segue.destination)
        let configSceneVC = segue.destination as? ConfigSceneViewController
        configSceneVC?.gameSceneVC = self
        gameRunning = false
    }

    @IBAction func startButton(_ sender: UIButton) {
        self.view.backgroundColor = .white
        startButtonOutlet.setTitle("Restart", for: .normal)
        sender.removeFromSuperview()
        self.gameRunning = true
        StartGame()
    }
    @IBAction func pauseButtonAction(_ sender: UIButton) {
        if self.gameRunning == true {
            pauseButton.setTitle("Resume", for: .normal)
            gameRunning = false
        }
        else {
            pauseButton.setTitle("Pause", for: .normal)
            gameRunning = true
        }
    }
    func StartGame() {
        // restart all the variables to defaults and remove the rectanges from dictionary and screen
        removeRect()
        self.gameOverLabel.text = ""
        self.pauseButton.setTitle("Pause", for: .normal)
        self.matchButton = nil
        self.timeRemaining = 12
        self.score = 0
        self.matchCount = 0
        self.buttonTag = 0
        self.gameTimer = Timer.scheduledTimer(withTimeInterval: self.gameTimerInterval, repeats: true, block: { Timer in
            if self.timeRemaining > 0 {
                if self.gameRunning == true {
                    self.timeRemaining -= 1
                }
            }
            else {
                self.newRectTimer?.invalidate()
                self.view.backgroundColor = .red
                Timer.invalidate()
                self.gameRunning = false
                self.view.addSubview(self.startButtonOutlet)
                self.view.bringSubviewToFront(self.startButtonOutlet)
                self.gameOverLabel.text = "Game Over"
                self.view.bringSubviewToFront(self.gameOverLabel)
            }
        })
        self.newRectTimer = Timer.scheduledTimer(withTimeInterval: newRectInterval, repeats: true, block: { Timer in
            if self.gameRunning == true {
                self.createButton()
                self.matchCount += 1
            }
        })
    }
    
    func updateLabel() {
        if self.gameRunning == true {
            self.scoreTimerLabel.text = "Created \(self.matchCount) - Time: \(self.timeRemaining) - Score: \(self.score)"
            self.view.bringSubviewToFront(self.scoreTimerLabel)
        }
    }
    
    func createButton() { // Creates 2 Rectangles with the same size and color but in random locations.
        let rectSize = self.randSize()
        let rectloc = self.randLocation(rectSize)
        let rectMatch = CGRect(origin: rectloc, size: rectSize)
        let rectloc2 = self.randLocation(rectSize)
        let rectMatch2 = CGRect(origin: rectloc2, size: rectSize)
            
        let buttonMatch = UIButton(frame: rectMatch)
        let buttonMatch2 = UIButton(frame: rectMatch2)
            
        buttonMatch.addTarget(self, action: #selector(handleTap(_:)), for: .touchUpInside)
        buttonMatch2.addTarget(self, action: #selector(handleTap(_:)), for: .touchUpInside)
            
        let matchColor = self.randColor()
        buttonMatch.backgroundColor = matchColor
        buttonMatch2.backgroundColor = matchColor
            
        buttonMatch.tag = self.buttonTag
        buttonMatch2.tag = self.buttonTag
        self.buttonTag += 1
            
        self.view.addSubview(buttonMatch)
        self.view.addSubview(buttonMatch2)
            
        self.matchRect.updateValue(self.buttonTag, forKey: buttonMatch)
        self.matchRect.updateValue(self.buttonTag, forKey: buttonMatch2)

    }
    @objc func handleTap(_ sender: UIButton) {
        if self.gameRunning == true {
            print(self.matchRect[sender]!)
            if let a = self.matchButton {
                if self.matchRect[a] == self.matchRect[sender] && self.matchButton != sender {
                    print("match!")
                    sender.setTitle("👍", for: .normal)
                    a.removeFromSuperview()
                    sender.removeFromSuperview()
                    self.score += 1
                    self.matchButton = nil
                } else {
                    print("not a Match!")
                    a.setTitle("", for: .normal)
                    self.matchButton = nil
                }
            } else {
                print("First rect!")
                self.matchButton = sender
                sender.setTitle("👍", for: .normal)
            }
        }
    }
    func removeRect() {
        for (tag, value) in matchRect {
            tag.removeFromSuperview()
        }
        matchRect.removeAll()
    }
    
  // ---------- Random Size, Location and Color Functions
    func randSize() -> CGSize {
        if bigRec == false {
            let width = CGFloat.random(in: 25.0...100.0)
            let height = CGFloat.random(in: 25.0...100.0)
            return CGSize(width: width, height: height)
        }
        else {
            let width = CGFloat.random(in: 75.0...160.0)
            let height = CGFloat.random(in: 75.0...160.0)
            return CGSize(width: width, height: height)
        }
    }
    func randLocation(_ rectSize: CGSize) -> CGPoint {
        let x = CGFloat.random(in: 0...(self.view.frame.width - (rectSize.width)))
        let topSafeInset = self.view.safeAreaInsets.bottom + 60
        let bottomSafeInset = self.view.safeAreaInsets.top + 70
        let y = CGFloat.random(in: (bottomSafeInset + (rectSize.height/2))...(self.view.frame.height - topSafeInset - (rectSize.height/2)))
        return CGPoint(x: x, y: y)
    }
    func randColor() -> UIColor {
        return UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1.0)
    }
}
