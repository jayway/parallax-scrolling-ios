//
//  MainView.swift
//  ParallaxScrollView
//
//  Created by Felix Hedlund on 2018-11-08.
//  Copyright © 2018 Jayway AB. All rights reserved.
//

import UIKit

class MainView: UIView, ParallaxContentViewType {
    var view: UIView {
        get {
            return self
        }
    }

    let padding: CGFloat = 24

    private lazy var topExpandableView: UIView = {
        let view = UIView()
        view.backgroundColor = FeatureFlags.showMainContentVerticalExpandableViews ?  UIColor.green.withAlphaComponent(0.5) : UIColor.clear
        return view
    }()

    private lazy var firstApple: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "apple")
        view.contentMode = .scaleAspectFit
        view.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return view
    }()

    private lazy var middleExpandableView: UIView = {
        let view = UIView()
        view.backgroundColor = FeatureFlags.showMainContentVerticalExpandableViews ?  UIColor.green.withAlphaComponent(0.5) : UIColor.clear
        return view
    }()

    private lazy var secondApple: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "apple")
        view.contentMode = .scaleAspectFit
        view.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return view
    }()

    private lazy var leftExpandableView: UIView = {
        let view = UIView()
        view.backgroundColor = FeatureFlags.showMainContentHorizontalExpandableViews ?  UIColor.red.withAlphaComponent(0.5) : UIColor.clear
        return view
    }()
    private lazy var rightExpandableView: UIView = {
        let view = UIView()
        view.backgroundColor = FeatureFlags.showMainContentHorizontalExpandableViews ?  UIColor.red.withAlphaComponent(0.5) : UIColor.clear
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadView()
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadView()
        setupLayout()
    }

    private func loadView() {
        addSubview(topExpandableView)
        addSubview(leftExpandableView)
        addSubview(firstApple)
        addSubview(rightExpandableView)
        addSubview(middleExpandableView)
        addSubview(secondApple)
    }

    private func setupLayout() {
        let appleHeight: CGFloat = 100
        topExpandableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topExpandableView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            topExpandableView.widthAnchor.constraint(equalTo: self.widthAnchor),
            topExpandableView.topAnchor.constraint(equalTo: self.topAnchor),
            ])

        leftExpandableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leftExpandableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            leftExpandableView.heightAnchor.constraint(equalTo: firstApple.heightAnchor),
            leftExpandableView.centerYAnchor.constraint(equalTo: firstApple.centerYAnchor),
            ])

        firstApple.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            firstApple.leadingAnchor.constraint(equalTo: leftExpandableView.trailingAnchor),
            firstApple.topAnchor.constraint(equalTo: topExpandableView.bottomAnchor, constant: padding * 2),
            firstApple.heightAnchor.constraint(equalToConstant: appleHeight),
            firstApple.widthAnchor.constraint(equalTo: self.widthAnchor),
            ])

        middleExpandableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            middleExpandableView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            middleExpandableView.widthAnchor.constraint(equalTo: self.widthAnchor),
            middleExpandableView.topAnchor.constraint(equalTo: firstApple.bottomAnchor)
            ])

        rightExpandableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            rightExpandableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            rightExpandableView.heightAnchor.constraint(equalTo: secondApple.heightAnchor),
            rightExpandableView.centerYAnchor.constraint(equalTo: secondApple.centerYAnchor),
            ])

        secondApple.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            secondApple.trailingAnchor.constraint(equalTo: rightExpandableView.leadingAnchor),
            secondApple.topAnchor.constraint(equalTo: middleExpandableView.bottomAnchor, constant: padding),
            secondApple.heightAnchor.constraint(equalToConstant: appleHeight),
            secondApple.widthAnchor.constraint(equalTo: self.widthAnchor),
            secondApple.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ])
    }

    func configureWithExpandableView(expandableView: UIView) {
        topExpandableView.heightAnchor.constraint(equalTo: expandableView.heightAnchor, multiplier: 1).isActive = true
        middleExpandableView.heightAnchor.constraint(equalTo: expandableView.heightAnchor, multiplier: 2).isActive = true
        leftExpandableView.widthAnchor.constraint(equalTo: expandableView.heightAnchor, multiplier: 1).isActive = true
        rightExpandableView.widthAnchor.constraint(equalTo: expandableView.heightAnchor, multiplier: 1).isActive = true
    }
}
