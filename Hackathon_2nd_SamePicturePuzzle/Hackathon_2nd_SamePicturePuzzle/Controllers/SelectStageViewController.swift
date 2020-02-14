//
//  SelectStageViewController.swift
//  Hackathon_2nd_SamePicturePuzzle
//
//  Created by MyMac on 2020/02/03.
//  Copyright © 2020 sandMan. All rights reserved.
//

import UIKit
import AVFoundation

class SelectStageViewController: UIViewController {
    private let imageView = UIImageView()
    private let gameNameLabel = UILabel()
    
    private let normalButton: StageButton = {
       let button = StageButton()
        button.stage = .normal
        return button
    }()
    
    private let nightButton: StageButton = {
       let button = StageButton()
        button.stage = .nightmare
        return button
    }()
    
    private let hellButton: StageButton = {
       let button = StageButton()
        button.stage = .hell
        return button
    }()
    
    private let recordButton = UIButton()
    
    var player = AVAudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        initializePlayer()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        // 폰트 바꾸기 및 뒤로가기
        backButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "diablo", size: 20) as Any], for: .normal)
        self.navigationItem.backBarButtonItem = backButton
        self.navigationItem.backBarButtonItem?.tintColor = #colorLiteral(red: 0.4784313725, green: 0.02745098039, blue: 0.06274509804, alpha: 1)
    }
    
    private func setUI() {
        // 네비게이션 바에 타이머
        imageView.frame = view.frame
        imageView.image = UIImage(named: "background")
        imageView.contentMode = .scaleAspectFit
        
        gameNameLabel.font = UIFont(name: "diablo", size: 40)
        gameNameLabel.textColor = .darkGray
        gameNameLabel.textAlignment = .center
        gameNameLabel.text = "Memory Game"
        
        
        // 버튼 세팅
        normalButton.setTitle("Normal", for: .normal)
        normalButton.addTarget(self, action: #selector(touchTheStageButton(_:)), for: .touchUpInside)
        nightButton.setTitle("Nightmare", for: .normal)
        nightButton.addTarget(self, action: #selector(touchTheStageButton(_:)), for: .touchUpInside)
        hellButton.setTitle("Hell", for: .normal)
        hellButton.addTarget(self, action: #selector(touchTheStageButton(_:)), for: .touchUpInside)
        recordButton.setTitle("Records", for: .normal)
        recordButton.addTarget(self, action: #selector(touchRecordsButton(_:)), for: .touchUpInside)
        
        setConstraints()
    }
    
    private func setConstraints() {
        let guide = self.view.safeAreaLayoutGuide
        
        let UIArray = [
            imageView, gameNameLabel, normalButton, nightButton, hellButton, recordButton
        ]
        
        
        UIArray.forEach {
            self.view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let UIButtons = [
            normalButton, nightButton, hellButton, recordButton
        ]
        
        UIButtons.forEach {
            $0.setBackgroundImage(UIImage(named: "stageBtn.png"), for: .normal)
            $0.imageView?.contentMode = .scaleToFill
            $0.titleLabel?.font = UIFont(name: "diablo", size: 17)
            //일반 커스텀 UI
            $0.setTitleColor(.darkGray, for: .normal)
        }
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: guide.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: guide.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            gameNameLabel.centerXAnchor.constraint(equalTo: guide.centerXAnchor),
            gameNameLabel.centerYAnchor.constraint(equalTo: guide.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            normalButton.centerXAnchor.constraint(equalTo: guide.centerXAnchor),
            normalButton.bottomAnchor.constraint(equalTo: nightButton.topAnchor),
            normalButton.widthAnchor.constraint(equalTo: guide.widthAnchor, multiplier: 0.7),
            normalButton.heightAnchor.constraint(equalToConstant: 70),
        ])
        
        NSLayoutConstraint.activate([
            nightButton.centerXAnchor.constraint(equalTo: guide.centerXAnchor),
            nightButton.bottomAnchor.constraint(equalTo: hellButton.topAnchor),
            nightButton.widthAnchor.constraint(equalTo: guide.widthAnchor, multiplier: 0.7),
            nightButton.heightAnchor.constraint(equalToConstant: 70),
        ])
        
        NSLayoutConstraint.activate([
            hellButton.centerXAnchor.constraint(equalTo: guide.centerXAnchor),
            hellButton.bottomAnchor.constraint(equalTo: recordButton.topAnchor),
            hellButton.widthAnchor.constraint(equalTo: guide.widthAnchor, multiplier: 0.7),
            hellButton.heightAnchor.constraint(equalToConstant: 70),
        ])
        
        NSLayoutConstraint.activate([
            recordButton.centerXAnchor.constraint(equalTo: guide.centerXAnchor),
            recordButton.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -30),
            recordButton.widthAnchor.constraint(equalTo: guide.widthAnchor, multiplier: 0.7),
            recordButton.heightAnchor.constraint(equalToConstant: 70),
        ])

    }
}

extension SelectStageViewController {
    @objc private func touchTheStageButton(_ sender: StageButton) {
        let gameVC = StageViewController()
        
        switch sender.stage {
            
        case .normal:
            UI.itemsInLine = 5
            UI.linesOnScreen = 4
            gameVC.rememberTime = 2
            gameVC.dataCards = (normalCards + normalCards).shuffled()
            
        case .nightmare:
            
            UI.itemsInLine = 5
            UI.linesOnScreen = 8
            gameVC.rememberTime = 3
            gameVC.dataCards = (nightCards + nightCards).shuffled()
            
        case .hell:
            UI.itemsInLine = 6
            UI.linesOnScreen = 10
            gameVC.rememberTime = 5
            gameVC.dataCards = (hellCards + hellCards).shuffled()
        case .none:
            break
        }
        
        self.navigationController?.pushViewController(gameVC, animated: true)
    }

    
    @objc private func touchRecordsButton(_ sender: UIButton) {
        let recordVC = RecordViewController()
        present(recordVC, animated: true, completion: nil)
//        self.navigationController?.pushViewController(recordVC, animated: true)
    }
}

// 사운드 관련
extension SelectStageViewController {
    func initializePlayer() {
        guard let soundAsset: NSDataAsset = NSDataAsset(name: "act1") else {
            print("음원 파일을 가져올 수 없습니다")
            return
        }
        do {
            try self.player = AVAudioPlayer(data: soundAsset.data)
            player.play()
            player.numberOfLoops = -1
        } catch let error as NSError {
            print("Error : \(error.code), Message : \(error.localizedDescription)")
        }
    }
}

