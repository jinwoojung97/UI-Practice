//
//  AddContactViewController.swift
//  NaviProject
//
//  Created by inforex on 2021/06/28.
//

import Foundation
import UIKit
import MobileCoreServices

//연락처 구조체
struct Contact {
    var contactImage : UIImage
    var contactName : String = ""
    var contactNumber : String = ""
}

//연락처 넘길 델리게이트 프로토콜
protocol sendContactDelegate {
    func dataReceived(data: [Contact])
}

class AddContactViewController : UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate, UITextFieldDelegate {
    @IBOutlet weak var addContactImage: UIImageView!
    @IBOutlet weak var addContactName: UITextField!
    @IBOutlet weak var addContactNumber: UITextField!
    
    let photo = UIImagePickerController()
    
    //var captureImage : UIImage! //찍은사진을 저장할 변수
    
    var flagImageSave = false //사진 저장 여부를 나타낼 변수
    
    
    var addContact : [Contact] = [] // 컨텍트 구조체 타입의 빈 배열 생성
    
    var selectedImage : UIImage?   // 연락처의 사진을 담을 변수
    
    var data = ""
    
    var delegate : sendContactDelegate?
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photo.delegate = self
        
        //이미지 클릭시 이미지 픽커
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.screenDidTap))
        
        addContactImage.addGestureRecognizer(tap)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.addKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.removeKeyboardNotifications()
    }
    
    
    
    
    
    //=====================================사진============================================
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            addContactImage.image = image //사진 바꾸기
            selectedImage = image //사진 배열에 저장하기
        }
        //사진선택하기
        print("사진선택")
        dismiss(animated: true, completion: nil)
        // 사진 선택하면 닫아주기
        
    }
    

    
    @objc func screenDidTap() {

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
    
    
    
    
    
    //완료버튼 클릭시
    @IBAction func btnAddContact(_ sender: Any) {
        //배열에 입력데이터 추가
        
        //입력 값 필수 설정
        if selectedImage == nil {
            alertMessage(alarmMessage: "사진을 선택해주세요.")
        }
        else if addContactName.text == "" {
            alertMessage(alarmMessage: "이름을 입력해주세요.")
        }
        else if  addContactNumber.text == "" {
            alertMessage(alarmMessage: "연락처를 입력해주세요.")
        }
        else{
            addContact.append(Contact(contactImage: selectedImage!,
                                      contactName: addContactName.text!,
                                      contactNumber: addContactNumber.text!))
            
            //델리게이트를 통해 데이터를 넘겨주는..
            delegate?.dataReceived(data: addContact )

            dismiss(animated: true, completion: nil)
        }
        
    }
    
    
    
    
    
    
    //=====================================키보드============================================
    
    var keyboardStatus = false
    
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
        if keyboardStatus{
            //키보드 올라가있는 상태에서 텍스트필드를 클릭하면 키보드가 또 올라와서 뷰가 두번 올라가는것을 방지
            print("키보드 올라가 있음")
        }else{
            if let keyboardFrame: NSValue = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue{
                let keyboardRectangle = keyboardFrame.cgRectValue
                let keyboardHeight = keyboardRectangle.height
                self.view.frame.origin.y -= keyboardHeight
                //키보드height - 탭바height 만큼 뷰를 올려주기
                keyboardStatus = true
            }
        }
        
    }
    //키보드가 사라지면 실행할 메소드
    @objc func keyboardWillHide(_ noti: NSNotification){
        //키보드의 높이만큼 화면 내리기
        if keyboardStatus{
            if let keyboardFrame: NSValue = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue{
                let keyboardRectangle = keyboardFrame.cgRectValue
                let keyboardHeight = keyboardRectangle.height
                self.view.frame.origin.y += keyboardHeight
                keyboardStatus = false
            }
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
