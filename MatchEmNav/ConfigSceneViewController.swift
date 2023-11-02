//
//  ConfigSceneViewController.swift
//  MatchEmNav
//
//  Created by Dylan Sarell on 10/29/23.
//
/*
let GameManager = [
    "Dasnay": 20,
    "Kevin": 17,
    "Sarah": 23
]*/
struct HighScore {
    var name: String
    var score: Int
}

import UIKit

class ConfigSceneViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var gameSceneVC: GameSceneViewController?
    
    @IBOutlet weak var highScoreTable: UITableView!
    
    @IBOutlet weak var SpeedSlider: UISlider!
    @IBOutlet weak var bigRecToggle: UISwitch!
    @IBOutlet weak var gameTimerStepper: UIStepper!
    
    var data: [HighScore]?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.highScoreTable.delegate = self
        self.highScoreTable.dataSource = self
        self.highScoreTable.rowHeight = 50
        self.data = [HighScore(name: "Sarah", score: 23), HighScore(name: "Dasnay", score: 20), HighScore(name: "Kevin", score: 17)]
    }
    override func viewWillAppear(_ animated: Bool) {
        SpeedSlider.value = Float(1 / (gameSceneVC?.newRectInterval)!)
        bigRecToggle.isOn = (gameSceneVC?.bigRec)!
        gameTimerStepper.value = Double((gameSceneVC?.timeRemaining)!)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    
    @IBAction func SpeedSilderAction(_ sender: UISlider) {
        gameSceneVC?.newRectTimer?.invalidate()
        var rate = 1.0 / Double(SpeedSlider.value)
        gameSceneVC?.newRectInterval = rate
        
        gameSceneVC?.newRectTimer = Timer.scheduledTimer(withTimeInterval: (gameSceneVC?.newRectInterval)!, repeats: true, block: { [self] Timer in
            if gameSceneVC?.gameRunning == true {
                gameSceneVC?.createButton()
                gameSceneVC?.matchCount += 1
            }
        })
    }
    
    @IBAction func bigRecAction(_ sender: UISwitch) {
        gameSceneVC?.bigRec = bigRecToggle.isOn
    }
    @IBAction func gameTimerAction(_ sender: UIStepper) {
        gameTimerStepper.minimumValue = 10
        gameTimerStepper.maximumValue = 60
        gameSceneVC?.timeRemaining = Int(gameTimerStepper.value)
    }

}
