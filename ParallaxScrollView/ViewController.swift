//
//  ViewController.swift
//  ParallaxScrollView
//
//  Created by Felix Hedlund on 2018-11-06.
//  Copyright © 2018 Jayway AB. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private lazy var header: Header = {
        let view = Header()
        view.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return view
    }()

    private lazy var parallaxView: ParallaxScrollView = {
        let view = ParallaxScrollView(header: header, mainView: MainView(), controller: self)
        view.backgroundColor = UIColor.white
        return view
    }()

    override func loadView() {
        super.loadView()
        view.addSubview(parallaxView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        title = "Parallax ScrollView"
        setupLayout()
    }

    private func setupLayout() {
        parallaxView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            parallaxView.topAnchor.constraint(equalTo: view.topAnchor),
            parallaxView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            parallaxView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            parallaxView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

}

