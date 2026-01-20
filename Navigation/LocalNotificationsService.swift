//
//  LocalNotificationsService.swift
//  Navigation
//
//  Created by Toha Shilin on 20.01.26.
//

import Foundation
import UserNotifications

final class LocalNotificationsService {
    
    
    func requestPermission(completion: @escaping (Bool) -> Void ) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if let error = error {
                print(error)
                completion(false)
                return
            }
            if success {
                completion(true)
                return
            }
        }
    }
    
    func addCheckUpdateNotification(hour: Int) {
        let content = UNMutableNotificationContent()
        content.title = "Navigation"
        content.body = "Посмотрите последние обновления"
        content.sound = .default
        
        var date = DateComponents()
        date.hour = hour
        let triger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
        
        let request = UNNotificationRequest(identifier: "check_update_notification", content: content, trigger: triger)
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["check_update_notification"])
        UNUserNotificationCenter.current().add(request)
    }
    
}
