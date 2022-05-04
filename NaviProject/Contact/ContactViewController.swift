//
//  ContactViewController.swift
//  NaviProject
//
//  Created by inforex on 2021/06/25.
//

import Foundation
import UIKit

class ContactViewController : UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate{
    
    

    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var contactTableView: UITableView!
    @IBOutlet weak var myProfileImage: UIImageView!
    @IBOutlet weak var myProfileName: UILabel!
    
    var contactList = [Contact]() //Contact 타입의 배열을 담을 비어있는 2차원 배열
    var filterContactList = [Contact]() //검색 결과에 따라 필터링된 배열
    var filtered = false //필터 작업을 수행했는지 안했는지 판별하는 변수


    @IBAction func modifyProfile(_ sender: Any) {
        guard let editProfileVC = storyboard?.instantiateViewController(identifier: "EditProfileViewController") as? EditProfileViewController else {return}
        
        editProfileVC.contactVC = self //뷰 리로드 위한 ..
        //editProfileVC.modalPresentationStyle = .fullScreen
        self.present(editProfileVC, animated: true, completion: nil)
        
    }
    
    
    @IBAction func addContact(_ sender: Any) {
        guard let vc = storyboard?.instantiateViewController(identifier: "AddContactViewController") as? AddContactViewController else {return}
        
        self.present(vc, animated: true, completion: nil)
        vc.delegate = self
        
    }
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contactTableView.delegate = self
        contactTableView.dataSource = self
        
        //저장된 프로필이미지(jpeg) 불러와 이미지형식으로 변환하여 화면적용
        if let imgData = UserDefaults.standard.object(forKey: "profileImage") as? NSData{
            if let image = UIImage(data: imgData as Data){
                self.myProfileImage.image = image
            }
        
        }
        
        //저장된 프로필네임 가져와 적용
        myProfileName.text = UserDefaults.standard.value(forKey: "profileName") as? String
        
        print("DIDLOAD")
        
        //검색 텍스트필드
        searchTextField.delegate = self
        //텍스트필드 변경감지
        self.searchTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
    }
    
//    텍스트필드 입력 끝(키보드 없어질 때 적용)
//    @IBAction func textFieldEditingDidEnd(_ sender: Any) {
//        if let text = searchTextField.text{
//            filterText(text)
//        }else{
//            
//            return
//        }
//    }
    
    
//    텍스트필드 변경 시점 마다 적용
    @objc func textFieldDidChange(_ sender:Any?){
        if let text = searchTextField.text{
            filterText(text)
        }else{
            return
        }
    }

    
    //필터조건
    func filterText(_ query: String){
        
        
        filterContactList.removeAll()//필터데이터 안에 있는 데이터 전체삭제
        filterContactList = contactList
        filterContactList = filterContactList.filter{ $0.contactName.contains(query)} //덮어쓰기
        print("query = \(query)" )
        print("filterContactList = \(filterContactList)")
        if query == "" { //텍스트창이 비었다면 ?
            filtered = false
        }else{
            filtered = true
        }//텍스트필드의 텍스트 유무에 따라 필터 된 연락를 보여줄지 또는 전체 연락처를 보여줄지 결정
        
        contactTableView.reloadData()
        
    }
    
    //화면 터치하면 키보드 내려가게 하는 함수
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
          self.view.endEditing(true)
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        print("WILLAPPEAR")
    }
    
    
    
    //친구목록 테이블 뷰
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !filterContactList.isEmpty{ //필터리스트가 비어있지 않다면 필터리스트 출력
            return filterContactList.count
        }
        print(filtered)
        return filtered ? 0 : contactList.count //검색텍스트창이 비어있다면 전체연락처를 비어있지않다면 검색결과리스트를 출력!
        //return contactList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = contactTableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as? ContactCell else{ return UITableViewCell() }
        if !filterContactList.isEmpty{
            //비어있지 않다면
            cell.contactImage.image = filterContactList[indexPath.row].contactImage
            cell.contactName.text = filterContactList[indexPath.row].contactName
            cell.contactNumber.text = filterContactList[indexPath.row].contactNumber
        }else{
            //비어있다면
            cell.contactImage.image = contactList[indexPath.row].contactImage
            cell.contactName.text = contactList[indexPath.row].contactName
            cell.contactNumber.text = contactList[indexPath.row].contactNumber
        }
        
        return cell
    }
    
    //친구목록 클릭 시 전화 걸기
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let phoneNumber : Int?
        
        //
        if !filterContactList.isEmpty{
            phoneNumber = Int(filterContactList[indexPath.row].contactNumber)
            print(phoneNumber!)
        }else{
            phoneNumber = Int(contactList[indexPath.row].contactNumber)
            print(phoneNumber!)
        }
        
        
        //URLScheme 문자열을 통해 URL 인스턴스 만들기.  tel://0#### 형식
        if let url = NSURL(string: "tel://0" + "\(phoneNumber!)"), UIApplication.shared.canOpenURL(url as URL){ //
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        }
        
    }

    
}


extension ContactViewController : sendContactDelegate{
    func dataReceived(data: [Contact]) {
        
        print("연락처 정보 >>  \(data)")
        contactList.append(contentsOf: data
        )
        
        contactTableView.reloadData()//테이블 리로드
        
        print("연락처 정보 리스트 >>  \(contactList)")
        print(contactList.count)

        
    }
}


