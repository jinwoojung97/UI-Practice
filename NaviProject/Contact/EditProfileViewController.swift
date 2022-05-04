//
//  EditProfileViewController.swift
//  NaviProject
//
//  Created by inforex on 2021/06/28.
//

import Foundation
import UIKit
import MobileCoreServices

class EditProfileViewController : UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate, UITextFieldDelegate {
    
    var contactVC : ContactViewController!
    
    @IBOutlet weak var editProfileImage: UIImageView!
    @IBOutlet weak var editProfileName: UITextField!
    @IBOutlet weak var myProfileName: UILabel!
    
    
    
    let photo = UIImagePickerController()
    
    var captureImage : UIImage! //찍은사진을 저장할 변수
    
    var flagImageSave = false //사진 저장 여부를 나타낼 변수
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photo.delegate = self
        
        //이미지 클릭시 이미지 픽커
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.screenDidTap))
        editProfileImage.addGestureRecognizer(tap)
        
        //저장된 프로필이미지(jpeg) 불러와 이미지형식으로 변환하여 화면적용
        if let imgData = UserDefaults.standard.object(forKey: "profileImage") as? NSData{
            if let image = UIImage(data: imgData as Data){
                self.editProfileImage.image = image
            }
        }
        //저장된 프로필네임 불러와 화면 적용
        myProfileName.text = UserDefaults.standard.value(forKey: "profileName") as? String
    }
    
    //키보드
    override func viewWillAppear(_ animated: Bool) {
        self.addKeyboardNotifications()
    }
    
    //키보드
    override func viewWillDisappear(_ animated: Bool) {
        self.removeKeyboardNotifications()
    }
    
    
    
    //사진 선택
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            editProfileImage.image = image
            let jpgImage = image.jpegData(compressionQuality: 0.1) //이미지를 >> jpeg나 png로 저장
            //퀄리티 = 0.1 >> 화질
            

            UserDefaults.standard.set(jpgImage, forKey: "profileImage")
            UserDefaults.standard.synchronize()
        }
        //사진선택하기
        print("사진선택")
        dismiss(animated: true, completion: nil)
        // 사진 선택하면 닫아주기
        
    }
    
    
    //사진 클릭 시 사진촬영 or 사진가져오기
    @objc func screenDidTap() {
//        photo.sourceType = .photoLibrary
//
//        self.present(photo, animated: true, completion: nil)
        let alert: UIAlertController
        alert = UIAlertController(title: "프로필 사진 설정", message: "설정 방법을 선택하세요", preferredStyle: UIAlertController.Style.actionSheet)
                
        var cancelAction: UIAlertAction
        cancelAction = UIAlertAction(title: "취소", style: UIAlertAction.Style.cancel, handler: { (action: UIAlertAction) in
            print("취소 액션시트 선택함")
        })
                
        var takePhotoAction: UIAlertAction
        takePhotoAction = UIAlertAction(title: "사진 촬영", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction) in
            print("사진 촬영하기 액션시트 선택함")
            self.takePhoto()
        })
        
        var getPhotoAction: UIAlertAction
        getPhotoAction = UIAlertAction(title: "사진 가져오기", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction) in
            print("사진 가져오기 액션시트 선택함")
            
            self.photo.sourceType = .photoLibrary
            
            self.present(self.photo, animated: true, completion: nil)
        })
        
   
        alert.addAction(cancelAction)
        alert.addAction(takePhotoAction)
        alert.addAction(getPhotoAction)
        
                
                
        self.present(alert,animated: true){
            print("얼럿 보여짐")
        }
    }

    
    //사진찍기
    func takePhoto(){
        if(UIImagePickerController.isSourceTypeAvailable(.camera)){
            //사진 저장 플래그를 true로 설정
            flagImageSave = true
            
            photo.delegate = self
            //이미지피커의 소스타입을 camera로 설정
            photo.sourceType = .camera
            //미디어타입을 kUTTypeImage로 설정
            photo.mediaTypes = [kUTTypeImage as String]
            //편집허용안함
            photo.allowsEditing = false
            //현재 뷰를 이미지피커로 대체함. 뷰에 imagepicker 보임
            present(photo, animated: true, completion: nil)
        }else{
            //카메라를 사용할 수 없을때 경고창 나타냄
            alertMessage(alarmMessage: "카메라 사용할 수 없음")
        }
    }
    
    
    //=====================================사진============================================
    
    
    
    //완료버튼 클릭시 이름 변경 적용 + dismiss
    @IBAction func btnEditProfile(_ sender: Any) {
        if editProfileName.text != ""{
            UserDefaults.standard.setValue(editProfileName.text!, forKey: "profileName")
            
            myProfileName.text = editProfileName.text!
            
        }
        contactVC.viewDidLoad()
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }

    
    //=====================================키보드============================================
    
    //화면 터치하면 키보드 내려가게 하는 함수
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
          self.view.endEditing(true)
    }
    
    //노티피케이션을 추가하는 메소드
    func addKeyboardNotifications(){
        //키보드가 나타날 때 앱에게 알리는 메서드 추가
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        //키보드가 사라질 때 앱에게 알리는 메서드 추가
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    //노티피케이션을 제거하는 메소드
    func removeKeyboardNotifications(){
        //키보드가 나타날 때 앱에게 알리는 메서드 추가
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification,
                                                  object: nil)
        //키보드가 사라질 때 앱에게 알리는 메서드 추가
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification,
                                                  object: nil)
    }
    
    //키보드가 나타나면 실행할 메소드
    @objc func keyboardWillShow(_ noti: NSNotification){
        //키보드의 높이만큼 화면 올리기
        if let keyboardFrame: NSValue = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue{
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.view.frame.origin.y -= keyboardHeight
            //키보드height - 탭바height 만큼 뷰를 올려주기
            
        }
    }
    //키보드가 사라지면 실행할 메소드
    @objc func keyboardWillHide(_ noti: NSNotification){
        //키보드의 높이만큼 화면 내리기
        if let keyboardFrame: NSValue = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue{
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.view.frame.origin.y += keyboardHeight
            
        }
    }
    
    //=====================================키보드============================================
    
    
    //alertMessage
    func alertMessage(alarmMessage: String){
        let alert = UIAlertController(title: "알림", message: alarmMessage, preferredStyle: UIAlertController.Style.alert)
                    
        let confirm = UIAlertAction(title: "확인", style: .default) { (action) in
            print("Confirm")
        }
        alert.addAction(confirm)
                    
        self.present(alert, animated: true, completion: nil)
    }
   
}



