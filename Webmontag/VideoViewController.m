//
//  VideoViewController.m
//  Webmontag
//
//  Erstellt von Johannes Jakob am 15.03.2015
//  ©2015 Johannes Jakob
//

// Main für Video

#import "VideoViewController.h"

@interface VideoViewController ()

@end

@implementation VideoViewController

- (void)viewDidLoad {  // Wird nach dem Laden der View aufgerufen
    [super viewDidLoad];
    
    // Erhalte die Werte für die in der Videos-View gesicherten Informationen zum Video
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *VideoTitel = [defaults objectForKey:@"VideoTitel"];
    NSString *VideoURL = [defaults objectForKey:@"VideoURL"];
    
    self.navigationItem.title = VideoTitel;  // Setze den Titel des Videos als Titel des navigationItems (Titelleiste)
    
    // Lade das Video in der VideoWebView
    
    VideoWebView.delegate = self;
    [VideoWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:VideoURL]]];
}

- (IBAction)Action:(id)sender {  // Wird aufgerufen, wenn der Teilen-Button angetippt wird
    // Erstelle ein UIActionSheet mit den Optionen "Twitter", "Facebook", "Mail", "Nachrichten" und "In Safari öffnen" und zeige es
    
    UIActionSheet *ActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Abbrechen" destructiveButtonTitle:nil otherButtonTitles:@"Twitter", @"Facebook", @"Mail", @"Nachrichten", @"In Safari öffnen", nil];
    [ActionSheet showFromTabBar:self.tabBarController.tabBar];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {   // Wird aufgerufen, wenn eine Option im UIActionSheet angetippt wird
    // Erhalte die Werte für die in der Videos-View gesicherten Informationen zum Video
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *VideoTitel = [defaults objectForKey:@"VideoTitel"];
    NSString *VideoURL = [defaults objectForKey:@"VideoURL"];
    
    if (buttonIndex == 0) {  // Wenn angetippte Option an Position 0
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {  // Wenn Twitter verfügbar
            // Erstelle einen SLComposeViewController mit dem Titel und Link des Videos als Inhalt für den Dienst Twitter
            
            SLComposeViewController *TwitterController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
            [TwitterController setInitialText:VideoTitel];
            [TwitterController addURL:[NSURL URLWithString:VideoURL]];
            [self presentViewController:TwitterController animated:YES completion:nil];
        } else {  // Wenn Twitter nicht verfügbar
            // Zeige Fehlermeldung
            
            UIAlertView *NoService = [[UIAlertView alloc] initWithTitle:@"Fehler" message:@"Twitter ist nicht verfügbar. Überprüfen Sie Ihre Zugangsdaten und Interneteinstellungen." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [NoService show];
        }
    } else if (buttonIndex == 1) {  // Wenn angetippte Option an Position 1
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {  // Wenn Facebook verfügbar
            // Erstelle einen SLComposeViewController mit dem Titel und Link des Videos als Inhalt für den Dienst Facebook
            
            SLComposeViewController *FacebookController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
            [FacebookController setInitialText:VideoTitel];
            [FacebookController addURL:[NSURL URLWithString:VideoURL]];
            [self presentViewController:FacebookController animated:YES completion:nil];
        } else {  // Wenn Facebook nicht verfügbar
            // Zeige Fehlermeldung
            
            UIAlertView *NoService = [[UIAlertView alloc] initWithTitle:@"Fehler" message:@"Facebook ist nicht verfügbar. Überprüfen Sie Ihre Zugangsdaten und Interneteinstellungen." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [NoService show];
        }
    } else if (buttonIndex == 2) { // Wenn angetippte Option an Position 2
        if ([MFMailComposeViewController canSendMail]) {  // Wenn Gerät E-Mails senden kann
            // Erstelle neue E-Mail mit dem Titel des Videos als Betreff und dem Link als Nachricht
            
            MFMailComposeViewController *MailViewController = [[MFMailComposeViewController alloc] init];
            MailViewController.mailComposeDelegate = self;
            [MailViewController setSubject:VideoTitel];
            [MailViewController setMessageBody:VideoURL isHTML:YES];
            [MailViewController setToRecipients:[NSArray arrayWithObjects:nil]];
            [self presentViewController:MailViewController animated:YES completion:NULL];
        } else {  // Wenn Gerät keine E-Mails senden kann
            // Zeige Fehlermeldung
            
            UIAlertView *CannotSendMailAlertView = [[UIAlertView alloc] initWithTitle:@"Fehler" message:@"Das Gerät kann keine E-Mails senden." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [CannotSendMailAlertView show];
        }
    } else if (buttonIndex == 3) {  // Wenn angetippte Option an Position 3
        if ([MFMessageComposeViewController canSendText]) {  // Wenn Gerät Nachrichten senden kann
            // Erstelle neue Nachricht mit dem Link des Videos als Nachricht
            
            MFMessageComposeViewController *MessageViewController = [[MFMessageComposeViewController alloc] init];
            MessageViewController.messageComposeDelegate = self;
            [MessageViewController setBody:VideoURL];
            [MessageViewController setRecipients:[NSArray arrayWithObjects:nil]];
            [self presentViewController:MessageViewController animated:YES completion:NULL];
        } else {  // Wenn Gerät keine Nachrichten senden kann
            // Zeige Fehlermeldung
            
            UIAlertView *CannotSendMessageAlertView = [[UIAlertView alloc] initWithTitle:@"Fehler" message:@"Das Gerät kann keine Nachrichten senden." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [CannotSendMessageAlertView show];
        }
    } else if (buttonIndex == 4) {  // Wenn angetippte Option an Position 4
        // Öffne Link des Videos in App, die das Protokoll des Links verwendet (Safari)
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:VideoURL]];
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
