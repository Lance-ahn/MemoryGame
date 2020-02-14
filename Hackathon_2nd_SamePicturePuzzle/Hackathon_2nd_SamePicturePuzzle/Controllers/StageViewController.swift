//
//  ViewController.swift
//  puzzle
//
//  Created by macbook on 2020/01/31.
//  Copyright © 2020 Lance. All rights reserved.
//
import UIKit
import AVFoundation

class UI {
    static var itemsInLine: CGFloat!
    static var linesOnScreen: CGFloat!
    static let itemSpacing: CGFloat = 10.0
    static let lineSpacing: CGFloat = 7
    static let edgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
}

class StageViewController: UIViewController {
    var dataCards: [Cards]!
    var rememberTime: Double!
    private var doNotTouch = false
    private var starter = true
    private var timer = Timer()
    private var player = AVAudioPlayer()
    private var isPause = false
    private let pauseLabel = UILabel()
    private let backgroundImage = UIImageView()
    private let leftDoor = UIImageView()
    private let rightDoor = UIImageView()
    var countDownLabel = UILabel()
    lazy var pauseButton = UIBarButtonItem(title: "pause", style: .plain, target: self, action: #selector(pause(_:)))
    var time: Double = 0.0
    
    private var selectedIndexPath: [IndexPath] = [] {
        didSet {
            print("선택 한 카드 좌표 값: \(selectedCards)")
        }
    }
    
    private var matchedIndexPath: [IndexPath] = []
    
    private var selectedCards: [Int] = [] {
        didSet {
            print("선택 된 카드: \(selectedCards)")
        }
    }
    private var matchedItem: [Int] = [] {
        didSet {
            print("매치 완성 : \(matchedItem)")
        }
    }
    
    let layout = UICollectionViewFlowLayout()
    lazy var cardCollectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = .clear
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        // 스와이프로 팝 제스쳐 막아놓기
        setupCollectionView()
        startTimer()
    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        setupFlowLayout()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        starter = false
        cardCollectionView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        leftDoor.isHidden = true
        rightDoor.isHidden = true
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupFlowLayout()
    }
    
    func setupCollectionView() {
        countDownLabel.font = UIFont(name: "diablo", size: 25)
        countDownLabel.textColor = #colorLiteral(red: 0.4784313725, green: 0.02745098039, blue: 0.06274509804, alpha: 1)
        countDownLabel.frame.size = CGSize(width: 100, height: 40)
        countDownLabel.textAlignment = .center
        self.navigationItem.titleView = countDownLabel
        
        backgroundImage.image = UIImage(named: "night")
        
        // 매치 끝나면 실행
        view.bringSubviewToFront(leftDoor)
        view.bringSubviewToFront(rightDoor)
        
        leftDoor.image = UIImage(named: "leftDoor")
        rightDoor.image = UIImage(named: "rightDoor")
        
        view.addSubview(leftDoor)
        view.addSubview(rightDoor)
        
        leftDoor.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leftDoor.topAnchor.constraint(equalTo: view.topAnchor),
            leftDoor.trailingAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        rightDoor.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            rightDoor.topAnchor.constraint(equalTo: view.topAnchor),
            rightDoor.leadingAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        leftDoor.transform = CGAffineTransform(translationX: -600, y: 0)
        rightDoor.transform = CGAffineTransform(translationX: 600, y: 0)
        
        pauseLabel.text = "Pause"
        pauseLabel.font = UIFont(name: "diablo", size: 40)
        pauseLabel.backgroundColor = .black
        pauseLabel.textColor = #colorLiteral(red: 0.4784313725, green: 0.02745098039, blue: 0.06274509804, alpha: 1)
        pauseLabel.isHidden = true
        pauseLabel.textAlignment = .center
        view.addSubview(pauseLabel)
        view.sendSubviewToBack(pauseLabel)
        pauseLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pauseLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pauseLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        
        cardCollectionView.backgroundView = backgroundImage
        cardCollectionView.isMultipleTouchEnabled = true
        cardCollectionView.allowsSelection = true
        cardCollectionView.register(PuzzleCollectionViewCell.self, forCellWithReuseIdentifier: PuzzleCollectionViewCell.identifier)
        cardCollectionView.dataSource = self
        cardCollectionView.delegate = self
        cardCollectionView.allowsMultipleSelection = true
        view.addSubview(cardCollectionView)
    }
    
