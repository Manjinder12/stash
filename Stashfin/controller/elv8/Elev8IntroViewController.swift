//
//  Elev8IntroViewController.swift
//  Stashfin
//
//  Created by Macbook on 25/05/19.
//  Copyright © 2019 Stashfin. All rights reserved.
//

import UIKit

class Elev8IntroViewController: BaseLoginViewController,UIScrollViewDelegate {
    
    static func getInstance(storyboard: UIStoryboard) -> Elev8IntroViewController{
        return storyboard.instantiateViewController(withIdentifier: String(describing: self.classForCoder())) as! Elev8IntroViewController
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
        
        updateIntroScreen()

        // Do any additional setup after loading the view.
    }
    
    private func updateIntroScreen(){
        
        let params=["mode":"elv8_save_intro_screen_status","is_completed":"1"]
        self.showProgress()
        ApiClient.getJSONResponses(route: APIRouter.v2Api(param: params)){
            result,code in
            self.hideProgress()
            switch code{
            case .success:
                Log("updated")
                
            case .errors(let error):
//                self.showToast(error)
                Log("failed: "+error)
            }
        }
    }
    
    @IBAction func nextButton(_ sender: UIButton) {
        if pageControll.currentPage < slides.count-1{
            
            let width: CGFloat = scrollView.frame.size.width
            let newPosition: CGFloat = scrollView.contentOffset.x + width
            scrollView.setContentOffset(CGPoint(x: newPosition, y: 0), animated: true)
            
        }else{
        changeViewController(controllerName: Constants.Controllers.EL_APPLY)
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
        let slide1:Elv8IntroView=Bundle.main.loadNibNamed("Elv8IntroView", owner: self, options: nil)?.first as! Elv8IntroView
        slide1.imageView.image = #imageLiteral(resourceName: "intro_1")
        slide1.imageView.layer.cornerRadius=10
        slide1.introTitle.text="Welcome to StashFin Elev8!"
        let slide2:Elv8IntroView=Bundle.main.loadNibNamed("Elv8IntroView", owner: self, options: nil)?.first as! Elv8IntroView
             slide2.imageView.image = #imageLiteral(resourceName: "intro_2")
        slide2.imageView.layer.cornerRadius=10
        slide2.introTitle.text="You are now eligible for a loan upto Rs. 10,000"
        slide2.introDesc.text="Complete the simple 4 steps process and get he money in your account today."
        let slide3:Elv8IntroView=Bundle.main.loadNibNamed("Elv8IntroView", owner: self, options: nil)?.first as! Elv8IntroView
             slide3.imageView.image = #imageLiteral(resourceName: "intro_3")
        slide3.imageView.layer.cornerRadius=10
        slide3.introTitle.text="Climb the StashFin ladder"
        slide3.introDesc.text="Depending on your profile, you will be placed at a specific level of the elv8 ladder. Climb up the ladder and become eligible for higher amounts very time you repay your loan on time."
        let slide4:Elv8IntroView=Bundle.main.loadNibNamed("Elv8IntroView", owner: self, options: nil)?.first as! Elv8IntroView
             slide4.imageView.image = #imageLiteral(resourceName: "intro_4")
        slide4.imageView.layer.cornerRadius=10
        slide4.introTitle.text="Become eligible for StashFin Credit Line Card"
        slide4.introDesc.text="Once you've climbed the StashFin Elv8 ladder, you will elev8 yourself to become eligible for StashFin's premium Credit Line Cardwith limit upto Rs. 3 lacs."
        
        let slide5:Elv8Intro5View=Bundle.main.loadNibNamed("Elv8Intro5View", owner: self, options: nil)?.first as! Elv8Intro5View
//        slide5.imageView.image = #imageLiteral(resourceName: "intro_5")
//        slide5.imageView.layer.cornerRadius=10
//        slide5.introTitle.text="Climb the StashFin ladder"
//        slide5.introDesc.text="nce you've climbed the StashFin Elv8 ladder, you will elev8 yourself to become eligible for StashFin's premium Credit Line Ca"
        
        
        return [slide1,slide2,slide3,slide4,slide5]
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        pageControll.currentPage = Int(pageIndex)
    }
    
}
