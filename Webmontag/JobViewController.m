//
//  JobViewController.m
//  Webmontag
//
//  Erstellt von Johannes Jakob am 05.04.2015
//  ©2015 Johannes Jakob
//

#import "JobViewController.h"

@interface JobViewController ()

@end

@implementation JobViewController

- (void)viewDidLoad {  // Wird nach dem Laden der View aufgerufen
    [super viewDidLoad];
    
    // Erhalte die Werte für die in der Jobs-View gesicherten Informationen zum Job
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *JobTitel = [defaults objectForKey:@"JobTitel"];
    NSString *JobURL = [defaults objectForKey:@"JobURL"];
    
    self.navigationItem.title = JobTitel;  // Setze den Titel des Artikels als Titel des navigationItems (Titelleiste)
    
    // Lade den Job in der JobWebView
    
    JobWebView.delegate = self;
    [JobWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@#main", JobURL]]]];
}

- (IBAction)Action:(id)sender {  // Wird aufgerufen, wenn der Teilen-Button angetippt wird
    // Erstelle ein UIActionSheet mit den Optionen "Twitter", "Facebook", "Mail", "Nachrichten" und "In Safari öffnen" und zeige es
    
    UIActionSheet *ActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Abbrechen" destructiveButtonTitle:nil otherButtonTitles:@"Twitter", @"Facebook", @"Mail", @"Nachrichten", @"In Safari öffnen", nil];
    [ActionSheet showFromTabBar:self.tabBarController.tabBar];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {  // Wird aufgerufen, wenn eine Option im UIActionSheet angetippt wird
    // Erhalte die Werte für die in der Jobs-View gesicherten Informationen zum Job
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *JobTitel = [defaults objectForKey:@"JobTitel"];
    NSString *JobURL = [defaults objectForKey:@"JobURL"];
    
    if (buttonIndex == 0) {  // Wenn angetippte Option an Position 0
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {  // Wenn Twitter verfügbar
            // Erstelle einen SLComposeViewController mit dem Titel und Link des Jobs als Inhalt für den Dienst Twitter
            
            SLComposeViewController *TwitterController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
            [TwitterController setInitialText:JobTitel];
            [TwitterController addURL:[NSURL URLWithString:JobURL]];
            [self presentViewController:TwitterController animated:YES completion:nil];
        } else {  // Wenn Twitter nicht verfügbar
            // Zeige Fehlermeldung
            
            UIAlertView *NoService = [[UIAlertView alloc] initWithTitle:@"Fehler" message:@"Twitter ist nicht verfügbar. Überprüfen Sie Ihre Zugangsdaten und Interneteinstellungen." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [NoService show];
        }
    } else if (buttonIndex == 1) {  // Wenn angetippte Option an Position 1
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {  // Wenn Facebook verfügbar
            // Erstelle einen SLComposeViewController mit dem Titel und Link des Jobs als Inhalt für den Dienst Facebook
            
            SLComposeViewController *FacebookController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
            [FacebookController setInitialText:JobTitel];
            [FacebookController addURL:[NSURL URLWithString:JobURL]];
            [self presentViewController:FacebookController animated:YES completion:nil];
        } else {  // Wenn Facebook nicht verfügbar
            // Zeige Fehlermeldung
            UIAlertView *NoService = [[UIAlertView alloc] initWithTitle:@"Fehler" message:@"Facebook ist nicht verfügbar. Überprüfen Sie Ihre Zugangsdaten und Interneteinstellungen." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [NoService show];
        }
    } else if (buttonIndex == 2) { // Wenn angetippte Option an Position 2
        if ([MFMailComposeViewController canSendMail]) {  // Wenn Gerät E-Mails senden kann
            // Erstelle neue E-Mail mit dem Titel des Jobs als Betreff und dem Link als Nachricht
            
            MFMailComposeViewController *MailViewController = [[MFMailComposeViewController alloc] init];
            MailViewController.mailComposeDelegate = self;
            [MailViewController setSubject:JobTitel];
            [MailViewController setMessageBody:JobURL isHTML:YES];
            [MailViewController setToRecipients:[NSArray arrayWithObjects:nil]];
            [self presentViewController:MailViewController animated:YES completion:NULL];
        } else {  // Wenn Gerät keine E-Mails senden kann
            // Zeige Fehlermeldung
            
            UIAlertView *CannotSendMailAlertView = [[UIAlertView alloc] initWithTitle:@"Fehler" message:@"Das Gerät kann keine E-Mails senden." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [CannotSendMailAlertView show];
        }
    } else if (buttonIndex == 3) {  // Wenn angetippte Option an Position 3
        if ([MFMessageComposeViewController canSendText]) {  // Wenn Gerät Nachrichten senden kann
            // Erstelle neue Nachricht mit dem Link des Jobs als Nachricht
            
            MFMessageComposeViewController *MessageViewController = [[MFMessageComposeViewController alloc] init];
            MessageViewController.messageComposeDelegate = self;
            [MessageViewController setBody:JobURL];
            [MessageViewController setRecipients:[NSArray arrayWithObjects:nil]];
            [self presentViewController:MessageViewController animated:YES completion:NULL];
        } else {  // Wenn Gerät keine Nachrichten senden kann
            // Zeige Fehlermeldung
            
            UIAlertView *CannotSendMessageAlertView = [[UIAlertView alloc] initWithTitle:@"Fehler" message:@"Das Gerät kann keine Nachrichten senden." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [CannotSendMessageAlertView show];
        }
    } else if (buttonIndex == 4) {  // Wenn angetippte Option an Position 4
        // Öffne Link des Jobs in App, die das Protokoll des Links verwendet (Safari)
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:JobURL]];
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {  // Wenn Verfassen der E-Mail abgeschlossen (gesendet oder angebrochen)
    [self dismissViewControllerAnimated:YES completion:NULL];  // Schließe MFMailComposeViewController
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {  // Wenn Verfassen der Nachricht abgeschlossen (gesendet oder abgebrochen)
    [self dismissViewControllerAnimated:YES completion:NULL];  // Schließe MFMessageComposeViewController
}
        
- (void)webViewDidStartLoad:(UIWebView *)webView {  // Wenn UIWebView (Delegate) mit Laden begonnen hat
    [ActivityIndicator startAnimating];  // Animiere ActivityIndicator
}
        
- (void)webViewDidFinishLoad:(UIWebView *)webView {  // Wenn UIWebView (Delegate) mit dem Laden abgeschlossen hat
    [ActivityIndicator stopAnimating];  // Stoppe ActivityIndicator
}
        
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {  // Wenn UIWebView (Delegate) das Laden abgebrochen hat
    [ActivityIndicator stopAnimating];  // Stoppe ActivityIndicator
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