    func setupFlowLayout(){
        layout.minimumLineSpacing = UI.lineSpacing
        layout.minimumInteritemSpacing = UI.itemSpacing
        layout.sectionInset = UI.edgeInsets
        fitItemsAndLineOnScreen()
    }
    func fitItemsAndLineOnScreen() {
        let itemSpacing = UI.itemSpacing * (UI.itemsInLine - 1)
        //        let lineSpacing = UI.lineSpacing * (UI.linesOnScreen - 1)
        let lineSpacing = UI.lineSpacing * (UI.linesOnScreen)
        let horizontalInset = UI.edgeInsets.left + UI.edgeInsets.right
        let verticalInset = UI.edgeInsets.top + UI.edgeInsets.bottom
            + view.safeAreaInsets.top
            //  + UI.underItemMargin
            + view.safeAreaInsets.bottom // 노치있는기기와 없는기기
        // viewdidload에서 safeAreaInsets 적용안됨
        let isVertical = layout.scrollDirection == .vertical
        let horizontalSpacing = (isVertical ? itemSpacing : lineSpacing) + horizontalInset
        let verticalSpacing = (isVertical ? lineSpacing : itemSpacing) + verticalInset
        let contentWidth = cardCollectionView.frame.width - horizontalSpacing
        let contentHeight = cardCollectionView.frame.height - verticalSpacing
        let width = contentWidth / (isVertical ? UI.itemsInLine : UI.linesOnScreen)
        let height = contentHeight / (isVertical ? UI.linesOnScreen : UI.itemsInLine)
        layout.itemSize = CGSize(
            width: width.rounded(.down) - 1,
            height: height.rounded(.down) - 1)
    }
    //    var first = ""
}
extension StageViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataCards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PuzzleCollectionViewCell.identifier, for: indexPath) as! PuzzleCollectionViewCell
        
        // 2초 동안 카드 보여주기
        if !starter {
            cell.openAnimate()
            cell.configure(image: dataCards[indexPath.item].name)
            DispatchQueue.main.asyncAfter(deadline: .now() + rememberTime) {
                
                cell.closeAnimate()
                cell.configure(image: "back")
                self.starter = indexPath.item == (self.dataCards.count - 1) ? true: false
                
                // 일시정지 버튼 생성
                //                let pauseButton = UIBarButtonItem(title: "pause", style: .plain, target: self, action: #selector(pause(_:)))
                self.pauseButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "diablo", size: 20) as Any], for: .normal)
                self.navigationItem.rightBarButtonItem = self.pauseButton
                self.navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 0.4784313725, green: 0.02745098039, blue: 0.06274509804, alpha: 1)
            }
        }
        return cell
    }
}
extension StageViewController: UICollectionViewDelegateFlowLayout {
    
    // 선택 되면 카드 앞면
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? PuzzleCollectionViewCell else { return }
        flipCardSound()
        selectedCards.append(indexPath.item)
        selectedIndexPath.append(indexPath)
        
        cell.configure(image: dataCards[indexPath.item].name)
        
        if selectedIndexPath.count == 2 {
            self.compare()
        } else {
            print("")
        }
    }
    
    // 선택 풀면 카드 뒷면
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? PuzzleCollectionViewCell else { return }
        flipCardSound()
        if let index = selectedCards.firstIndex(of: indexPath.item) {
            selectedCards.remove(at: index)
            selectedIndexPath.remove(at: index)
        }
        cell.configure(image: "back")
    }
    
    // filp Action 제한
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        guard starter else { return false }
        guard selectedIndexPath.count < 2, !matchedItem.contains(indexPath.item), !isPause, !doNotTouch else { return false }
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        guard selectedIndexPath.count < 2, !matchedItem.contains(indexPath.item), !isPause, !doNotTouch else { return false}
        return true
    }
}

