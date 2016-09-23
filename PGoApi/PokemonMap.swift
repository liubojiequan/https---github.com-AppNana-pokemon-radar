//
//  PokemonMap.swift
//  PGoApi
//
//  Created by PokemonGoSucks on 2016-08-21.
//
//

import UIKit
import MapKit
import PGoApi
import CoreLocation


class PokemonMap: UIViewController, MKMapViewDelegate,CLLocationManagerDelegate,UITableViewDataSource, UITableViewDelegate,PGoAuthDelegate, PGoApiDelegate{
    var longitude:Double = 0.000000
    var latitude:Double = 0.000000
    var auth: PGoAuth!
    let locationManager = CLLocationManager()
    let ID = "Cell"
    var dataSelect = [""];
    var request = PGoApiRequest()
    var taleviewShow:UITableView!
    
    var mapCells = Pogoprotos.Networking.Responses.GetMapObjectsResponse()
    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let headbutton=UIButton()
        headbutton.frame = CGRectMake(0, 0, 150, 100)
        headbutton.setTitle("filter pokemon", forState: UIControlState.Normal)
        headbutton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        headbutton.addTarget(self, action: #selector(buttonTapped), forControlEvents: .TouchUpInside)
        self.view.addSubview(headbutton)
        let selfBtn=UIButton()
        selfBtn.frame = CGRectMake(UIScreen.mainScreen().bounds.width-150, 0, 150, 100)
        selfBtn.setTitle("self", forState: UIControlState.Normal)
        selfBtn.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        selfBtn.addTarget(self, action: #selector(selfLocation), forControlEvents: .TouchUpInside)
        self.view.addSubview(selfBtn)
        self.mapView.delegate = self
        for mapCell in mapCells.mapCells {
            let pokemons = mapCell.catchablePokemons
            let wildPokemon = mapCell.wildPokemons
            for pokemon in pokemons {
                annotate(pokemon.latitude, long: pokemon.longitude, name: "Pokemon \(pokemon.pokemonId)",id:pokemon.pokemonId.rawValue)
                print(pokemon.pokemonId.rawValue)
            }
            for pokemon in wildPokemon {
                let secondTime = Int(pokemon.timeTillHiddenMs/100)
                print(secondTime)
                let showTime = ShowTime()
                showTime.timeUse = secondTime
                showTime.lat = pokemon.latitude
                showTime.log = pokemon.longitude
                showTime.id = pokemon.pokemonData.pokemonId.rawValue
                showTime.mapView = mapView
                showTime.name = "Pokemon \(pokemon.pokemonData.pokemonId)"
                showTime.useTimer()
                print(pokemon.pokemonData.pokemonId.rawValue)
            }
        }
    }
    //添加view
    func buttonTapped(sender: UIButton) {
        print("添加view")
        let tableView = UITableView(frame: view.bounds, style: UITableViewStyle.Plain)
        tableView.userInteractionEnabled = true
        tableView.delegate = self
        tableView.dataSource = self
        //2.注册Cell
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: ID)
        //下面这种写法也是可以的
        //3.设置数据源和代理
        tableView.dataSource = self
        tableView.delegate = self;
        tableView.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height-55)
        tableView.backgroundColor=UIColor.whiteColor()
        tableView.editing = false;
        tableView.allowsMultipleSelectionDuringEditing = !tableView.editing
        // 动画 （ 建议使用这个 ）
        tableView.setEditing(!tableView.editing, animated: true)
        tableView.allowsSelectionDuringEditing = true
        tableView.allowsSelection = true
        self.view.addSubview(tableView)
        
