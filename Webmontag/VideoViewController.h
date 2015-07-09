//
//  VideoViewController.h
//  Webmontag
//
//  Erstellt von Johannes Jakob am 15.03.2015
//  ©2015 Johannes Jakob
//

// Header für Video

#import <UIKit/UIKit.h>
#import <Social/Social.h>  // Importiere Klasse für soziale Netzwerke (Twitter + Facebook)
#import <MessageUI/MessageUI.h>  // Importiere Klasse für Mail + Nachrichten

// UIActionSheetDelegate für Anzeigen der Teilen-Optionen notwenig; MFMailComposeViewControllerDelegate für das Teilen per Mail notwendig; MFMessageComposeViewControllerDelegate für das Teilen per Nachrichten notwendig; UIWebViewDelegate für erweiterte Funktionen in einer UIWebView notwendig

@interface VideoViewController : UIViewController <UIActionSheetDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate, UIWebViewDelegate> {
    IBOutlet UIWebView *VideoWebView;  // Deklariere VideoWebView als IBOutlet
    IBOutlet UIActivityIndicatorView *ActivityIndicator;  // Deklariere ActivityIndicator als IBOutlet (UIActivityIndicator = Ladeanimation)
}

- (IBAction)Action:(id)sender;  // Deklariere Action als IBAction (wird beim Antippen auf den Teilen-Button aufgerufen)

@end
