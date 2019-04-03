//
//  ParallaxScrollView.swift
//  JabraMoments
//
//  Created by Felix Hedlund on 2018-10-24.
//  Copyright © 2018 Jayway AB. All rights reserved.
//

import UIKit

protocol ContentViewFrameChangedDelegate {
    func didUpdateContentViewFrame(newFrame: CGRect)
}

protocol ParallaxScrollViewType: class {
    var backgroundColor: UIColor? { get set }
    var topHeaderHeightRatio: CGFloat { get set }
}

/// Parallax headers must implement this protocol and provide the view to be added in the header content view.
protocol ParallaxHeaderViewType: class {
    func configureWithInitialHeightReference(heightReferenceView: UIView)
    var view: UIView { get }
}

extension ParallaxHeaderViewType {
    /// Optional method to implement if the Parallax header needs a reference to the initial height reference view.
    func configureWithInitialHeightReference(heightReferenceView: UIView) { }
}

protocol ParallaxContentViewType: class {
    var view: UIView { get }
    func configureWithExpandableView(expandableView: UIView)
}

/**
The ParallaxScrollView achieves a parallax scrolling effect through a setup of layoutConstraints.
*/
class ParallaxScrollView: UIScrollView, ParallaxScrollViewType {
    /// View vs header initial height ratio before scrolling. Defaults to normal header height, see Metric.
    var topHeaderHeightRatio: CGFloat = 0.25

    private lazy var scrollContentView = UIView()

    private lazy var headerContentView = UIView()

    private lazy var topHeaderTopExpandableView: UIView = {
        let view = UIView()
        view.backgroundColor = FeatureFlags.showFirstExpandableView ?  UIColor.white.withAlphaComponent(0.8) : UIColor.clear
        return view
    }()
    private lazy var topHeaderInitialSizeRefView = UIView()
    private lazy var topHeaderBottomExpandableView: UIView = {
        let view = UIView()
        view.backgroundColor = FeatureFlags.showHeaderExpandableViews ?  UIColor.blue.withAlphaComponent(0.5) : UIColor.clear
        return view
    }()

    private lazy var topHeaderHiddenParallaxContainerView = UIView()
    private lazy var topHeaderHiddenParallaxView = UIView()

    private lazy var contentView: UIView = {
        let view = ContentView()
        view.delegate = self
        return view
    }()

    /**
     A hidden view at the bottom of the scroll view used to stretch the scrollable content to encapsulate all of the content while keeping the parallax effect.
    */
    private lazy var stretchScrollableContentView = UIView()
    private var stretchScrollableContentViewTopConstraint: NSLayoutConstraint?

