import Flutter
import UIKit
import UserNotifications
import file_picker
import flutter_secure_storage
import image_picker
import orb
import package_info_plus
import path_provider
import url_launcher


@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    lazy var engine: FlutterEngine = FlutterEngine(name: "demo")
    lazy var orb: Orb = Orb(engine: engine)

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        launchOrb()
        registerForPushNotifications()
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    override func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable: Any],
        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
    ) {
        if
            let aps = userInfo["aps"] as? [String: AnyObject],
            let meyaIntegrationId = userInfo["meya_integration_id"] as? String
        {
            // Handle Meya notifications
            print(meyaIntegrationId)
            print(aps)
            if
                let alert = aps["alert"] as? [String: AnyObject],
                let title = alert["title"],
                let body = alert["body"]
            {
                sendNotification(title: title as! String, body: body as! String)
            }
        } else {
            completionHandler(.failed)
            return
        }
    }
    
    override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data)}
        let token = tokenParts.joined()
        print("Device Token: \(token)")
        orb.deviceToken = token
    }
    
    override func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] granted, _ in
            print("Permission granted: \(granted)")
            guard granted else { return }
            self?.getNotificationSettings()
        }
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    func sendNotification(title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default
        content.categoryIdentifier = "MEYA_ORB"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1.0, repeats: false)
        let request = UNNotificationRequest(
            identifier: "MEYA_ORB",
            content: content,
            trigger: trigger
        )

        let center =  UNUserNotificationCenter.current()
        center.add(request) { (error) in
            if error != nil {
                print("Notification error: \(String(describing: error))")
            }
        }
    }
    
    override func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.badge, .sound, .alert])
    }
    
    override func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let userInfo = response.notification.request.content.userInfo
        
        // Handle Meya local notification action
        if let _ = userInfo["meya_integration_id"] {
            launchOrb()
        }
        
        completionHandler()
    }
    
    func launchOrb() {
        initialize()
        
        let platformVersion = "iOS " + UIDevice.current.systemVersion
        let connectionOptions = OrbConnectionOptions(
            gridUrl: "https://grid.meya.ai",
            appId: "app-73c6d31d4f544a72941e21fb518b5737",
            integrationId: "integration.orb.mobile",
            pageContext: [
                "platform_version": platformVersion,
                "a": 1234,
                "data": [
                    "key1": "value1",
                    "key2": 123123.3,
                    "bool": true
                ]
            ] as [String: Any?]
        )
        let config = OrbConfig(
            theme: OrbTheme(
                brandColor: "#691ac9"
            ),
            composer: OrbComposer(
                placeholderText: "Enter text here...",
                collapsePlaceholderText: "Anything else to say?",
                fileButtonText: "File",
                fileSendText: "Send ",
                imageButtonText: "Photo",
                cameraButtonText: "Camera",
                galleryButtonText: "Gallery"
            ),
            splash: OrbSplash(
                readyText: "Example app is ready..."
            )            
        )
        
        if (!orb.ready) {
            orb.onReady {
                self.orb.configure(config: config)
                self.orb.connect(options: connectionOptions)
            }
        } else {
            self.orb.configure(config: config)
            self.orb.connect(options: connectionOptions)
        }
        orb.onConnnected {
            print("Orb connected.")
        }
        orb.onDisconnected {
            print("Orb disconnected.")
        }
        orb.onCloseUi {
            print("Close orb view controller")
            // Close the app
            UIControl().sendAction(
                #selector(NSXPCConnection.suspend),
                to: UIApplication.shared, for: nil
            )
        }
        self.window.rootViewController = FlutterViewController(engine: engine, nibName: nil, bundle: nil)
    }

    public func initialize() {
        // Start the Flutter engine
        engine.run()

        // Register all required Flutter plugins
        if let registrar = engine.registrar(forPlugin: "OrbPlugin") {
            OrbPlugin.register(with: registrar)
        }
        if let registrar = engine.registrar(forPlugin: "FilePickerPlugin") {
            FilePickerPlugin.register(with: registrar)
        }
        if let registrar = engine.registrar(forPlugin: "FlutterSecureStoragePlugin") {
            FlutterSecureStoragePlugin.register(with: registrar)
        }
        if let registrar = engine.registrar(forPlugin: "FLTImagePickerPlugin") {
            FLTImagePickerPlugin.register(with: registrar)
        }
        if let registrar = engine.registrar(forPlugin: "FLTPackageInfoPlusPlugin") {
            FLTPackageInfoPlusPlugin.register(with: registrar)
        }
        if let registrar = engine.registrar(forPlugin: "FLTPathProviderPlugin") {
            FLTPathProviderPlugin.register(with: registrar)
        }
        if let registrar = engine.registrar(forPlugin: "FLTURLLauncherPlugin") {
            FLTURLLauncherPlugin.register(with: registrar)
        }

        orb.initCallbacks()
    }
}
