//
//  ArtikelViewController.h
//  Webmontag
//
//  Erstellt von Johannes Jakob am 15.03.2015
//  ©2015 Johannes Jakob
//

// Header für News-Artikel

#import <UIKit/UIKit.h>
#import <Social/Social.h>  // Importiere Klasse für soziale Netzwerke (Twitter + Facebook)
#import <MessageUI/MessageUI.h>  // Importiere Klasse für Mail + Nachrichten

// UIActionSheetDelegate für Anzeigen der Teilen-Optionen notwenig; MFMailComposeViewControllerDelegate für das Teilen per Mail notwendig; MFMessageComposeViewControllerDelegate für das Teilen per Nachrichten notwendig; UIWebViewDelegate für erweiterte Funktionen in einer UIWebView notwendig

@interface ArtikelViewController : UIViewController <UIActionSheetDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate, UIWebViewDelegate> {
    IBOutlet UIWebView *ArtikelWebView;  // Deklariere ArtikelWebView als IBOutlet
    IBOutlet UIActivityIndicatorView *ActivityIndicator;  // Deklariere ActivityIndicator als IBOutlet (UIActivityIndicatorView = Ladeanimation)
}

- (IBAction)Action:(id)sender;  // Deklariere Action als IBAction (wird beim Antippen auf den Teilen-Button aufgerufen)

@end
