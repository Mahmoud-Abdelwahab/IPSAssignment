//
//  LessonDetailsViewController.swift
//  IPSAssignment
//
//  Created by Mahmoud Abdulwahab on 22/03/2023.
//

import UIKit
import Kingfisher

class LessonDetailsViewController: UIViewController {

    // MARK: Properties
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var videoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.kf.setImage(with: URL(string: "https://ipsmedia.notion.site/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2Fb9fd02c6-f567-4e17-8bb0-27e1b07f33a6%2FiOS-design.png?id=5743fac0-7002-409a-8364-eede144c4a9a&table=block&spaceId=18c2b86f-5f00-4ff1-baf7-6be563e77c7d&width=2000&userId=&cache=v2")!)
        return imageView
    }()
    
    private lazy var playButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .white.withAlphaComponent(0.8)
        button.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 48), forImageIn: .normal)
        button.addTarget(self, action: #selector(openVideoPlayerView), for: .touchUpInside)
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "This is just title for testing"
        label.font = UIFont.boldSystemFont(ofSize: 23)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text =  "This is just description for testing purpose only so you have to remove it after finish testingThis is just description for testing purpose only so you have to remove it after finish testingThis is just description for testing purpose only so you have to remove it after finish testingThis is just description for testing purpose only so you have to remove it after finish testingThis is just description for testing purpose only so you have to remove it after finish testingThis is just description for testing purpose only so you have to remove it after finish testingThis is just description for testing purpose only so you have to remove it after finish testingThis is just description for testing purpose only so you have to remove it after finish testingThis is just description for testing purpose only so you have to remove it after finish testingThis is just description for testing purpose only so you have to remove it after finish testingThis is just description for testing purpose only so you have to remove it after finish testingThis is just description for testing purpose only so you have to remove it after finish testingThis is just description for testing purpose only so you have to remove it after finish testingThis is just description for testing purpose only so you have to remove it after finish testingThis is just description for testing purpose only so you have to remove it after finish testingThis is just description for testing purpose only so you have to remove it after finish testingThis is just description for testing purpose only so you have to remove it after finish testingThis is just description for testing purpose only so you have to remove it after finish testingThis is just description for testing purpose only so you have to remove it after finish testingThis is just description for testing purpose only so you have to remove it after finish testingThis is just description for testing purpose only so you have to remove it after finish testing "
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("Next lesson", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        var configuration = UIButton.Configuration.plain()
        configuration.title = "Next lesson"
        configuration.image = UIImage(systemName: "chevron.right")
        configuration.imagePadding = 4
        configuration.imagePlacement = .trailing
        button.configuration = configuration
        button.addTarget(self, action: #selector(nextLessonButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var nextButtonContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView   = UIStackView()
        stackView.axis  = .vertical
        stackView.distribution  = .fill
        stackView.alignment = .fill
        stackView.spacing   = 16.0
        return stackView
    }()
    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewsConstraints()
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - Actions

private extension LessonDetailsViewController {
    @objc private func openVideoPlayerView() {
        // TODO: - Open video player view
        print("Open video")
    }
    
    @objc private func nextLessonButtonTapped() {
        print("Next Tapped")
    }
}


// MARK: - Private Handlers

private extension LessonDetailsViewController {
    
    private func setupViewsConstraints() {
        addSubviews()
        setupScrollViewConstraint()
        setupContainerViewConstraint()
        setupMainStackViewConstraint()
        setupMainVideoImageViewConstraint()
        setupNextButtonConstraint()
        setupPlayVideoButtonConstraint()
    }
    
    private func addSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        containerView.addSubviews(videoImageView, playButton, stackView)
        nextButtonContainerView.addSubview(nextButton)
    }
    
    private func setupScrollViewConstraint() {
        scrollView.pinToTheEdges(of: view)
    }
    
    private func setupContainerViewConstraint() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.pinToTheEdges(of: scrollView)
        containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
    }
    
    private func setupMainStackViewConstraint() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(descriptionLabel)
        stackView.addArrangedSubview(nextButtonContainerView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: videoImageView.bottomAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0),
        ])
    }
    
    private func setupMainVideoImageViewConstraint() {
        videoImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            videoImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0),
            videoImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 0),
            videoImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0),
            videoImageView.heightAnchor.constraint(equalToConstant: 230.0)
        ])
    }
    
    private func setupNextButtonConstraint() {
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButtonContainerView.translatesAutoresizingMaskIntoConstraints = false
        nextButtonContainerView.heightAnchor.constraint(equalToConstant: 70.0).isActive = true
        nextButton.trailingAnchor.constraint(equalTo: nextButtonContainerView.trailingAnchor, constant: 0).isActive = true
    }
    
    private func setupPlayVideoButtonConstraint() {
        playButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            playButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0),
            playButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 0),
            playButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0),
            playButton.heightAnchor.constraint(equalToConstant: 230.0)
        ])
    }
}
