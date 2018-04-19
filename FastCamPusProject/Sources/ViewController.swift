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
    
    var viewControllers: [UIViewController] = []
    var selectedIndex: Int = 0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("============ [ ViewController ] ============")
        let user = Auth.auth().currentUser
        
        if user != nil {
            print("User is signed in.")
//            print(user?.displayName! ?? "")
            print(user?.uid)
            
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
        self.buttons[self.selectedIndex].isSelected = true
        self.didPushTabButton(self.buttons[self.selectedIndex])

        

        
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
        
        viewControllers = [listingDiaryViewController, newPostViewController, settingViewController]
    }
    
    // 버튼이 눌리면 기존 내용이 보이는 뷰컨트롤러 부분을 제거하고 새로운 Contents를 뿌려줄수 있도록 교체 한다.
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
}






