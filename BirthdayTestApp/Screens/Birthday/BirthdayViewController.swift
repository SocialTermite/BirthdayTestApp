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
    
    private lazy var imagePicker = ImagePicker(presentingViewController: self, delegate: self)
    
    var viewModel: BirthdayViewModel? = .init(storage: UserDefaultStorage())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        portraitView.translatesAutoresizingMaskIntoConstraints = false
        portraitView.delegate = self
        updateView(with: ThemeManager.shared.theme)
        
        setupBindings()
        
        viewModel?.loadChild()
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