    /**
    A view stretching from the bottom of the scrollview up to the header, behind the scrollable content. This view enables a regular background color in the right place even though content is scrolled.
    */
    private lazy var bottomBackground: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        return view
    }()

    override var backgroundColor: UIColor? {
        didSet {
//            bottomBackground.backgroundColor = backgroundColor
            headerContentView.backgroundColor = backgroundColor
        }
    }

    private let header: ParallaxHeaderViewType
    private let mainView: ParallaxContentViewType
    private let controller: UIViewController

    /**
     Call the init function and add a header view, main content view and a controller. The controller is needed for fetching the top and bottom layout guide.
     */
    init(header: ParallaxHeaderViewType, mainView: ParallaxContentViewType, controller: UIViewController) {
        self.header = header
        self.mainView = mainView
        self.controller = controller
        super.init(frame: .zero)

        loadView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMoveToSuperview() {
        guard let _ = superview else { return }
        //Only layout this view if it has been added to a superview.
        setupLayout()
    }

    private func loadView() {
        self.alwaysBounceVertical = true

        addSubview(scrollContentView)
        scrollContentView.addSubview(headerContentView)
        scrollContentView.addSubview(topHeaderHiddenParallaxView)
        scrollContentView.addSubview(topHeaderHiddenParallaxContainerView)
        scrollContentView.addSubview(topHeaderTopExpandableView)
        scrollContentView.addSubview(topHeaderInitialSizeRefView)
        scrollContentView.addSubview(topHeaderBottomExpandableView)
        scrollContentView.addSubview(bottomBackground)
        scrollContentView.addSubview(contentView)
        scrollContentView.addSubview(stretchScrollableContentView)

        headerContentView.addSubview(header.view)
        contentView.addSubview(mainView.view)
    }

    private func setupLayout() {
        headerContentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerContentView.topAnchor.constraint(equalTo: topHeaderTopExpandableView.topAnchor),
            headerContentView.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor),
            headerContentView.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor),
            headerContentView.bottomAnchor.constraint(equalTo: topHeaderBottomExpandableView.bottomAnchor)
            ])

        scrollContentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollContentView.topAnchor.constraint(equalTo: self.topAnchor),
            scrollContentView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            scrollContentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            scrollContentView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            scrollContentView.widthAnchor.constraint(equalTo: self.widthAnchor),
            ])

        topHeaderTopExpandableView.translatesAutoresizingMaskIntoConstraints = false
        let hiddenTopGrowViewTopConstraint = topHeaderTopExpandableView.topAnchor.constraint(equalTo: controller.view.safeAreaLayoutGuide.topAnchor)
        hiddenTopGrowViewTopConstraint.priority = .defaultHigh
        NSLayoutConstraint.activate([
            topHeaderTopExpandableView.centerXAnchor.constraint(equalTo: scrollContentView.centerXAnchor),
            topHeaderTopExpandableView.widthAnchor.constraint(equalTo: scrollContentView.widthAnchor),
            topHeaderTopExpandableView.bottomAnchor.constraint(equalTo: scrollContentView.topAnchor),
            topHeaderTopExpandableView.heightAnchor.constraint(greaterThanOrEqualToConstant: 0),
            hiddenTopGrowViewTopConstraint,
            topHeaderTopExpandableView.topAnchor.constraint(lessThanOrEqualTo: controller.view.safeAreaLayoutGuide.topAnchor),
            ])

        topHeaderHiddenParallaxContainerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topHeaderHiddenParallaxContainerView.centerXAnchor.constraint(equalTo: scrollContentView.centerXAnchor),
            topHeaderHiddenParallaxContainerView.widthAnchor.constraint(equalTo: scrollContentView.widthAnchor),
            topHeaderHiddenParallaxContainerView.topAnchor.constraint(equalTo: topHeaderTopExpandableView.topAnchor),
            topHeaderHiddenParallaxContainerView.bottomAnchor.constraint(equalTo: controller.view.safeAreaLayoutGuide.topAnchor)
            ])

        topHeaderHiddenParallaxView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topHeaderHiddenParallaxView.centerXAnchor.constraint(equalTo: scrollContentView.centerXAnchor),
            topHeaderHiddenParallaxView.widthAnchor.constraint(equalTo: scrollContentView.widthAnchor),
            topHeaderHiddenParallaxView.bottomAnchor.constraint(equalTo: topHeaderHiddenParallaxContainerView.bottomAnchor),
            topHeaderHiddenParallaxView.heightAnchor.constraint(equalTo: topHeaderHiddenParallaxContainerView.heightAnchor, multiplier: 0.2)
            ])

        topHeaderInitialSizeRefView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topHeaderInitialSizeRefView.topAnchor.constraint(equalTo: topHeaderTopExpandableView.bottomAnchor),
            topHeaderInitialSizeRefView.centerXAnchor.constraint(equalTo: scrollContentView.centerXAnchor),
            topHeaderInitialSizeRefView.widthAnchor.constraint(equalTo: scrollContentView.widthAnchor),
            topHeaderInitialSizeRefView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: self.topHeaderHeightRatio),
            ])

        topHeaderBottomExpandableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topHeaderBottomExpandableView.topAnchor.constraint(equalTo: topHeaderInitialSizeRefView.bottomAnchor),
            topHeaderBottomExpandableView.centerXAnchor.constraint(equalTo: scrollContentView.centerXAnchor),
            topHeaderBottomExpandableView.widthAnchor.constraint(equalTo: scrollContentView.widthAnchor),
            topHeaderBottomExpandableView.heightAnchor.constraint(equalTo: topHeaderTopExpandableView.heightAnchor)
            ])

        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topHeaderBottomExpandableView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor),
            ])

        stretchScrollableContentView.translatesAutoresizingMaskIntoConstraints = false
        let stretchContentViewTopConstraint = stretchScrollableContentView.topAnchor.constraint(equalTo: scrollContentView.topAnchor)
        self.stretchScrollableContentViewTopConstraint = stretchContentViewTopConstraint
        NSLayoutConstraint.activate([
            stretchContentViewTopConstraint,
            stretchScrollableContentView.centerXAnchor.constraint(equalTo: scrollContentView.centerXAnchor),
            stretchScrollableContentView.widthAnchor.constraint(equalTo: stretchScrollableContentView.heightAnchor),
            stretchScrollableContentView.heightAnchor.constraint(equalToConstant: 0),
            stretchScrollableContentView.bottomAnchor.constraint(equalTo: scrollContentView.bottomAnchor),
            ])

        bottomBackground.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bottomBackground.topAnchor.constraint(equalTo: topHeaderBottomExpandableView.bottomAnchor),
            bottomBackground.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor),
            bottomBackground.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor),
            bottomBackground.bottomAnchor.constraint(greaterThanOrEqualTo: controller.view.bottomAnchor)
            ])

        let headerView = header.view
        headerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: topHeaderHiddenParallaxView.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: headerContentView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: headerContentView.trailingAnchor),
            headerView.heightAnchor.constraint(equalTo: headerContentView.heightAnchor)
            ])
        header.configureWithInitialHeightReference(heightReferenceView: self.topHeaderInitialSizeRefView)
        mainView.configureWithExpandableView(expandableView: self.topHeaderTopExpandableView)

        let main = mainView.view
        main.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            main.topAnchor.constraint(equalTo: contentView.topAnchor),
            main.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            main.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            main.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            ])
    }

    /**
     A custom UIView class for the content view is nessesary for the parallax functionality.
     We need to know about updates in the content view frame in order to stretch the scrollView to fit the whole content (while keeping the parallax functionality)
     */
    private class ContentView: UIView {
        var delegate: ContentViewFrameChangedDelegate?

        var oldFrame: CGRect?

        override func didMoveToWindow() {
            super.didMoveToWindow()
            delegate?.didUpdateContentViewFrame(newFrame: self.frame)
        }
    }

}

extension ParallaxScrollView: ContentViewFrameChangedDelegate {
    func didUpdateContentViewFrame(newFrame: CGRect) {
        self.stretchScrollableContentViewTopConstraint?.constant = newFrame.maxY
    }
}
