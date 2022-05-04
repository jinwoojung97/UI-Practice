import Foundation
import UIKit
import NMapsMap
import MapKit

class ThirdViewController : UIViewController{
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let mapView = NMFMapView(frame: view.frame)
        view.addSubview(mapView)
        

        
        //실내지도 활성화
        mapView.isIndoorMapEnabled = true
        

        
        //카메라현재위치
        let cameraPosition = mapView.cameraPosition
        print("location >>>>>> \(cameraPosition)")
        
        //카메라를 세정아울렛으로 변경하는 NMFCameraUpdate객체를 만들고 moveCamera 통해 카메라 EaseIn 애니메이션으로 1.5초간 움직이기
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: 35.146501, lng: 126.846827))
        cameraUpdate.animation = .fly
        cameraUpdate.animationDuration = 2.2
        mapView.moveCamera(cameraUpdate)
        
        //위치추적모드 변경
        mapView.positionMode = .compass
        
        //locationOverlay객체를가져와 hidden속성을 변경
        let locationOverlay = mapView.locationOverlay
        locationOverlay.hidden = false
        
        //위치오버레이좌표를 변경
        locationOverlay.location = NMGLatLng(lat: 35.146501, lng: 126.846827)
        //동쪽바라보게
        locationOverlay.heading = 90
        //원반지름
        locationOverlay.circleRadius = 500
        
        
        
        marker(lat: 35.146501, lng: 126.846827, title: "인포렉스")
        
        marker(lat: 35.18028460046176, lng: 126.81464364093836, title: "우리집")
        
        
        func marker(lat : Double, lng : Double, title : String){
            //마커 띄우기
            let marker = NMFMarker()
            marker.position = NMGLatLng(lat: lat, lng: lng)
            marker.iconImage = NMF_MARKER_IMAGE_BLACK
            marker.iconTintColor = UIColor.orange
            marker.width = 25
            marker.height = 30
            marker.mapView = mapView
            
            // 정보창 생성
            let infoWindow = NMFInfoWindow()
            let dataSource = NMFInfoWindowDefaultTextSource.data()
            dataSource.title = title
            infoWindow.dataSource = dataSource
            
            // 마커에 달아주기
            infoWindow.open(with: marker)
        }
        
        

    }


    
}



