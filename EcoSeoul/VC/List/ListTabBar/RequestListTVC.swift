//
//  RequestListTVC.swift
//  EcoSeoul
//
//  Created by 조예은 on 2018. 9. 21..
//  Copyright © 2018년 GGOMMI. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class RequestListTVC: UITableViewController, APIService {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 테이블 뷰에 내용이 나오지 않는 하단 부분의 선을 없애줍니다.
        tableView.tableFooterView = UIView(frame: .zero)
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RequestListTVCell", for: indexPath)
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

extension RequestListTVC: IndicatorInfoProvider{
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo.init(title: "신청 내역")
    }
}
