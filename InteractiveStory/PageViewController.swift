//
//  PageViewController.swift
//  InteractiveStory
//
//  Created by toby tang on 2017-11-15.
//  Copyright © 2017 Toby Tang. All rights reserved.
//

import UIKit

extension NSAttributedString {
    var stringRange: NSRange {
        return NSMakeRange(0, self.length)
    }
}

extension Story {
    var attributedText: NSAttributedString {
        let attributeString = NSMutableAttributedString(string: text)
        
        let paragraphStyle = NSMutableParagraphStyle()
        
        paragraphStyle.lineSpacing = 10
        
        attributeString.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: attributeString.stringRange)
        
        return attributeString
    }
    
}

extension Page {
    func story(atrributed: Bool) -> NSAttributedString {
        if atrributed {
            return story.attributedText
        } else {
            return NSAttributedString(string: story.text)
        }
    }
}

class PageViewController: UIViewController {
    
    var page: Page?
    let soundEffectsPlayer = soundEffectPlayer()
    
    //Mark: - User interface properties
    
    lazy var artworkView:UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = self.page?.story.artwork
        return imageView
    }()
    
    lazy var storyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = self.page?.story.text
        return label
    }()
    

    
    lazy var firstChoiceButton:UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let title = self.page?.firstChoice?.title ?? "Play again"
        let selector = self.page?.firstChoice != nil ? #selector(PageViewController.loadFirstChoice) : #selector(PageViewController.playAgain)
        
        button.setTitle(title, for: .normal)
        button.addTarget(self, action: selector, for: .touchUpInside)
        
        return button
    }()
    
    lazy var secondChoiceButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setTitle(self.page?.secondChoice?.title, for: .normal)
        button.addTarget(self, action: #selector(PageViewController.loadSecondChoice), for: .touchUpInside)
        return button
    }()
    
    //var aProperty: Int  = { return 1 }() //closure
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    
    init(page: Page){
        self.page = page
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        if let page = page {
            
            
            
            
            storyLabel.attributedText = page.story(atrributed: true)
           // storyLabel.attributedText = attributeString
            
            
            
           /* if let firstChoice = page.firstChoice {
                firstChoiceButton.setTitle(firstChoice.title, for: .normal)
                firstChoiceButton.addTarget(self, action: #selector(PageViewController.loadFirstChoice), for: .touchUpInside)
            } else {
                firstChoiceButton.setTitle("Play again", for: .normal)
                firstChoiceButton.addTarget(self, action: #selector(PageViewController.playAgain), for: .touchUpInside)
            }*/
            
            /*if let secondChoice = page.secondChoice {
                secondChoiceButton.setTitle(secondChoice.title, for: .normal)
                secondChoiceButton.addTarget(self, action: #selector(PageViewController.loadSecondChoice), for: .touchUpInside)
            }*/ //else{
               //secondChoiceButton.setTitle("Play again", for: .normal)
               // secondChoiceButton.addTarget(self, action: #selector(PageViewController.playAgain), for: .touchUpInside)
            //}
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        view.addSubview(artworkView)
        
        //artworkView.translatesAutoresizingMaskIntoConstraints = false
        
        artworkView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        
        NSLayoutConstraint.activate([
            artworkView.topAnchor.constraint(equalTo: view.topAnchor),
            artworkView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            artworkView.rightAnchor.constraint(equalTo: view.rightAnchor),
            artworkView.leftAnchor.constraint(equalTo: view.leftAnchor)])
        
        view.addSubview(storyLabel)
        //storyLabel.translatesAutoresizingMaskIntoConstraints = false
        //storyLabel.numberOfLines = 0
        
        NSLayoutConstraint.activate([
            storyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
            storyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0),
            storyLabel.topAnchor.constraint(equalTo: view.centerYAnchor, constant: -48.0)])
        
        view.addSubview(firstChoiceButton)
        //firstChoiceButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            firstChoiceButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            firstChoiceButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80.0)])
        
        view.addSubview(secondChoiceButton)
        //secondChoiceButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            secondChoiceButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            secondChoiceButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -32.0)])
        
       
    }
    
    @objc func loadFirstChoice(){
        if let page = page, let firstChoice = page.firstChoice{
            let nextPage = firstChoice.page
            let pageController = PageViewController(page: nextPage)
            
            soundEffectsPlayer.playSound(for: firstChoice.page.story)
            
            navigationController?.pushViewController(pageController, animated: true)
            
        }
    }
    
    @objc func loadSecondChoice(){
        if let page = page, let secondChoice = page.secondChoice{
            let nextPage = secondChoice.page
            let pageController = PageViewController(page: nextPage)
            
            soundEffectsPlayer.playSound(for: secondChoice.page.story)
            
            navigationController?.pushViewController(pageController, animated: true)
        }
    }
    
    @objc func playAgain(){
        navigationController?.popToRootViewController(animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
