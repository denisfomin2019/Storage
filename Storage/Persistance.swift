

import Foundation
import RealmSwift

class Persistance {
    
    static let shared = Persistance()
    private let realm = try! Realm()
    
    
    //User Defaults
    
    private let kFirstNameKey = "Persistance.kFirstNameKey"
    private let kLastNameKey = "Persistance.kLastNameKey"
    
    var firstName: String? {
        set{UserDefaults.standard.set(newValue, forKey: kFirstNameKey)}
        get{UserDefaults.standard.string(forKey: kFirstNameKey)}
        
    }
        
    var lastName: String? {
        set{UserDefaults.standard.set(newValue, forKey: kLastNameKey)}
        get{UserDefaults.standard.string(forKey: kLastNameKey)}
    }
    
       
    //ToDo Realm
    func saveItem (_ item: TodoItem) {
        try! realm.write {
            realm.add(item)
        }
    }
    
    func loadItem () -> Results<TodoItem>? {
        
        let results = realm.objects(TodoItem.self)
        return results
    }
    
    func deleteItem (_ item: TodoItem) {
        
        try! realm.write {
            realm.delete(item)
        }
    }
        
    
    //Weather Realm

   func saveCurrentWeather (_ data:CurrentWeather) {
            data.id = 1
            try! realm.write {
                realm.add(data, update: .modified)
            }
    }
    
    func loadCurrentWeather() -> Results<CurrentWeather>? {
        
        let results = realm.objects(CurrentWeather.self)
        return results
    }

    
    func saveForecast (_ data:Forecast) {
        data.id = 1
        try! realm.write {
            realm.add(data, update: .modified)
        }
    }
    
    func loadForecast() -> Results<Forecast>? {
        
        let results = realm.objects(Forecast.self)
        return results
    }
     
}
