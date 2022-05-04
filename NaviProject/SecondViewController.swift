import Foundation
import UIKit
import MobileCoreServices

class SecondViewController : UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    @IBOutlet weak var imageView: UIImageView!
    
    //인스턴스 변수 생성
    let imagePicker = UIImagePickerController()
    
    //사진을 저장할 변수
    var captureImage: UIImage!
    
    // 녹화한 비디오의 URL을 저장할 변수
    var videoURL: URL!
    
    //사진 저장 여부를 나타낼 변수
    var flagImageSave = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        
    }
    
    
    //사진찍기
    @IBAction func buttonTakePhoto(_ sender: Any) {
        //카메라 사용여부 확인
        if(UIImagePickerController.isSourceTypeAvailable(.camera)){
            //사진 저장 플래그를 true로 설정
            flagImageSave = true
            
            imagePicker.delegate = self
            //이미지피커의 소스타입을 camera로 설정
            imagePicker.sourceType = .camera
            //미디어타입을 kUTTypeImage로 설정
            imagePicker.mediaTypes = [kUTTypeImage as String]
            //편집허용안함
            imagePicker.allowsEditing = false
            //현재 뷰를 이미지피커로 대체함. 뷰에 imagepicker 보임
            present(imagePicker, animated: true, completion: nil)
        }else{
            //카메라를 사용할 수 없을때 경고창 나타냄
            alertMessage(alarmMessage: "카메라 사용할 수 없음")
        }
    }
    
    
    //사진불러오기
    @IBAction func buttonLoadImage(_ sender: Any) {
        if(UIImagePickerController.isSourceTypeAvailable(.photoLibrary)){
            flagImageSave = false
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.mediaTypes = [kUTTypeImage as String]
            //편집허용
            imagePicker.allowsEditing = true
            
            present(imagePicker, animated: true, completion: nil)
        }else{
            alertMessage(alarmMessage: "사진 사용할 수 없음")
        }
    }
    
    //동영상촬영
    @IBAction func buttonTakeVideo(_ sender: Any) {
        if(UIImagePickerController.isSourceTypeAvailable(.camera)){
            flagImageSave = true
            
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            //미디어타입을 kUTTypeMovie로 설정
            imagePicker.mediaTypes = [kUTTypeMovie as String]
            imagePicker.allowsEditing = false
            
            present(imagePicker, animated: true, completion: nil)
        }else{
            alertMessage(alarmMessage: "카메라 사용할 수 없음")
        }
    }
    
    //동영상불러오기
    @IBAction func buttonLoadVideo(_ sender: Any) {
        if(UIImagePickerController.isSourceTypeAvailable(.photoLibrary)){
            flagImageSave = false
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.mediaTypes = [kUTTypeMovie as String]
            //편집허용
            imagePicker.allowsEditing = false
            
            present(imagePicker, animated: true, completion: nil)
        }else{
            alertMessage(alarmMessage: "사진 사용할 수 없음")
        }
    }
    // 사진, 비디오 촬영이나 선택이 끝났을 때 호출되는 델리게이트 메서드
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // 미디어 종류 확인
        let mediaType = info[UIImagePickerController.InfoKey.mediaType] as! NSString
       
        // 미디어 종류가 사진(Image)일 경우
        if mediaType.isEqual(to: kUTTypeImage as NSString as String){
            
            // 사진을 가져와 captureImage에 저장
            captureImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            
            if flagImageSave { // flagImageSave가 true이면
                // 사진을 포토 라이브러리에 저장
                UIImageWriteToSavedPhotosAlbum(captureImage, self, nil, nil)
            }
            imageView.image = captureImage // 가져온 사진을 이미지 뷰에 출력
         //미디어 종류가 비디오(Movie)일 경우
        }else if mediaType.isEqual(to: kUTTypeMovie as NSString as String) {

            if flagImageSave { // flagImageSave가 true이면
                // 촬영한 비디오를 옴
                videoURL = (info[UIImagePickerController.InfoKey.mediaURL] as! URL)
                // 비디오를 포토 라이브러리에 저장
                UISaveVideoAtPathToSavedPhotosAlbum(videoURL.relativePath, self, nil, nil)
            }
        }
        // 현재의 뷰 컨트롤러를 제거. 즉, 뷰에서 이미지 피커 화면을 제거하여 초기 뷰를 보여줌
        self.dismiss(animated: true, completion: nil)
    }
    
    // 사진, 비디오 촬영이나 선택을 취소했을 때 호출되는 델리게이트 메서드
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // 현재의 뷰(이미지 피커) 제거
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
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

