//
//  RecordViewController.swift
//  Hackathon_2nd_SamePicturePuzzle
//
//  Created by MyMac on 2020/02/07.
//  Copyright © 2020 sandMan. All rights reserved.
//

import UIKit

class RecordViewController: UIViewController {
    
    let imageView = UIImageView()
    let recordView = UIView()
    let recordLabel = UILabel()
    let normalLabel = UILabel()
    let normalRecordLabel = UILabel()
    let nightLabel = UILabel()
    let nightRecordLabel = UILabel()
    let hellLabel = UILabel()
    let hellRecordLabel = UILabel()
    
    let userDefault = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()        
    }
    
    private func setUI() {
        imageView.image = UIImage(named: "record")
        
        recordView.backgroundColor = .white
        recordView.alpha = 0.5
        
        recordLabel.text = "Best Records"
        recordLabel.font = UIFont(name: "diablo", size: 40)
        recordLabel.textColor = #colorLiteral(red: 0.4784313725, green: 0.02745098039, blue: 0.06274509804, alpha: 1)
        
        normalLabel.text = "Normal :"
        nightLabel.text = "Nightmare :"
        hellLabel.text = "Hell :"
        
        let normalDouble = userDefault.object(forKey: "normal") as? Double ?? 0.0
        let normalRecord = String(format: "%.2f", normalDouble)
        normalRecordLabel.text = normalRecord
        
        let nightDouble = userDefault.object(forKey: "night") as? Double ?? 0.0
        let nightRecord = String(format: "%.2f", nightDouble)
        nightRecordLabel.text = nightRecord
        
        let hellDouble = userDefault.object(forKey: "hell") as? Double ?? 0.0
        let hellRecord = String(format: "%.2f", hellDouble)
        hellRecordLabel.text = hellRecord
        
        let views = [imageView, recordLabel, recordView, normalLabel, nightLabel, hellLabel, normalRecordLabel, nightRecordLabel, hellRecordLabel]
        views.forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let labels = [normalLabel, nightLabel, hellLabel, normalRecordLabel, nightRecordLabel, hellRecordLabel]
        labels.forEach {
            $0.font = UIFont(name: "diablo", size: 22)
            $0.textColor = #colorLiteral(red: 0.4784313725, green: 0.02745098039, blue: 0.06274509804, alpha: 1)
            recordView.addSubview($0)
        }
        
        setConstraint()
    }
    
    private func setConstraint() {
        let guide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
        ])
        
        NSLayoutConstraint.activate([
            recordLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            recordLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 50)
        ])
        
        NSLayoutConstraint.activate([
            recordView.centerYAnchor.constraint(equalTo: guide.centerYAnchor),
            recordView.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 50),
            recordView.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -50),
            recordView.heightAnchor.constraint(equalToConstant: 300)
        ])
        
        NSLayoutConstraint.activate([
            normalLabel.bottomAnchor.constraint(equalTo: nightLabel.topAnchor, constant: -60),
            normalLabel.leadingAnchor.constraint(equalTo: recordView.leadingAnchor, constant: 10),
        ])
        
        NSLayoutConstraint.activate([
            nightLabel.centerYAnchor.constraint(equalTo: recordView.centerYAnchor),
            nightLabel.leadingAnchor.constraint(equalTo: recordView.leadingAnchor, constant: 10)
        ])
        
        NSLayoutConstraint.activate([
            hellLabel.topAnchor.constraint(equalTo: nightLabel.bottomAnchor, constant: 60),
            hellLabel.leadingAnchor.constraint(equalTo: recordView.leadingAnchor, constant: 10),
        ])
        
        
        
        NSLayoutConstraint.activate([
            normalRecordLabel.bottomAnchor.constraint(equalTo: nightLabel.topAnchor, constant: -60),
            normalRecordLabel.trailingAnchor.constraint(equalTo: recordView.trailingAnchor, constant: -10),
        ])
        
        NSLayoutConstraint.activate([
            nightRecordLabel.centerYAnchor.constraint(equalTo: recordView.centerYAnchor),
            nightRecordLabel.trailingAnchor.constraint(equalTo: recordView.trailingAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            hellRecordLabel.topAnchor.constraint(equalTo: nightLabel.bottomAnchor, constant: 60),
            hellRecordLabel.trailingAnchor.constraint(equalTo: recordView.trailingAnchor, constant: -10),
        ])
        
    }
}


