//
//  HomeVC.swift
//  EcoSeoul
//
//  Created by 이충신 on 2018. 9. 11..
//  Copyright © 2018년 GGOMMI. All rights reserved.

//HomeUpVC 와 HomeDownVC 를 관리하는 ScrollView(Vertical)
//downBtn을 이곳에서 추가(VC1에서 VC2로 내려가는 제어가 필요해서)
//Animation: downBtn(Hovering)

import UIKit

class HomeVC: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var verticalScroll: UIScrollView!
    
    var homeUpVC: HomeUpVC?
    var homeDownVC: HomeDownVC?
    
    var downBtn: UIButton = {
        let button = UIButton(frame: CGRect(x: 162, y: 512, width: 50 , height: 50))
        button.titleLabel?.font = UIFont(name: "NotoSansCJKkr-Regular", size: 25)
        button.setTitle("V", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.addTarget(self, action: #selector(downBtnTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        verticalScroll.delegate = self;
        
        setVC()
        self.view.subviews[0].addSubview(downBtn)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
         donwnBtnAnimate()
    }

    //다운버튼 클릭시 화면전환(Paging 효과로)
    @objc func downBtnTapped() {
        var contentOffset = verticalScroll.contentOffset
        contentOffset.y = self.view.bounds.height - 75
        verticalScroll.setContentOffset(contentOffset, animated: true)
    }
    
    //다운버튼의 AutoLayOut & Hovering(위아래움직임) 효과
    func donwnBtnAnimate(){
        let v1 = self.view.subviews[0]
        downBtn.translatesAutoresizingMaskIntoConstraints = false
        
       let buttonConstraint = downBtn.topAnchor.constraint(equalTo: v1.topAnchor, constant: 512)
        NSLayoutConstraint.activate([
            buttonConstraint,
            downBtn.leadingAnchor.constraint(equalTo: v1.leadingAnchor, constant: 162),
            downBtn.centerXAnchor.constraint(equalTo: v1.safeAreaLayoutGuide.centerXAnchor)
        ])
        
        UIView.animate(withDuration: 1, delay: 0, options: [.autoreverse, .repeat, .allowUserInteraction], animations: {
                buttonConstraint.constant += 10
                self.view.layoutIfNeeded()
                }, completion:nil)

    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.y / scrollView.frame.size.height)
        print("현재 Vertical 인덱스 = \(Int(pageNumber))")
    }

}

//HomeVC의 HomeUpVC & HomeDownVC 통합
extension HomeVC {
    
    func setVC(){
        
        //HomeDown(테이블뷰 부분)을 다른 스토리보드로 분리하겠음
        let homeDownStoryboard = UIStoryboard.init(name: "HomeDown", bundle: nil)
        
        if let vc1 = storyboard?.instantiateViewController(withIdentifier: "HomeUpVC") as? HomeUpVC,
            let vc2 = homeDownStoryboard.instantiateViewController(withIdentifier: "HomeDownVC") as? HomeDownVC {
            
            guard let v1 = vc1.view, let v2 = vc2.view else { return }
            
            self.addChildViewController(vc1)
            self.addChildViewController(vc2)
            
            v1.translatesAutoresizingMaskIntoConstraints = false
            v2.translatesAutoresizingMaskIntoConstraints = false
            
            verticalScroll.addSubview(v1)
            verticalScroll.addSubview(v2)
            
            NSLayoutConstraint.activate([
                v1.topAnchor.constraint(equalTo: verticalScroll.topAnchor, constant: 0),
                v1.leadingAnchor.constraint(equalTo: verticalScroll.leadingAnchor, constant: 0),
                v1.trailingAnchor.constraint(equalTo: verticalScroll.trailingAnchor, constant: 0),
                v1.widthAnchor.constraint(equalTo: verticalScroll.widthAnchor, constant: 0),
                // constrain v1 height to height of scrollView MINUS 55 (the height of your barcode view in v2)
                v1.heightAnchor.constraint(equalTo: verticalScroll.heightAnchor, constant: -55),
                
                v2.topAnchor.constraint(equalTo: v1.bottomAnchor, constant: 0),
                v2.leadingAnchor.constraint(equalTo: verticalScroll.leadingAnchor, constant: 0),
                v2.trailingAnchor.constraint(equalTo: verticalScroll.trailingAnchor, constant: 0),
                v2.heightAnchor.constraint(equalTo: verticalScroll.heightAnchor, constant: 0),
                v2.widthAnchor.constraint(equalTo: verticalScroll.widthAnchor, constant: 0),
                v2.bottomAnchor.constraint(equalTo: verticalScroll.bottomAnchor, constant: 0),
                ])
            
            homeUpVC = vc1
            homeDownVC = vc2
        }
        
    }
}







