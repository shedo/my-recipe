//
//  Instruction.swift
//  MyRecipe
//
//  Created by Ivan Zandonà on 13/12/20.
//

import UIKit

class InstructionViewController: UITableViewController {
    
    var recipeInstructionsList: [AnalyzedInstruction] = []
    var stepsList: [Step] = []
    var savedInstructionList: [Instruction] = []
    var savedInstruction: Bool = false
    
    override func viewDidLoad() {
        if savedInstructionList.count == 0 {
            self.stepsList = self.recipeInstructionsList[0].steps
        } else {
            savedInstruction = true
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return !savedInstruction ? self.stepsList.count : savedInstructionList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InstructionTableViewCell")!
        cell.sizeToFit()
        cell.textLabel?.numberOfLines = 0
        
        if(!savedInstruction) {
            let step = self.stepsList[indexPath.row]
            cell.textLabel?.text = "\(step.number). \(step.step)"
        } else {
            let step = self.savedInstructionList[indexPath.row]
            cell.textLabel?.text = "\(step.stepNumber). \(step.instruction ?? ""))"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

}
