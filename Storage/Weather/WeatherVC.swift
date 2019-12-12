
import UIKit
import MBProgressHUD

class WeatherVC: UIViewController {

    var days:[Day] = []
    var hud = MBProgressHUD()
    
    
    
    
    @IBOutlet weak var currentWeatherView: CurrentWeatherView!
    @IBOutlet weak var tableView: UITableView!
    
    
    // Загрузка экрана
    /**************************************************************/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let savedCurrentWeather = Persistance.shared.loadCurrentWeather()?.first {
            print("!!!Текущая погода получена из кэша")
            fillCurrentWeatherData(data: savedCurrentWeather)
        }
        
        if let savedIntervals = Persistance.shared.loadForecast()?.first {
            print("!!!Прогноз получен из кэша")
            sortByDays(intervals: Array(savedIntervals.allIntervals))
            tableView.reloadData()
        }
            
        loadWithAlamofire()
        tableView.separatorColor = #colorLiteral(red: 0.298427254, green: 0.2889604568, blue: 0.7316837907, alpha: 1)

    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    //Отображение данных
    /**************************************************************/
    
    
    func loadWithAlamofire(){
        
        showSpinner()
        
        AlamofireLoader().loadCurrentWeather {currentWeather in
            print("!!!Новая текущая погода получена")
            self.fillCurrentWeatherData(data: currentWeather)
            
        }

        AlamofireLoader().loadForecast {forecast in
            print("!!!Новый прогноз получен")
            self.sortByDays(intervals: Array(forecast.allIntervals))
            self.tableView.reloadData()
            self.hideSpinner()
            
        }
    }
    
    func fillCurrentWeatherData(data:CurrentWeather){
        
        self.currentWeatherView.tempLabel.text = data.temperature
        self.currentWeatherView.conditionLabel.text = data.condition
        self.currentWeatherView.weatherImageView.image = UIImage(named: data.updateWeatherIcon(condition:data.conditionId))
    }
    
    //Сортировка данных по дням
    /**************************************************************/
    func sortByDays(intervals: [Interval]) {
        
        if intervals.count != 0{
            days.removeAll()
            var currentDate = intervals.first!.date
            var dayReadings = Day()
            
            
            for i in 0...intervals.count-1{
                
                let newCell = intervals[i]
                let date = newCell.date
                    if date == currentDate {
                        dayReadings.intervals.append(newCell)
                    }
                
                    else {
                        currentDate = date
                        days.append(dayReadings)
                        dayReadings.intervals.removeAll()
                        dayReadings.intervals.append(newCell)
                    }
            }
        }
    }
}

//Заполнение таблицы
/**************************************************************/

extension WeatherVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return days.count
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeader = tableView.dequeueReusableCell(withIdentifier: "SectionHeader") as! SectionCell
        
            sectionHeader.dateLabel.text = days[section].intervals[0].date
            return sectionHeader
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
       return 40
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return days[section].intervals.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as! TableViewCell
        
        cell.timeLabel.text = days[indexPath.section].intervals[indexPath.row].time
        cell.conditionLabel.text = days[indexPath.section].intervals[indexPath.row].conditionDescription
        cell.temperatureLabel.text = days[indexPath.section].intervals[indexPath.row].temperature
        
        let id = days[indexPath.section].intervals[indexPath.row].conditionId
        cell.weatherImageView.image = UIImage(named: days[indexPath.section].intervals[indexPath.row].updateWeatherIcon(condition: id))
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}


// Спиннер
/**************************************************************/

extension UIViewController {
    
    func showSpinner() {
        let spinner = MBProgressHUD.showAdded(to: self.view, animated: true)
        spinner.contentColor = #colorLiteral(red: 0.298427254, green: 0.2889604568, blue: 0.7316837907, alpha: 1)
        spinner.bezelView.style = .solidColor
        spinner.bezelView.backgroundColor = #colorLiteral(red: 0.9961728454, green: 0.9902502894, blue: 1, alpha: 0.198630137)
        spinner.show(animated: true)
        
   }
   func hideSpinner() {
      MBProgressHUD.hide(for: self.view, animated: true)
   }
}
