import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    let locationManager = CLLocationManager()
    var weatherData = WeatherData()
    
    @IBOutlet weak var cityNameLabel: UILabel!
    
    @IBOutlet weak var weatherDescriptiinLabel: UILabel!
    
    @IBOutlet weak var temperatureLabel: UILabel!
    
    @IBOutlet weak var weatherIconImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startLocationManager()
    }
    
    func updateView() {// настраиваем нашу погоду
        cityNameLabel.text = weatherData.name // Содержиться название нашего города
        weatherDescriptiinLabel.text = DataSource.weatherIDs[weatherData.weather[0].id] // описание погодных условий он у нас в файле датасоурс
        temperatureLabel.text = weatherData.main.temp.description + "°" // температра которая содержиться в темп везер дата
        weatherIconImageView.image = UIImage(named: weatherData.weather[0].icon) // ну и иконка с нашей картинкой которые мы загрузили из папки 
    }
    func updateWeatherInfo(latitude: Double, loutitude: Double) { // написать функцию которая будет получать инфо о погоде с 2 параметрами широта и долгота
        let session = URLSession.shared // создадим сессию которая будет работать для получения информации
        let url = URL(string: "http://api.openweathermap.org/data/2.5/weather?lat=\(latitude.description)&lon=\(loutitude.description)&units=metric&lang=ru&appid=64a19fc4d602039b9dcc9826ea8fc20b")!
        let task = session.dataTask(with: url) { (data, responds, error) in
            guard error == nil else {
                print("DataTask: error: \(error!.localizedDescription)")
                return
            }
            do {
                self.weatherData = try JSONDecoder().decode(WeatherData.self, from: data!)
                DispatchQueue.main.async {
                    self.updateView()
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    
    
    func startLocationManager() {
        locationManager.requestWhenInUseAuthorization() // пройти авторизацию
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self // передаем данные
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters // выставляем точность геолокации
            locationManager.pausesLocationUpdatesAutomatically = false    // прописываем что бы локатион менеджер что бы он не выключался и не становился в паузу
            locationManager.startUpdatingLocation() // что бы все работало нам нужно локатион менеджер обновить и запустить
        }
    }
}

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lastLocation = locations.last {
            updateWeatherInfo(latitude: lastLocation.coordinate.latitude, loutitude: lastLocation.coordinate.longitude)
        }
    }
}


