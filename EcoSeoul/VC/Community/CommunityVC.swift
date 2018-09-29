//
//  CommunityVC.swift
//  EcoSeoul
//
//  Created by 조예은 on 2018. 9. 24..
//  Copyright © 2018년 GGOMMI. All rights reserved.
//

import UIKit

class CommunityVC: UIViewController,UITableViewDelegate, UITableViewDataSource, APIService, MyCellDelegate {

    @IBOutlet weak var tableview: UITableView!
    var communityData : Community?
    var lists : [List]?
    
    let params: [String : Any] = [
        "user_idx" : UserDefaults.standard.integer(forKey: "userIdx"),
        "board_idx" : UserDefaults.standard.integer(forKey: "checkLike")
    ]
    
    //var checkLike : Int?
    
    var backBtn: UIBarButtonItem = {
        let btn = UIBarButtonItem()
        btn.image = #imageLiteral(resourceName: "arrow-left-black")
        btn.tintColor = UIColor.black
        btn.width = -40
        btn.action = #selector(popSelf)
        return btn
    }()
    
    var writeBtn: UIBarButtonItem = {
        let btn = UIBarButtonItem()
        btn.image = #imageLiteral(resourceName: "ic-write")
        btn.tintColor = .black
        btn.action = #selector(WriteVC)
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableview.delegate = self;
        self.tableview.dataSource = self;
        self.tableview.tableFooterView = UIView(frame: .zero)
        
        setNaviBar()
        CommunityInit(url: url("/board/list"))
    
    }


    func CommunityInit(url : String){
        
        CommunityService.shareInstance.getCommunityData(url: url, completion: { [weak self] (result) in
            guard let `self` = self else { return }
            
            switch result {
            case .networkSuccess(let data):
                self.communityData = data
                self.tableview.reloadData()
                break
                
            case .networkFail :
                self.simpleAlert(title: "network", message: "네트워크 환경을 확인해주세요 :)")
            default :
                break
            }
            
        })
        
    }
    
    
    
    //**********여기서 오류가 발생***********
    func likeBtnTapped(at index: IndexPath) {
        
        print("buttont tap이 일어났다!! :\(index.row)")
    
        LikeService.shareInstance.checkLike(URL: url("/board/like"), params: params) { [weak self] (result) in
            guard self != nil else { return }
            switch result {
            case .networkSuccess:
                break
            default :
                break
            }
            
        }
    
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rowNumber = 0
        if let comDat = communityData {
            if let best = comDat.bestList, let all = comDat.allList{
                rowNumber = best.count + all.count
            }
        }
        return rowNumber
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableview.dequeueReusableCell(withIdentifier: "CommunityTVCell") as!  CommunityTVCell
        
        cell.delegate = self;
        cell.indexPath = indexPath
        
        let row = indexPath.row
        
        switch row {
            case 0:
                cell.bestIMG.image = #imageLiteral(resourceName: "community-gold")
            case 1:
                cell.bestIMG.image = #imageLiteral(resourceName: "community-silver")
            case 2:
                cell.bestIMG.image = #imageLiteral(resourceName: "community-bronze")
            default:
                cell.bestIMG.image = nil
        }
        
        if let communityData_ = communityData {
            
            //0번째 인덱스에 bestList들만 들어 있음, allList: nil
            if let bestlist = communityData_.bestList{
                
                if indexPath.row < 3{
                    cell.configure(list: bestlist[indexPath.row])

                    // 좋아요 누를때 해당 cell의 board index 넘기기
                    if let board : List = bestlist[indexPath.row]{
                        UserDefaults.standard.set(board.boardIdx, forKey: "checkLike")
                        print("checkLike = \(board.boardIdx)")
                    }

                }
            }
            
            //반대로 1번째 인덱스엔 allList들만 들어있음, bestList: nil
            if let alllist = communityData_.allList{
                if indexPath.row >= 3{
                    cell.configure(list: alllist[indexPath.row-3])
                    
                    // 좋아요 누를때 해당 cell의 board index 넘기기
                    if let board : List = alllist[indexPath.row-3]{
                        UserDefaults.standard.set(board.boardIdx, forKey: "checkLike")
                    }
                }
            }
        }

         return cell
    }
    

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let communityVC = UIStoryboard(name: "Community", bundle: nil).instantiateViewController(withIdentifier: "CommunityViewVC")as! CommunityViewVC
        
        //셀 클릭이후 남아있는 gray color 없애기
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let data = communityData {
            if let list = data.bestList{
                if indexPath.row < 3 {
                    let board: List = list[indexPath.row]
                    communityVC.selectedBoardIdx = board
                    UserDefaults.standard.set(board.boardIdx, forKey: "checkLike")
                }
            }
            if let list = data.allList{
                if indexPath.row >= 3{
                    let board: List  = list[indexPath.row-3]
                    communityVC.selectedBoardIdx = board
                    UserDefaults.standard.set(board.boardIdx, forKey: "checkLike")
                }
            }
        }
        self.navigationController?.pushViewController(communityVC, animated: true)

    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}

//////////Navi
extension CommunityVC{
    
    @objc func popSelf() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func WriteVC(){
        let writeVC = UIStoryboard(name: "Community", bundle: nil).instantiateViewController(withIdentifier: "CommunityWriteVC") as! CommunityWriteVC
        self.navigationController?.pushViewController(writeVC, animated: true)
    }
    
    
    func setNaviBar(){
        backBtn.target = self
        writeBtn.target = self
        let bar: UINavigationBar! =  self.navigationController?.navigationBar
        let item: UINavigationItem = self.navigationItem
        
        item.leftBarButtonItem = backBtn
        item.leftBarButtonItem?.imageInsets.left = -15
        item.rightBarButtonItem = writeBtn
        item.rightBarButtonItem?.imageInsets.right = -15
        item.title = "커뮤니티"
        
        bar.backgroundColor = .white
        bar.shadowImage = UIImage()
    }
    
    //상태 표시줄 흰색 만들기
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
