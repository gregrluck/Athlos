//
//  ScorerSettingsTableViewController.swift
//  Athlos
//
//  Created by Lewis Luck on 16/9/18.
//  Copyright © 2018 Fortune Inc. All rights reserved.
//

import UIKit

class ScorerSettingsTableViewController: UITableViewController, UIPopoverControllerDelegate {
    @IBOutlet weak var scoreToWinControl: UISegmentedControl!
    @IBOutlet weak var sport: UISegmentedControl!
    @IBOutlet weak var setsToWin: UILabel!
    @IBOutlet weak var setsToWinStepper: UIStepper!
    @IBOutlet weak var playerOneLabel: UILabel!
    @IBOutlet weak var playerTwoLabel: UILabel!
    @IBOutlet weak var playerOneProfilePic: UIImageView!
    @IBOutlet weak var playerTwoProfilePic: UIImageView!
    @IBOutlet weak var playerOneColour: UIView!
    @IBOutlet weak var playerTwoColour: UIView!
    @IBOutlet weak var saveScoresSwitch: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updatePlayers()
        updateWithGameSettings()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "saveGameSettings" {
            gameSettings.scoreToWin = Int(scoreToWinControl.titleForSegment(at: scoreToWinControl.selectedSegmentIndex)!)
            gameSettings.setsToWin = Int(setsToWin.text!)
            gameSettings.sport = sport.titleForSegment(at: sport.selectedSegmentIndex)
            gameSettings.casual = !saveScoresSwitch.isOn
        }
    }
    
    func updateWithGameSettings() {
        if let saveScore = gameSettings.casual {
            saveScoresSwitch.isOn = !saveScore
        }
        if let scoreToWin = gameSettings.scoreToWin {
            var segmentIndex = 2
            
            switch scoreToWin {
            case 5: segmentIndex = 0
            case 11: segmentIndex = 1
            case 21: segmentIndex = 2
            default: segmentIndex = 0
            }
            
            scoreToWinControl.selectedSegmentIndex = segmentIndex
        }
        if let setsToWinSaved = gameSettings.setsToWin {
            setsToWin.text = "\(setsToWinSaved)"
            setsToWinStepper.value = Double(setsToWinSaved)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 && indexPath.row == 0 {
            performSegue(withIdentifier: "choosePlayer", sender: nil)
        }
    }
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        updateSetsToWin()
    }
    
    func updatePlayers() {
        if let player1 = gameSettings.playerOne {
            playerOneLabel.text = player1.nickname ?? player1.description
            playerOneColour.backgroundColor = User.convertToColour(colour: player1.themeColour!)
            playerOneProfilePic.image = player1.convertToImage()
            playerOneProfilePic.layer.cornerRadius = playerOneProfilePic.frame.height/2
            playerOneProfilePic.layer.masksToBounds = false
            playerOneProfilePic.clipsToBounds = true
        }
        if let player2 = gameSettings.playerTwo {
            playerTwoLabel.text = player2.nickname ?? player2.description
            playerTwoColour.backgroundColor = User.convertToColour(colour: player2.themeColour!)
            playerTwoProfilePic.image = player2.convertToImage()
            playerTwoProfilePic.layer.cornerRadius = playerTwoProfilePic.frame.height/2
            playerTwoProfilePic.layer.masksToBounds = false
            playerTwoProfilePic.clipsToBounds = true
        }
    }
    
    func updateSetsToWin() {
        setsToWin.text = "\(Int(setsToWinStepper.value))"
    }
    
    @IBAction func unwindFromChoosePlayer(unwindSegue: UIStoryboardSegue) {
        guard let source = unwindSegue.source as? ChoosePlayersTableViewController else {return}
        gameSettings.playerOne = source.playerOne
        gameSettings.playerTwo = source.playerTwo
        updatePlayers()             
        
        
    }
}
