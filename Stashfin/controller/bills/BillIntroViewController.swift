//
//  BillIntroViewController.swift
//  Stashfin
//
//  Created by Macbook on 04/07/19.
//  Copyright © 2019 Stashfin. All rights reserved.
//

import UIKit

class BillIntroViewController:  BaseLoginViewController,UIScrollViewDelegate {
    
    static func getInstance(storyboard: UIStoryboard) -> BillIntroViewController{
        return storyboard.instantiateViewController(withIdentifier: String(describing: self.classForCoder())) as! BillIntroViewController
    }
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControll: UIPageControl!
    
    var slides:[UIView]=[];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate=self
        slides = createSlides()
        setupSlideScrollView(slides:slides)
        
        pageControll.numberOfPages=slides.count
        pageControll.currentPage=0
        view.bringSubviewToFront(pageControll)
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func submitBtn(_ sender: UIButton) {
        
        if pageControll.currentPage < slides.count-1{
            
            let width: CGFloat = scrollView.frame.size.width
            let newPosition: CGFloat = scrollView.contentOffset.x + width
            scrollView.setContentOffset(CGPoint(x: newPosition, y: 0), animated: true)
            
        }else{
            self.openLoadMyCardPage()
//            self.changeViewController(controllerName: Constants.Controllers.BILL_LOAD_MY_CARD)
        }
    }
    
    private func setupSlideScrollView(slides:[UIView]){
        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(slides.count), height: 0)
        
        scrollView.isPagingEnabled = true
        
        for i in 0 ..< slides.count {
            slides[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height)
            scrollView.addSubview(slides[i])
        }
    }
    
    
    
    private func createSlides()->[UIView]{
        
        let slide1:BillIntroView=Bundle.main.loadNibNamed("BillIntroView", owner: self, options: nil)?.first as! BillIntroView
        slide1.imgViewIntro.image = #imageLiteral(resourceName: "bill_date_one")
        slide1.imgViewIntro.layer.cornerRadius=10
        slide1.titleIntro.text="Use your funds at 0% Interest"
        slide1.descIntro.text="Load your card, repay before/on your Bill Date at 0% interest.\n\nThe Free Credit Period is only applicable till your Bill Date"
        
        let slide2:BillIntroView=Bundle.main.loadNibNamed("BillIntroView", owner: self, options: nil)?.first as! BillIntroView
        slide2.imgViewIntro.image = #imageLiteral(resourceName: "bill_date_two")
        slide2.imgViewIntro.layer.cornerRadius=10
        slide2.titleIntro.text="Simple & Easy Repayment"
        slide2.descIntro.text="Don't worry, we will convert the amount into easy installments of your choice if you are unable to pay by your Bill Date.\n\nHence you wil be required to choose your EMI details before you can load your card."
        
        return [slide1,slide2]
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        pageControll.currentPage = Int(pageIndex)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
                navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationController?.setNavigationBarHidden(false, animated: false)
        // Remove self from navigation hierarchy
        guard let viewControllers = navigationController?.viewControllers,
            let index = viewControllers.index(of: self) else { return }
        navigationController?.viewControllers.remove(at: index)
    }
    
}
