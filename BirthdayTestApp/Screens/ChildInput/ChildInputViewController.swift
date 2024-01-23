//
//  ViewController.swift
//  BirthdayTestApp
//
//  Created by Konstantin Bondar on 18.01.2024.
//

import UIKit

class ChildInputViewController: UIViewController {
    
    @IBOutlet weak var portraitImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var changePortraitButton: UIButton!
    @IBOutlet weak var clearAllButton: UIButton!
    
    @IBOutlet weak var nameErrorLabel: UILabel!
    @IBOutlet weak var dateErrorLabel: UILabel!
    
    @IBOutlet weak var showBirthdayButton: UIButton!
    
    @IBOutlet weak var showBirthdayButtonBottomConstraint: NSLayoutConstraint!
    
    private let datePicker = UIDatePicker()
    private lazy var imagePicker = ImagePicker(presentingViewController: self, delegate: self)
    
    var viewModel: ChildInputViewModel? = .init(storage: UserDefaultStorage())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ThemeManager.shared.subscribe(observer: self)
        
        themeChanged(ThemeManager.shared.theme)
        
        setupView()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel?.refresh()
    }
    
    private func setupView() {
        showBirthdayButton.layer.cornerRadius = 21
        
        datePicker.preferredDatePickerStyle = .wheels
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(datePickerValueChanged))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        doneButton.tintColor = Theme.text
        
        toolbar.setItems([spaceButton, doneButton], animated: false)
        
        dateTextField.inputAccessoryView = toolbar
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        portraitImageView.layer.cornerRadius = portraitImageView.bounds.width / 2
    }
    
    private func setupBindings() {
        viewModel?.updateUI = { [weak self] isFullFiled in
            self?.nameTextField.text = self?.viewModel?.childName
            
            self?.dateTextField.text = nil
            
            self?.viewModel?.childBirthday.flatMap { [weak self] in
                self?.dateTextField.text = self?.formatter.string(from: $0)
            }
            
            self?.portraitImageView.image = self?.viewModel?.childPortrait ?? ThemeManager.shared.theme.fullPortraitPlaceholderImage
            
            self?.changeShowButtonPresentState(toPresented: isFullFiled)
            self?.clearAllButton.isHidden = !isFullFiled
        }
        
        
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        
        dateTextField.inputView = datePicker
        
        nameTextField.delegate = self
        dateTextField.delegate = self
    }
    
    private func changeShowButtonPresentState(toPresented: Bool) {
        showBirthdayButton.isHidden = !toPresented
    }
    
    private let formatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        return dateFormatter
    }()
    
    @IBAction func changePortrait(_ sender: Any) {
        imagePicker.presentImagePicker()
    }
    
    @IBAction func clearAll(_ sender: Any) {
        viewModel?.clearAll()
        clearAllButton.isHidden = true
    }
    
    @IBAction func showBirthday(_ sender: Any) {
        if let vc = UIStoryboard.init(name: "Main", bundle: .main)
            .instantiateViewController(identifier: "BirthdayViewController") as? BirthdayViewController,
           let storage = viewModel?.storage {
            vc.viewModel = .init(storage: storage)
            show(vc, sender: nil)
        }
        
        ThemeManager.shared.changeThemeRandomly()
    }
}

extension ChildInputViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        dateErrorLabel.isHidden = true
        nameErrorLabel.isHidden = true
        
        if dateTextField == textField {
            nameTextField.text = viewModel?.childName
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField {
            if let text = textField.text, !text.isEmpty {
                dateTextField.becomeFirstResponder()
                viewModel?.changeName(to: text)
            } else {
                nameErrorLabel.isHidden = false
                return false
            }
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
    
    @objc func datePickerValueChanged() {
        viewModel?.changeBirthday(to: datePicker.date)
        dateTextField.resignFirstResponder()
    }
}

extension ChildInputViewController: ThemeObserver {
    func themeChanged(_ theme: Theme) {
        view.backgroundColor = theme.light
        portraitImageView.image = viewModel?.childPortrait ?? theme.fullPortraitPlaceholderImage
    }
}

extension ChildInputViewController: ImagePickerDelegate {
    func didSelectImage(_ image: UIImage) {
        viewModel?.changePortrait(to: image)
    }
}

