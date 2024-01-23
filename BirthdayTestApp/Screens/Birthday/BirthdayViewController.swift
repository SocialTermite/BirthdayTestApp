//
//  BirthdayViewController.swift
//  BirthdayTestApp
//
//  Created by Konstantin Bondar on 19.01.2024.
//

import UIKit

final class BirthdayViewController: UIViewController {
    
    @IBOutlet weak var foregroundImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var numberImageView: UIImageView!
    @IBOutlet weak var portraitView: PortraitView!
    @IBOutlet weak var shareButton: UIButton!
    
    private lazy var imagePicker = ImagePicker(presentingViewController: self, delegate: self)
    
    var viewModel: BirthdayViewModel? = .init(storage: UserDefaultStorage())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        portraitView.translatesAutoresizingMaskIntoConstraints = false
        portraitView.delegate = self
        
        updateView(with: ThemeManager.shared.theme)
        
        setupBindings()
        
        viewModel?.loadChild()
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setupBindings() {
        viewModel?.updateUI = { [weak self] in
            self?.titleLabel.text = self?.viewModel?.title
            
            let dateRepresentation = self?.viewModel?.dateRepresentation
            self?.dateLabel.text = (dateRepresentation?.item ?? "") + " " + "old!".localized
            self?.numberImageView.image = self?.viewModel?.numberImage(number: dateRepresentation?.count ?? 0)
            
            self?.viewModel?.portrait.flatMap { [weak self] in self?.portraitView.updatePortrait(to: $0) }
        }
    }
    
    private func updateView(with theme: Theme) {
        view.backgroundColor = theme.light
        foregroundImageView.image = theme.foregroundImage
    }
    
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func shareAction(_ sender: Any) {
        shareButton.isHidden = true

        let renderer = UIGraphicsImageRenderer(size: view.bounds.size)
        let screenshot = renderer.image { _ in
            view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        }

        let activityViewController = UIActivityViewController(activityItems: [screenshot], applicationActivities: nil)

        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.barButtonItem = navigationItem.rightBarButtonItem // or any other bar button item
        }
        present(activityViewController, animated: true, completion: nil)
        shareButton.isHidden = false
    }
}

extension BirthdayViewController: PortraitViewDelegate {
    func changePortraitPressed() {
        imagePicker.presentImagePicker()
    }
}

extension BirthdayViewController: ImagePickerDelegate {
    func didSelectImage(_ image: UIImage) {
        viewModel?.changePortrait(to: image)
    }
}

extension BirthdayViewController: ThemeObserver {
    func themeChanged(_ theme: Theme) {
        updateView(with: theme)
    }
}
