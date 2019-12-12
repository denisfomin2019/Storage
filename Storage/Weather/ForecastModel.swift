
import Foundation
import RealmSwift


class Interval: Object {

    @objc dynamic var date: String = ""
    @objc dynamic var time: String = ""
    @objc dynamic var temperature: String = ""
    @objc dynamic var conditionDescription: String = ""
    @objc dynamic var conditionId: Int = 0
    var allIntervals = LinkingObjects(fromType: Forecast.self, property: "allIntervals")


    convenience init?(data: NSDictionary){
        self.init()
       guard let mainDictionary = data["main"] as? NSDictionary,
            let temp = mainDictionary["temp"] as? Double,
            let weatherArray = data["weather"] as? NSArray,
            let condition = (weatherArray[0] as AnyObject).value(forKey:"description") as? String,
            let timeResult = data["dt"] as? Double,
            let id = (weatherArray[0] as AnyObject).value(forKey:"id") as? Int


        else {
            return nil
        }

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "dd MMMM"
        let formattedDate = dateFormatter.string(from:Date(timeIntervalSince1970: timeResult))

        let timeFormatter = DateFormatter()
        timeFormatter.locale = Locale(identifier: "ru_RU")
        timeFormatter.setLocalizedDateFormatFromTemplate("HH:mm a")
        timeFormatter.amSymbol = ""
        timeFormatter.pmSymbol = ""
        let formattedTime = timeFormatter.string(from:Date(timeIntervalSince1970: timeResult))

        self.temperature = "\(Int(temp))℃"
        self.conditionDescription = condition
        self.time = formattedTime
        self.date = formattedDate
        self.conditionId = id

    }

    func updateWeatherIcon(condition: Int) -> String {

    switch (conditionId) {

        case 0...300 :
            return "Snow-Flake"

        case 301...500 :
            return "Rain"

        case 501...600 :
            return "Hard-Rain"

        case 601...700 :
            return "Snow"

        case 701...771 :
            return "Fog"

        case 772...799 :
            return "Storm"

        case 800 :
            return "Sun"

        case 801...804 :
            return "Cloudy Day "

        case 900...903, 905...1000  :
            return "Storm"

        case 903 :
            return "Snow-Flake"

        case 904 :
            return "Sun"

        default :
            return "dunno"
        }
    }
}


struct Day {
    
    var intervals: [Interval] = []
}


class Forecast: Object {
    
    let allIntervals = List<Interval>()
    //Set primary key
    @objc dynamic var id: Int = 1
    override static func primaryKey() -> String? {
        return "id"
    }
}

