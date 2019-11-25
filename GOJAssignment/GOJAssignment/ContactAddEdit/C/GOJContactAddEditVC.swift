//
//  GOJContactAddEditVC.swift
//  GOJAssignment
//
//  Created by Deepak Singh on 23/11/19.
//  Copyright © 2019 Deepak Singh. All rights reserved.
//


import UIKit

class GOJContactAddEditVC: UIViewController {

    //MARK:- Outlets
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var addEditTableView: UITableView!
    @IBOutlet weak var tableBottomConstraint: NSLayoutConstraint!
    
    //MARK:- Variables
    var viewModel: GOJContactAddEditVM!
    private var activefieldFrame: CGRect = CGRect.zero

    //MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        if viewModel == nil {
            assertionFailure("GOJContactAddEditVC: Empty View Model")
        }
        setupUI()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    //MARK:- Actions
    @IBAction func cancelAction(_ sender: Any) {
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneAction(_ sender: Any) {
        view.endEditing(true)
        viewModel.saveContact()
    }
    
    //MARK:- Private Methods
    private func setupUI() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        navigationController?.navigationBar.shadowImage = UIImage()
        addEditTableView.rowHeight = UITableView.automaticDimension
        addEditTableView.dataSource = self
        addEditTableView.delegate = self
        addEditTableView.tableFooterView = UIView(frame: CGRect.zero)
        addHandlers()
    }

    private func addHandlers() {
        viewModel.callbackHandler = { [weak self] (callbackType: GOJCallback) in
            if let weakSelf: GOJContactAddEditVC = self {
                DispatchQueue.main.async {
                    switch callbackType {
                    case .showLoader:
                        weakSelf.view.isUserInteractionEnabled = false
                        weakSelf.activityIndicator.startAnimating()
                    case .hideLoader:
                        weakSelf.activityIndicator.stopAnimating()
                        weakSelf.view.isUserInteractionEnabled = true
                    case .showError(let error):
                        let alert: UIAlertController = UIAlertController(title: GOJStringConstants.error, message: error.localizedDescription, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: GOJStringConstants.ok, style: .cancel, handler: nil))
                        weakSelf.present(alert, animated: true, completion: nil)
                    case .reloadContent:
                        weakSelf.dismiss(animated: true, completion: nil)
                    case .openImagePicker:
                        weakSelf.openImagePicker()
                    default:
                        break
                    }
                }
            }
        }
    }

    @objc private func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let endFrameY = endFrame?.origin.y ?? 0
            let duration:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
            if endFrameY >= UIScreen.main.bounds.size.height {
                tableBottomConstraint?.constant = 0.0
            } else {
                tableBottomConstraint?.constant = endFrame?.size.height ?? 0.0
            }
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }

    private func openImagePicker(){
        let alert = UIAlertController(title: GOJStringConstants.chooseImage, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: GOJStringConstants.camera, style: .default, handler: { _ in
            self.openCamera()
        }))

        alert.addAction(UIAlertAction(title: GOJStringConstants.gallery, style: .default, handler: { _ in
            self.openGallery()
        }))

        alert.addAction(UIAlertAction.init(title: GOJStringConstants.cancel, style: .cancel, handler: nil))

        present(alert, animated: true, completion: nil)
    }

    private func openCamera(){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        }
    }

    private func openGallery(){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            present(imagePicker, animated: true, completion: nil)
        }
    }
}
//MARK:- UIImagePickerControllerDelegate
extension GOJContactAddEditVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            viewModel.update(value: pickedImage, cellType: GOJDetailCellType.header)
            addEditTableView.reloadData()
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

//MARK:- UITableViewDataSource
extension GOJContactAddEditVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cellTypes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let type: GOJDetailCellType = viewModel.cellTypes[indexPath.row]
        switch type {
        case .header:
            if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: GOJContactAddEditHeaderCell.self), for: indexPath) as? GOJContactAddEditHeaderCell {
                cell.configure(type: type, viewModel: viewModel)
                return cell
            }
        default:
            if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: GOJContactAddEditInputCell.self), for: indexPath) as? GOJContactAddEditInputCell {
                cell.configure(type: type, viewModel: viewModel)
                return cell
            }
        }
        return UITableViewCell()
    }

}

//MARK:- UITableViewDelegate
extension GOJContactAddEditVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let type: GOJDetailCellType = viewModel.cellTypes[indexPath.row]
        switch type {
        case .header:
            return 150
        default:
            return 60
        }
    }
}
