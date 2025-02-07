# payment_tracking

A new Flutter project.

## Getting Started
```
    rm -R ~/Library/Developer/CoreSimulator/Caches
    open -a Simulator
    flutter run
```
### Journal
#### Oct 9 2023
After striking out with Firebase app distribution tool I found an easier way to beta test on my iPhone by using App Store Connect and TestFlight. Followed along with this guide, which isn't terribly dated: https://iqan.medium.com/releasing-flutter-ios-app-to-testflight-using-xcode-21571299dbc3

The only difference in these steps is that I opted, for the moment, to only upload for internal teting purposes. It looks like ASC manages the certificate: https://developer.apple.com/account/resources/certificates/ (Testflight Provisioning Profile)

The general process is something like this:
* Run 'flutter build ios'.
* Once that build is done, go to Product > Archive in the xCode UI.  
* Select 'Distribute App' in the archive window, and choose Testflight/internal testing only.
* Once that build is done, it should be available here: https://appstoreconnect.apple.com/apps/6468968760/testflight/ios 
* "Internal Testing Group" should get email to install latest build on personal phone via locally installed Testflight app. 