extension StageViewController {
    
    private func initialize() {
        selectedCards.removeAll()
        selectedIndexPath.removeAll()
    }
    
    private func compare() {
        // 두 카드가 같으면, 매치 배열에 추가, 선택된 카드 리스트 초기화, open 카운트 초기화
        if dataCards[selectedCards[0]].name == dataCards[selectedCards[1]].name {
            for i in 0 ..< selectedCards.count {
                matchedItem.append(selectedCards[i])
            }
            matchedIndexPath = selectedIndexPath
            
            // 스테이지 클리어
            if matchedItem.count == dataCards.count {
                timer.invalidate()
                pauseButton.isEnabled = false
                let currentRecord = time
                
                let bestRecord: Double
                if let tempBestRecord = UserDefaults.standard.object(forKey: "night") as? Double {
                    if currentRecord < tempBestRecord {
                        print("갱신")
                        bestRecord = currentRecord
                    } else {
                        print("갱신 실패")
                        bestRecord = tempBestRecord
                    }
                    
                } else {
                    print("기록 없음")
                    bestRecord = currentRecord
                }
                print(bestRecord)
                UserDefaults.standard.set(bestRecord, forKey: "night")
                
                view.bringSubviewToFront(leftDoor)
                view.bringSubviewToFront(rightDoor)
                
                
                UIView.animate(withDuration: 1, animations: {
                    self.leftDoor.transform =  .identity
                    self.rightDoor.transform = .identity
                })
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    self.closeTheGateSound()
                }
            }
            initialize()
            self.doNotTouch = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                UIView.animate(withDuration: 0.3, animations: {
                    self.matchedIndexPath.forEach {
                        let cell = self.cardCollectionView.cellForItem(at: $0) as! PuzzleCollectionViewCell
                        cell.alpha = 0
                        self.doNotTouch = false
                    }
                })
            }
        } else {
            // 다르면, 일단 선택 카드 뒤집고, 0.5초 뒤에 둘 다 뒤집고, false로 바꾸고, 선택카드 리스트 초기화
            doNotTouch = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.selectedIndexPath.forEach {
                    self.cardCollectionView.deselectItem(at: $0, animated: false)
                    (self.cardCollectionView.cellForItem(at: $0) as! PuzzleCollectionViewCell).configure(image: "back")
                    self.doNotTouch = false
                }
                self.initialize()
            }
        }
        
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(update), userInfo: nil, repeats: true)
    }
    
    @objc func update() {
        if(time >= 0.00) {
            time += 0.01
            countDownLabel.text = String(format: "%.2f", time)
        }
    }
    
    @objc func pause(_ sender: UIButton) {
        if isPause {
            startTimer()
            pauseLabel.isHidden = true
            view.sendSubviewToBack(pauseLabel)
        } else {
            timer.invalidate()
            pauseLabel.isHidden = false
            view.bringSubviewToFront(self.pauseLabel)
        }
        isPause.toggle()
    }
    
    func flipCardSound() {
        guard let soundAsset: NSDataAsset = NSDataAsset(name: "flip1") else {
            print("음원 파일을 가져올 수 없습니다")
            return
        }
        do {
            try self.player = AVAudioPlayer(data: soundAsset.data)
            player.play()
        } catch let error as NSError {
            print("Error : \(error.code), Message : \(error.localizedDescription)")
        }
    }
    
    func closeTheGateSound() {
        guard let soundAsset: NSDataAsset = NSDataAsset(name: "jailDoor") else {
            print("음원 파일을 가져올 수 없습니다")
            return
        }
        do {
            try self.player = AVAudioPlayer(data: soundAsset.data)
            player.play()
        } catch let error as NSError {
            print("Error : \(error.code), Message : \(error.localizedDescription)")
        }
    }
}


