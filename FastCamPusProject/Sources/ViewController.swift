//
//  ViewController.swift
//  TradeDiary
//
//  Created by 주호박 on 2018. 4. 7..
//  Copyright © 2018년 주호박. All rights reserved.
//
import Firebase
import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var contentsView: UIView!
    @IBOutlet weak var barView:UIView!
    
    //MARK:- custom Tab bar 에 해당하는 IBOutlet Hook Up
    @IBOutlet var buttons: [UIButton]!
    
    
    /************
     탭바의 모든 버튼이 뷰컨트롤러로 이동하진 않는다.
     달, 년 버튼의 경우에는 탭바를 덮는 컬렉션 뷰가 나온다.
     설정 뷰, 새 포스팅 뷰만 이동이된다.
    ************/
    
    //MARK:- Instance VC
    var settingViewController: UIViewController!
    var newPostViewController: UIViewController!
    var listingDiaryViewController: UIViewController!
    
    //MARK:- Instance CVC
    var monthCollectionViewController: UICollectionViewController!
    
    var viewControllers: [UIViewController] = []
    var selectedIndex: Int = 1
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("============ [ ViewController ] ============")
        let user = Auth.auth().currentUser
        
        if user != nil {
            print("User is signed in.")
//            print(user?.displayName! ?? "")
            print(user?.uid)
            sleep(1)
            AuthService.init().Login(uid: (user?.uid)!) { (result) in
                print("============ [ load User data ] ============")
                switch(result){
                case .success(let value):
                    print(value)
                case .error(let error):
                    print(error.localizedDescription)
                case .loginerror(_):
                    break
                }
            }
        } else {
            print("No user is signed in.")
        }
        
        self.appendViewControllerList()
        // contentsView에 ListingViewController를 보여준다 -> 시작 화면
        let commonView = viewControllers[0]
        addChildViewController(commonView)// 현재 화면의 VC에 해당 VC를 자식으로 추가
        commonView.view.frame = contentsView.bounds// 자식 VC view 크기 지정
        contentsView.addSubview(commonView.view)// 현 화면 VC의 ContentsView에 addsubView
        commonView.didMove(toParentViewController: self)//포함되는 VC가 변경되었을때 reload 해줌.
        // 다시 이화면으로 올수 있도록 Dissmiss하는 기능을 각 뷰에 넣어야함.
        
//        self.buttons[self.selectedIndex].isSelected = true
//        self.didPushTabButton(self.buttons[self.selectedIndex])

        

        
//        appendViewControllerList()
//
//        // 초기에 보여줄 화면을 설정
//        buttons[selectedIndex].isSelected = true
//        didPushTabButton(buttons[selectedIndex])
    }
    override func loadViewIfNeeded() {
        super.loadViewIfNeeded()
        
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    
    func rootViewpush() ->Void {
        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewcontroller:UIViewController = Storyboard.instantiateViewController(withIdentifier: "ViewController")
        self.present(viewcontroller, animated: true, completion: nil)
        
    }
}


extension ViewController{
    func appendViewControllerList(){
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        settingViewController = storyBoard.instantiateViewController(withIdentifier: "SettingViewController") as! SettingViewController
        newPostViewController = storyBoard.instantiateViewController(withIdentifier: "NewPostViewController") as! NewPostViewController
        listingDiaryViewController = storyBoard.instantiateViewController(withIdentifier: "ListingDiaryViewController") as! ListingDiaryViewController
        // format ViewContoller 만들어서 넣어주긴 해야합니다.
        
        
        viewControllers = [listingDiaryViewController, newPostViewController, settingViewController]
    }

    
    // 버튼이 눌리면 기존 내용이 보이는 뷰컨트롤러 부분을 제거하고 새로운 Contents를 뿌려줄수 있도록 교체 한다.
    // tag 가 0일때 테이블 뷰로 한달을 표현하게 된다. -> contentsView
    // month, year 버튼이 눌렸을 경우에는... IBAction을 하나 더 추가해서 처리하는걸로..
    //MARK:- Cunstom Tab Bar Controller...
    @IBAction func didPushTabButton(_ sender: UIButton){
        let prevIndex = selectedIndex
        selectedIndex = sender.tag// 현재 선택된 버튼의 인덱스로 변경
        buttons[prevIndex].isSelected = false// 이전에 버튼의 상태 변경
        print("sender tag : \(sender.tag)")
        print("selectedIndex: \(selectedIndex)")
        print("prevIndex: \(prevIndex)")

        
        let prevVC = viewControllers[prevIndex]
        prevVC.willMove(toParentViewController: nil)// 뷰컨에 다른 뷰가 추가되거나 제거될때 한번 호출해줘야됨
        prevVC.view.removeFromSuperview()// 리스폰더 체인에서 제거
        prevVC.removeFromParentViewController()//부모로부터 해당 뷰컨을 제거
        
        sender.isSelected = true// 눌린애 상태 변경
        let currentVC = viewControllers[selectedIndex]
        addChildViewController(currentVC)// 현재 화면의 VC에 해당 VC를 자식으로 추가
        currentVC.view.frame = contentsView.bounds// 자식 VC view 크기 지정
        contentsView.addSubview(currentVC.view)// 현 화면 VC의 ContentsView에 addsubView
        currentVC.didMove(toParentViewController: self)//포함되는 VC가 변경되었을때 reload 해줌.
        
    }
    
    @IBAction func didPushYYMMButton(_ sender: UIButton){
        //month일 경우 달에 대한 컬렉션 뷰가 나와야됨
        //year의 경우 연에 대한 컬렉션 뷰가 나와야됨.
        // 위 두사항은 label에 들어가는 값을 바꾸는걸로 해결..
        // 위의 결과는 ViewController의 버튼의 Text가 변경되는걸로 해야됨.
        // 서버 요청은 ViewController의 버튼의 Text값을 통해 진행.
        
        let barContentsView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MonthCollectionViewController") as! MonthCollectionViewController
        
        addChildViewController(barContentsView)
        barContentsView.view.frame = barView.bounds
        barView.addSubview(barContentsView.view)
        barContentsView.didMove(toParentViewController: self)
        

    }
}






