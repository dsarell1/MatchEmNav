//
//  ConfigSceneViewController.swift
//  MatchEmNav
//
//  Created by Dylan Sarell on 10/29/23.
//

let GameManager = [15, 10, 0]

import UIKit

class ConfigSceneViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var gameSceneVC: GameSceneViewController?
    
    @IBOutlet weak var highScoreTable: UITableView!
    
    @IBOutlet weak var SpeedSlider: UISlider!
    @IBOutlet weak var bigRecToggle: UISwitch!
    @IBOutlet weak var gameTimerStepper: UIStepper!
    @IBOutlet weak var blackWhiteToggle: UISwitch!
    
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var gameTimeLabel: UILabel!
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var bigRecLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.SpeedSlider.value = 1
        self.gameTimerStepper.value = 10
        self.bigRecToggle.isOn = false
        self.highScoreTable.delegate = self
        self.highScoreTable.dataSource = self
        self.highScoreTable.rowHeight = 50
    }
    override func viewWillAppear(_ animated: Bool) {
        SpeedSlider.value = Float(1 / (gameSceneVC?.newRectInterval)!)
        bigRecToggle.isOn = (gameSceneVC?.bigRec)!
        blackWhiteToggle.isOn = (gameSceneVC?.recColorBlackNWhite)!
        gameTimerStepper.value = Double((gameSceneVC?.timeRemaining)!)
        self.speedLabel.text = "Speed " + String(SpeedSlider.value)
        self.gameTimeLabel.text = "Game Time: " + String(gameTimerStepper.value)
        if bigRecToggle.isOn {
            self.bigRecLabel.text = "Big Rectangles: On"
        }
        else {
            self.bigRecLabel.text = "Big Rectangles: Off"
        }
        if blackWhiteToggle.isOn {
            self.colorLabel.text = "Grey Scale Mode: On"
        }
        else {
            self.colorLabel.text = "Grey Scale Mode: Off"
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = highScoreTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableCell
        
        //cell.scoreLabel.text = String(UserDefaults.standard.integer(forKey: "HighScore"))
        let newGameManager = [UserDefaults.standard.integer(forKey: "HighScore"), UserDefaults.standard.integer(forKey: "LastScore"), UserDefaults.standard.integer(forKey: "LowScore")]
        
        cell.scoreLabel.text = "Score: " + String(newGameManager[indexPath.row])
        return cell
    }
    
    @IBAction func SpeedSilderAction(_ sender: UISlider) {
        gameSceneVC?.newRectTimer?.invalidate()
        let rate = 1.0 / Double(SpeedSlider.value)
        self.speedLabel.text = "Speed " + String(SpeedSlider.value)
        gameSceneVC?.newRectInterval = rate
        UserDefaults.standard.setValue(rate, forKey: "GameSpeed")
        
        gameSceneVC?.newRectTimer = Timer.scheduledTimer(withTimeInterval: (gameSceneVC?.newRectInterval)!, repeats: true) { Timer in
            if self.gameSceneVC?.gameRunning == true {
                self.gameSceneVC?.createButton()
                self.gameSceneVC?.matchCount += 1
            }
        }
    }
    
    @IBAction func bigRecAction(_ sender: UISwitch) {
        gameSceneVC?.bigRec = bigRecToggle.isOn
        if bigRecToggle.isOn {
            self.bigRecLabel.text = "Big Rectangles: On"
        }
        else {
            self.bigRecLabel.text = "Big Rectangles: Off"
        }
        UserDefaults.standard.setValue(String(bigRecToggle.isOn), forKey: "BigRec")
    }
    @IBAction func gameTimerAction(_ sender: UIStepper) {
        gameTimerStepper.minimumValue = 0
        gameTimerStepper.maximumValue = 60
        gameSceneVC?.timeRemaining = Int(gameTimerStepper.value)
        self.gameTimeLabel.text = "Game Time: " + String(gameTimerStepper.value)
        UserDefaults.standard.setValue((Int(gameTimerStepper.value)), forKey: "GameTime")
    }

    @IBAction func colorAction(_ sender: UISwitch) {
        gameSceneVC?.recColorBlackNWhite = blackWhiteToggle.isOn
        if blackWhiteToggle.isOn {
            self.colorLabel.text = "Grey Scale Mode: On"
        }
        else {
            self.colorLabel.text = "Grey Scale Mode: Off"
        }
        UserDefaults.standard.setValue(String(blackWhiteToggle.isOn), forKey: "GreyScale")
    }
}
class CustomTableCell: UITableViewCell {

    @IBOutlet weak var scoreLabel: UILabel!
    
}
