//
//  CoindeskViewController.swift
//  Coindesk(HW3)
//
//  Created by Иса on 21.11.2022.
//

import UIKit

class CoindeskViewController: UIViewController {
    
    @IBOutlet var bpiHeaderLabel: UILabel!
    @IBOutlet var bpiFooterLabel: UILabel!
    @IBOutlet var bpiTextField: UITextField!
    
    private var pickerViewForBPI = UIPickerView()
    private var coindesk: Coindesk?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerViewForBPI.delegate = self
        pickerViewForBPI.dataSource = self
        bpiTextField.inputView = pickerViewForBPI
        
        fetchData()
    }
}

// MARK: Extension CoindeskViewController
extension CoindeskViewController {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func fetchData() {
        
        NetworkManager.shared.fetch(from: urlCoindesk) { [weak self] result in
            switch result {
            case .success(let data):
                guard let data = try? JSONDecoder().decode(Coindesk.self, from: data) else { return }

                DispatchQueue.main.async {
                    self?.coindesk = data
                }
            case .failure(_):
                DispatchQueue.main.async {
                    let alertError = UIAlertController(title: "Error!!!", message: "No data", preferredStyle: .alert)
                    let OkButton = UIAlertAction(title: "OK", style: .cancel)
                    alertError.addAction(OkButton)
                    self?.present(alertError, animated: true)
                }
            }
        }
    }
    
    private func getBPIHeader(with coindesk: Coindesk?) -> String? {
        guard let coindesk = coindesk else { return ""}
        let textBPI = """
Time: \(coindesk.time.updated)\n
Disclaimer: \(coindesk.disclaimer)\n
Chart name: \(coindesk.chartName)\n
"""
        return textBPI
    }
    
    private func getBPIFooter(with bpi: Currency?) -> String? {
        guard let bpi = bpi else { return ""}
        let textBPI = """
Code: \(bpi.code)
Symbol: \(bpi.symbol)
Rate: \(bpi.rate)
Description: \(bpi.description)
Rate float: \(bpi.rate_float)
"""
        return textBPI
    }
}

// MARK: Extension UIPickerView
extension CoindeskViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        3
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let bpi = coindesk?.bpi else { return "" }
        
        switch row {
        case 0: return bpi.USD.code
        case 1: return bpi.GBP.code
        default: return bpi.EUR.code
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let bpi = coindesk?.bpi else { return }
        bpiHeaderLabel.text = getBPIHeader(with: coindesk)
        
        switch row {
        case 0:
            bpiTextField.text = bpi.USD.code
            bpiFooterLabel.text = getBPIFooter(with: bpi.USD) ?? ""
        case 1:
            bpiTextField.text = bpi.GBP.code
            
            bpiFooterLabel.text = getBPIFooter(with: bpi.GBP) ?? ""
        default:
            bpiTextField.text = bpi.EUR.code
            bpiFooterLabel.text = getBPIFooter(with: bpi.EUR) ?? ""
        }
    }
    
}
