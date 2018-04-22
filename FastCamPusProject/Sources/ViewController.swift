//
//  ViewController.swift
//  TradeDiary
//
//  Created by 주호박 on 2018. 4. 7..
//  Copyright © 2018년 주호박. All rights reserved.
//
import Firebase
import UIKit
import Alamofire

class ViewController: UIViewController {
    
    @IBOutlet weak var contentsView: UIView!
    @IBOutlet weak var barView:UIView!
    
    //MARK:- custom Tab bar 에 해당하는 IBOutlet Hook Up
    @IBOutlet var buttons: [UIButton]!
    
    @IBOutlet weak var monthButton: UIButton!{
        didSet{
            print("============ [  ssss ] ============")
            print("monthButton Text : \(String(describing: monthButton.titleLabel?.text))")
        }
    }
    
    @IBOutlet weak var yearButton: UIButton!{
        didSet{
            print("yearButton Text : \(String(describing: yearButton.titleLabel?.text))")
        }
    }
    
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
    var userTmp: User!
    
    var month: String = ""
//    {
//        didSet{
//            print("============ [month ] ============")
//            monthButton.titleLabel?.text = month
////            monthButton.setNeedsDisplay()
//
//        }
//    }
    
    var year: String = ""
//    {
//        didSet{
//            print("============ [ year] ============")
//            yearButton.titleLabel?.text = year
//
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("============ [ ViewController ] ============")
        let user = Auth.auth().currentUser

        if user == nil {
            print("User is signed in.")
//            print(user?.displayName! ?? "")
            print(user?.uid)
//            userTmp = user
//            AuthService.init().Login(uid: (user?.uid)!) { (result) in
//                print("============ [ load User data ] ============")
//                switch(result){
//                case .success(let value):
//                    print(value)
//                case .error(let error):
//                    print(error.localizedDescription)
//                case .loginerror(_):
//                    break
//                }
//            }
//            print("=============================== [친구 정보 가져오기] ===============================")
//            AuthService.init().AuthFriendList(uid: (user?.uid)!) { (result) in
//                switch result {
//                case .success(let vale):
//
//                    dump(vale)
//                case .error(let error):
//
//                    print(error.localizedDescription)
//                }
//            }
            print("=============================== [ 작성글 가저오기 ] ===============================")
//            AuthService.init().diaryList(uid: (user?.uid)!, year: 2018, month: 04) { (respone) in
//                switch respone {
//
//                case .success(let value):
//                    dump(value)
//                case .error(let error):
//                    print(error.localizedDescription)
//                }
//            }

        } else {
            print("No user is signed in.")
        }

        
        // 버튼 텍스트를 변경하고 ListingViewController에 넣을 포스트들을 get함.
        initializedListingView()

//        userTmp.uid, year: Int(year)!, month: Int(month)!
//        dump(userTmp.uid)
        dump(year)
        dump(month)
//        getMonthlyDiaryData()

    
        self.appendViewControllerList()
        // contentsView에 ListingViewController를 보여준다 -> 시작 화면
        let commonView = viewControllers[0]
        addChildViewController(commonView)// 현재 화면의 VC에 해당 VC를 자식으로 추가
        commonView.view.frame = contentsView.bounds// 자식 VC view 크기 지정
        contentsView.addSubview(commonView.view)// 현 화면 VC의 ContentsView에 addsubView
        commonView.didMove(toParentViewController: self)//포함되는 VC가 변경되었을때 reload 해줌.
        // 다시 이화면으로 올수 있도록 Dissmiss하는 기능을 각 뷰에 넣어야함.
        
        

    }
    override func loadViewIfNeeded() {
        super.loadViewIfNeeded()
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
}


extension ViewController{
    
//    //MARK:- 달, 연 값을 서버에 보내서 컨텐츠 뷰를 결정하는 함수로 만들고 싶었어..
//    func sendToServerYYMMData(month: String ,year: String){
//
//    }
//
//    //
//    func getMonthlyDiaryData(){
//        print("=============================== [ 작성글 가저오기 ] ===============================")
//        AuthService.init().diaryList(uid: userTmp.uid, year: Int(year)!, month: Int(month)!) { (respone) in
//            switch respone {
//            case .success(let value):
//                dump(value)
//            case .error(let error):
//                print(error.localizedDescription)
//            }
//        }
//    }
    

    //MARK:- 달 년 버튼 을 초기화 ( Date를 불러와서)
    // 위의 달, 년 데이터를 통해서 값을 전달한다 -> 컨텐츠 뷰에 어느 월의 데이터를 기준으로 뿌릴것인지를 결정한다.
    func initializedListingView() {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYYMMDD"
        let dateString = dateFormatter.string(from: date)
        let year, month: String
     
        year = String(dateString[..<dateString.index(dateString.startIndex, offsetBy: 4)])
        month = String(dateString[dateString.index(dateString.startIndex, offsetBy: 4)...dateString.index(dateString.endIndex, offsetBy: -4)])

        self.month = month
        self.year = year
//MARK:- 날짜 변경된 부분임 -> 이부분에서 호출하면 됨
        // 여기서 불러도 되고 아니면 View 호출시 불러도 됩니다.
        
    }
    

    // MARK:- 의미 없음. 이건 그냥 뷰디드로드에 넣기 싫어 만든 함수
    // 뷰컨트롤러들의 전환을 위해 뷰컨 배열을 만들어 주는겅미.
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
    
    
    //MARK:- Custom Tab Bar에 컬렉션 뷰를 올리는거임
    //
    @IBAction func didPushYYMMButton(_ sender: UIButton){
        
        
        
        //month일 경우 달에 대한 컬렉션 뷰가 나와야됨
        //year의 경우 연에 대한 컬렉션 뷰가 나와야됨.
        // 위 두사항은 label에 들어가는 값을 바꾸는걸로 해결..
        // 위의 결과는 ViewController의 버튼의 Text가 변경되는걸로 해야됨.
        // 서버 요청은 ViewController의 버튼의 Text값을 통해 진행.
        // tag == 0 month
        // tag == 3 year
        let barContentsView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MonthCollectionViewController") as! MonthCollectionViewController
        
        if sender.tag == 0{
            barContentsView.isViewControllerMonth = true
        }else{
            barContentsView.isViewControllerMonth = false
        }
        barContentsView.delegate = self
        
        addChildViewController(barContentsView)
        barContentsView.view.frame = barView.bounds
        barView.addSubview(barContentsView.view)
        barContentsView.didMove(toParentViewController: self)
    }
    

    
}


   

extension ViewController: SendDataDelegate{
    func sendData(data: String, isSelectBtn: Bool) {
        switch isSelectBtn {
        case true:// month
            monthButton.titleLabel?.text = data
        case false:// year
            yearButton.titleLabel?.text = data
        }
        
        
        
        // 버튼 텍스트가 바뀌니 여기서도sendToServerYYMMData를 불러와야됨.
    //MARK:- 날짜 변경된 부분임 -> 이부분에서 호출하면 됨
//        print("=============================== [ 작성글 가저오기 ] ===============================")
//        AuthService.init().diaryList(uid: (userData?.uid)!, year: 2018, month: 04) { (respone) in
//            switch respone {
//
//            case .success(let value):
//                dump(value)
//            case .error(let error):
//                print(error.localizedDescription)
//            }
//        }
//
//    }
//        sendToServerYYMMData(month: (monthButton.titleLabel?.text)!, year: (yearButton.titleLabel?.text)!)
    
    }}






