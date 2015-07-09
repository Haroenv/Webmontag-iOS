//
//  MehrViewController.h
//  Webmontag
//
//  Erstellt von Johannes Jakob am 16.03.2015
//  ©2015 Johannes Jakob
//

// Header für Mehr

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>  // Importiere Klasse für Mail + Nachrichten

@interface MehrViewController : UITableViewController <MFMailComposeViewControllerDelegate, UITableViewDelegate, UITableViewDataSource> {
    IBOutlet UITableViewCell *SupportMailTableViewCell;  // Deklariere SupportMailTableViewCell als IBOutlet
    IBOutlet UITableViewCell *ReviewTableViewCell;  // Deklariere ReviewTableViewCell als IBOutlet
    IBOutlet UITableViewCell *CopyrightTableViewCell;  // Deklariere CopyrightTableViewCell als IBOutlet
}

@end
