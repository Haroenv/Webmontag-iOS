//
//  MehrViewController.m
//  Webmontag
//
//  Erstellt von Johannes Jakob am 16.03.2015
//  ©2015 Johannes Jakob
//

// Main für Mehr

#import "MehrViewController.h"

// Definiere Vergleiche von Betriebssystem-Versionen

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

@interface MehrViewController ()

@end

@implementation MehrViewController

- (void)viewDidLoad {  // Wird nach dem Laden der View aufgerufen
    [super viewDidLoad];
    
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {  // Wenn iOS-Version < 7.0
        // Setze Schriftfarbe der ausgewählten Tabellen-Zellen
        
        SupportMailTableViewCell.textLabel.highlightedTextColor = [UIColor whiteColor];
        ReviewTableViewCell.textLabel.highlightedTextColor = [UIColor whiteColor];
        CopyrightTableViewCell.textLabel.highlightedTextColor = [UIColor whiteColor];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {  // Wird aufgerufen, wenn Tabellen-Zelle angetippt wird
    if (indexPath.section == 1) {  // Wenn Tabellen-Sektion == 1
        if (indexPath.row == 0) {  // Wenn Position der Tabellen-Zelle == 0
            [tableView deselectRowAtIndexPath:indexPath animated:YES];  // Wähle angetippte Tabellen-Zelle ab
            
            if ([MFMailComposeViewController canSendMail]) {  // Wenn Gerät E-Mails senden kann
                // Erstelle neue E-Mail für "Support-E-Mail schreiben"
                
                MFMailComposeViewController *SupportMailViewController = [[MFMailComposeViewController alloc] init];
                SupportMailViewController.mailComposeDelegate = self;
                [SupportMailViewController setSubject:@"Webmontag (iOS)"];
                [SupportMailViewController setMessageBody:@"" isHTML:YES];
                [SupportMailViewController setToRecipients:[NSArray arrayWithObjects:@"johannes.jakob@elg-halle.de", nil]];
                [self presentViewController:SupportMailViewController animated:YES completion:NULL];
            } else {  // Wenn Gerät keine E-Mails senden kann
                // Zeige Fehlermeldung
                
                UIAlertView *CannotSendMailAlertView = [[UIAlertView alloc] initWithTitle:@"Gerät kann keine E-Mails senden" message:@"Das Gerät kann keine E-Mails senden." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [CannotSendMailAlertView show];
            }
        } else if (indexPath.row == 1) {  // Wenn Position der Tabellen-Zelle == 1
            [tableView deselectRowAtIndexPath:indexPath animated:YES];  // Wähle angetippte Tabellen-Zelle ab
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://AppStore.com/Webmontag"]];  // Navigiere zur Webmontag-App im App Store
        }
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {  // Wenn Verfassen der E-Mail abgeschlossen (gesendet oder abgebrochen)
    [self dismissViewControllerAnimated:YES completion:NULL];  // Schließe MFMailComposeViewController
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