        let viewAdd = UIView(frame:CGRectMake(0, UIScreen.mainScreen().bounds.height-55,UIScreen.mainScreen().bounds.width,55))
        viewAdd.backgroundColor = UIColor.whiteColor()
        //取消按钮
        let cancelButton=UIButton()
        cancelButton.frame = CGRectMake(UIScreen.mainScreen().bounds.width-100, 0, 100, 50)
        cancelButton.setTitle("CANCEL", forState: UIControlState.Normal)
        cancelButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        cancelButton.addTarget(self, action: #selector(cancelbtnClick), forControlEvents: .TouchUpInside)
        viewAdd.addSubview(cancelButton)
        //确认按钮
        let okButton=UIButton()
        okButton.frame = CGRectMake(0, 0, 50, 50)
        okButton.setTitle("OK", forState: UIControlState.Normal)
        okButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        okButton.addTarget(self, action: #selector(okbtnClick), forControlEvents: .TouchUpInside)
        viewAdd.addSubview(okButton)
        taleviewShow = tableView
        self.view.addSubview(viewAdd)
    }
    func cancelbtnClick(sender: UIButton) {
        for view in self.view.subviews {
            if view.isKindOfClass(UITableView) {
                view.removeFromSuperview()
            }
            if view.frame.height==55{
                view.removeFromSuperview()
            }
        }
        
    }
    func okbtnClick(sender: UIButton) {
        let cells = taleviewShow.visibleCells
        for cell in cells {
            if !(cell.selected){
                let pokemon = cell.textLabel?.text;
                var aa = "";
                aa = pokemon!.stringByReplacingOccurrencesOfString("Optional(\"", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                aa = aa.stringByReplacingOccurrencesOfString("\")", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                print(aa)
                dataSelect.append(aa)
            }
        }
        for view in self.view.subviews {
            if view.isKindOfClass(UITableView) {
                view.removeFromSuperview()
            }
            if view.frame.height==55{
                view.removeFromSuperview()
            }
        }
        let annotations = mapView.annotations
        for annotation in annotations{
            mapView.removeAnnotation(annotation)
        }
        print("ok========")
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //返回有多少行Cell, 这里返回数组的count
        return datas.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // 获得cell
        let cell = tableView.dequeueReusableCellWithIdentifier(ID, forIndexPath: indexPath)
        cell.imageView!.image = UIImage(named:"\(indexPath.row+1).png")
        // 配置cell
        cell.textLabel!.text = "\(datas[indexPath.row])"
        // 返回cell
        cell.setSelected(true, animated:true)
        tableView.selectRowAtIndexPath(indexPath, animated: true, scrollPosition: UITableViewScrollPosition.None)
        return cell
    }
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        NSLog("You will select cell #\(indexPath.row)!")
        return indexPath
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        NSLog("You selected cell #\(indexPath.row)!")
    }
    func mapView(mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        let location = CLLocationCoordinate2D(
            latitude: 16.40,
            longitude: -86.34
        )
        let span = MKCoordinateSpanMake(0.5, 0.5)
        var region = MKCoordinateRegion(center: location, span: span)
        let centerCoordinate:CLLocationCoordinate2D = mapView.region.center
        region.center = centerCoordinate
        
        print(" regionDidChangeAnimated %f,%f",centerCoordinate.latitude, centerCoordinate.longitude);
        request = PGoApiRequest(auth: auth)
        request.setLocation(centerCoordinate.latitude, longitude: centerCoordinate.longitude, altitude: 10)
        request.simulateAppStart()
        request.makeRequest(.Login, delegate: self)
        print("地图缩放级别发送改变时")
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        print("delegate called")
        
        if !(annotation is CustomPointAnnotation) {
            return nil
        }
        
        let reuseId = "test"
        
        var anView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
        if anView == nil {
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            anView!.canShowCallout = true
        }
        else {
            anView!.annotation = annotation
        }
        
        //Set annotation-specific properties **AFTER**
        //the view is dequeued or created...
        
        let cpa = annotation as! CustomPointAnnotation
        anView!.image = UIImage(named:cpa.imageName)
        
        return anView
    }

    func annotate(lat: Double, long: Double, name: String,id:Int32) {
        let info2 = CustomPointAnnotation()
        info2.coordinate = CLLocationCoordinate2DMake(lat, long)
        info2.title = name
        info2.subtitle = name
        info2.imageName = String(id)+".png"
        mapView.addAnnotation(info2)
    }
    
    func annotate(lat: Double, long: Double, name: String) {
        let mapObject = CLLocationCoordinate2DMake(lat, long)
        let dropPin = MKPointAnnotation()
        dropPin.coordinate = mapObject
        dropPin.title = name
        mapView.addAnnotation(dropPin)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func selfLocation(sender: UIButton){
        var region = MKCoordinateRegion();
        var span = MKCoordinateSpan();
        span.latitudeDelta = 0.005;
        span.longitudeDelta = 0.005;
        var selfLocation = CLLocationCoordinate2D();
        selfLocation.latitude = mapView.userLocation.coordinate.latitude;
        selfLocation.longitude = mapView.userLocation.coordinate.longitude;
        region.span = span;
        region.center = selfLocation;
        mapView.setRegion(region, animated: true)
    }
    //add by liuboj
    func didReceiveAuth() {
        print("Auth received!!")
        print("Starting simulation...")
    }
    
    func didNotReceiveAuth() {
        print("Failed to auth!")
    }
    
    func didReceiveApiResponse(intent: PGoApiIntent, response: PGoApiResponse) {
        print("Got that API response: \(intent)")
        
        
        if (intent == .Login) {
            // App simulation complete, now requesting map objects
            request.getMapObjects()
            request.makeRequest(.GetMapObjects, delegate: self)
        } else if (intent == .GetMapObjects) {
            print("Got map objects!")
            // Map cells are the first subresponse
            if(response.subresponses.count>0){
                mapCells = response.subresponses[0] as! Pogoprotos.Networking.Responses.GetMapObjectsResponse
                for mapCell in mapCells.mapCells {
                    let forts = mapCell.forts
                    let spawnPoints = mapCell.spawnPoints
                    let pokemons = mapCell.catchablePokemons
                    let wildPokemon = mapCell.wildPokemons
                    for fort in forts {
                        if (fort.hasGymPoints) {
                            annotate(fort.latitude, long: fort.longitude, name: "Gym owned by \(fort.ownedByTeam)")
                        } else {
                            annotate(fort.latitude, long: fort.longitude, name: "Pokestop")
                        }
                    }
                    
                    for spawnPoint in spawnPoints {
                        annotate(spawnPoint.latitude, long: spawnPoint.longitude, name: "Spawnpoint")
                    }
                    for pokemon in pokemons {
                        var flag = true
                        for poke in dataSelect{
                            if poke == pokemon.pokemonId.toString(){
                                flag = false
                            }
                        }
                        if flag{
                            annotate(pokemon.latitude, long: pokemon.longitude, name: "Pokemon \(pokemon.pokemonId)",id:pokemon.pokemonId.rawValue)
                            print(pokemon.pokemonId.rawValue)
                        }
                    }
                    
                    for pokemon in wildPokemon {
                        var flag = true
                        for poke in dataSelect{
                            if poke == pokemon.pokemonData.pokemonId.toString(){
                                flag = false
                            }
                        }
                        if flag{
                            let secondTime = Int(pokemon.timeTillHiddenMs/100)
                            print(secondTime)
                            let showTime = ShowTime()
                            showTime.timeUse = secondTime
                            showTime.lat = pokemon.latitude
                            showTime.log = pokemon.longitude
                            showTime.id = pokemon.pokemonData.pokemonId.rawValue
                            showTime.mapView = mapView
                            showTime.name = "Pokemon \(pokemon.pokemonData.pokemonId)"
                            showTime.useTimer()
                        }
                    }
                }
            }
        }
    }
    
    func didReceiveApiError(intent: PGoApiIntent, statusCode: Int?) {
        print("API Error: \(statusCode)")
    }
    // 懒加载
    lazy var datas: [String] = {
        // 创建一个存放int的数组
        var nums = ["BULBASAUR",
                    "IVYSAUR",
                    "VENUSAUR",
                    "CHARMANDER",
                    "CHARMELEON",
                    "CHARIZARD",
                    "SQUIRTLE",
                    "WARTORTLE",
                    "BLASTOISE",
                    "CATERPIE",
                    "METAPOD",
                    "BUTTERFREE",
                    "WEEDLE",
                    "KAKUNA",
                    "BEEDRILL",
                    "PIDGEY",
                    "PIDGEOTTO",
                    "PIDGEOT",
                    "RATTATA",
                    "RATICATE",
                    "SPEAROW",
                    "FEAROW",
                    "EKANS",
                    "ARBOK",
                    "PIKACHU",
                    "RAICHU",
                    "SANDSHREW",
                    "SANDSLASH",
                    "NIDORAN_FEMALE",
                    "NIDORINA",
                    "NIDOQUEEN",
                    "NIDORAN_MALE",
                    "NIDORINO",
                    "NIDOKING",
                    "CLEFAIRY",
                    "CLEFABLE",
                    "VULPIX",
                    "NINETALES",
                    "JIGGLYPUFF",
                    "WIGGLYTUFF",
                    "ZUBAT",
                    "GOLBAT",
                    "ODDISH",
                    "GLOOM",
                    "VILEPLUME",
                    "PARAS",
                    "PARASECT",
                    "VENONAT",
                    "VENOMOTH",
                    "DIGLETT",
                    "DUGTRIO",
                    "MEOWTH",
                    "PERSIAN",
                    "PSYDUCK",
                    "GOLDUCK",
                    "MANKEY",
                    "PRIMEAPE",
                    "GROWLITHE",
                    "ARCANINE",
                    "POLIWAG",
                    "POLIWHIRL",
                    "POLIWRATH",
                    "ABRA",
                    "KADABRA",
                    "ALAKAZAM",
                    "MACHOP",
                    "MACHOKE",
                    "MACHAMP",
                    "BELLSPROUT",
                    "WEEPINBELL",
                    "VICTREEBEL",
                    "TENTACOOL",
                    "TENTACRUEL",
                    "GEODUDE",
                    "GRAVELER",
                    "GOLEM",
                    "PONYTA",
                    "RAPIDASH",
                    "SLOWPOKE",
                    "SLOWBRO",
                    "MAGNEMITE",
                    "MAGNETON",
                    "FARFETCHD",
                    "DODUO",
                    "DODRIO",
                    "SEEL",
                    "DEWGONG",
                    "GRIMER",
                    "MUK",
                    "SHELLDER",
                    "CLOYSTER",
                    "GASTLY",
                    "HAUNTER",
                    "GENGAR",
                    "ONIX",
                    "DROWZEE",
                    "HYPNO",
                    "KRABBY",
                    "KINGLER",
                    "VOLTORB",
                    "ELECTRODE",
                    "EXEGGCUTE",
                    "EXEGGUTOR",
                    "CUBONE",
                    "MAROWAK",
                    "HITMONLEE",
                    "HITMONCHAN",
                    "LICKITUNG",
                    "KOFFING",
                    "WEEZING",
                    "RHYHORN",
                    "RHYDON",
                    "CHANSEY",
                    "TANGELA",
                    "KANGASKHAN",
                    "HORSEA",
                    "SEADRA",
                    "GOLDEEN",
                    "SEAKING",
                    "STARYU",
                    "STARMIE",
                    "MR_MIME",
                    "SCYTHER",
                    "JYNX",
                    "ELECTABUZZ",
                    "MAGMAR",
                    "PINSIR",
                    "TAUROS",
                    "MAGIKARP",
                    "GYARADOS",
                    "LAPRAS",
                    "DITTO",
                    "EEVEE",
                    "VAPOREON",
                    "JOLTEON",
                    "FLAREON",
                    "PORYGON",
                    "OMANYTE",
                    "OMASTAR",
                    "KABUTO",
                    "KABUTOPS",
                    "AERODACTYL",
                    "SNORLAX",
                    "ARTICUNO",
                    "ZAPDOS",
                    "MOLTRES",
                    "DRATINI",
                    "DRAGONAIR",
                    "DRAGONITE",
                    "MEWTWO",
                    "MEW"]
        // 返回
        return nums
    }()
}
class CustomPointAnnotation: MKPointAnnotation {
    var imageName: String!
}