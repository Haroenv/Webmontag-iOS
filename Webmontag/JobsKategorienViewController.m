//
//  JobsKategorienViewController.m
//  Webmontag
//
//  Erstellt von Johannes Jakob am 05.04.2015
//  ©2015 Johannes Jakob
//

// Main für Jobs-Kategorien

#import "JobsKategorienViewController.h"

// Definiere Vergleiche von Betriebssystem-Versionen

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

@interface JobsKategorienViewController ()

@end

@implementation JobsKategorienViewController

- (void)viewDidLoad {  // Wird nach dem Laden der View aufgerufen
    [super viewDidLoad];
    
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) { // Wenn iOS-Version < 7.0
        // Setze Schriftfarbe der angetippten Tabellen-Zellen
        
        FreelanceTableViewCell.textLabel.highlightedTextColor = [UIColor whiteColor];
        PraktikumTableViewCell.textLabel.highlightedTextColor = [UIColor whiteColor];
        ProjektbezogenTableViewCell.textLabel.highlightedTextColor = [UIColor whiteColor];
        TeilzeitTableViewCell.textLabel.highlightedTextColor = [UIColor whiteColor];
        VollzeitTableViewCell.textLabel.highlightedTextColor = [UIColor whiteColor];
        
        // Setze Symbol der angetippten Tabellen-Zellen
        
        FreelanceTableViewCell.imageView.highlightedImage = [UIImage imageNamed:@"FreelanceSelected.png"];
        PraktikumTableViewCell.imageView.highlightedImage = [UIImage imageNamed:@"PraktikumSelected.png"];
        ProjektbezogenTableViewCell.imageView.highlightedImage = [UIImage imageNamed:@"ProjektbezogenSelected.png"];
        TeilzeitTableViewCell.imageView.highlightedImage = [UIImage imageNamed:@"TeilzeitSelected.png"];
        VollzeitTableViewCell.imageView.highlightedImage = [UIImage imageNamed:@"VollzeitSelected.png"];
    }
    
    // Erhalte die in den NSUserDefaults gesicherten Werte für die Kategorien
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    bool Freelance = [defaults boolForKey:@"Freelance"];
    bool Praktikum = [defaults boolForKey:@"Praktikum"];
    bool Projektbezogen = [defaults boolForKey:@"Projektbezogen"];
    bool Teilzeit = [defaults boolForKey:@"Teilzeit"];
    bool Vollzeit = [defaults boolForKey:@"Vollzeit"];
    
    // Setze an alle ausgewählten Kategorien Häkchen
    
    if (!Freelance) {
        FreelanceTableViewCell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    if (!Praktikum) {
        PraktikumTableViewCell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    if (!Projektbezogen) {
        ProjektbezogenTableViewCell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    if (!Teilzeit) {
        TeilzeitTableViewCell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    if (!Vollzeit) {
        VollzeitTableViewCell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {  // Wird aufgerufen, wenn Tabellen-Zelle angetippt wird
    [tableView deselectRowAtIndexPath:indexPath animated:YES];  // Wähle angetippte Tabellen-Zelle ab
    
    UITableViewCell *Cell = [tableView cellForRowAtIndexPath:indexPath];  // Deklariere Cell als angetippte Tabellen-Zelle
    
    // Erhalte die in den NSUserDefaults gesicherten Werte für die Kategorien
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    bool Freelance = [defaults boolForKey:@"Freelance"];
    bool Praktikum = [defaults boolForKey:@"Praktikum"];
    bool Projektbezogen = [defaults boolForKey:@"Projektbezogen"];
    bool Teilzeit = [defaults boolForKey:@"Teilzeit"];
    bool Vollzeit = [defaults boolForKey:@"Vollzeit"];
    
    // Überprüfe Position der angetippten Tabellen-Zelle und ändere die Auswahl der jewwiligen Kategorie inklusive Häkchen an der Tabellen-Zelle (da die Werte in den NSUserDefaults gesichert werden, beim ersten Verwenden der App aber noch nicht gesetzt sind, der Standardwert für die Variable bool allerdings false ist, wird das Ausgewähltsein einer Kategorie mit false und das Nichtausgewähltsein einer Kategorie mit true beschrieben)
    
    switch (indexPath.row) {
        case 0:
            if (!Freelance) {
                if (Praktikum && Projektbezogen && Teilzeit && Vollzeit) {
                    UIAlertView *LastCategory = [[UIAlertView alloc] initWithTitle:@"Achtung" message:@"Eine Kategorie muss aktiviert bleiben." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    [LastCategory show];
                } else {
                    Cell.accessoryType = UITableViewCellAccessoryNone;
                    
                    Freelance = !Freelance;
                    [defaults setBool:Freelance forKey:@"Freelance"];
                }
            } else {
                Cell.accessoryType = UITableViewCellAccessoryCheckmark;
                
                Freelance = !Freelance;
                [defaults setBool:Freelance forKey:@"Freelance"];
            }
            break;
        case 1:
            if (!Praktikum) {
                if (Freelance && Projektbezogen && Teilzeit && Vollzeit) {
                    UIAlertView *LastCategory = [[UIAlertView alloc] initWithTitle:@"Achtung" message:@"Eine Kategorie muss aktiviert bleiben." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    [LastCategory show];
                } else {
                    Cell.accessoryType = UITableViewCellAccessoryNone;
                    
                    Praktikum = !Praktikum;
                    [defaults setBool:Praktikum forKey:@"Praktikum"];
                }
            } else {
                Cell.accessoryType = UITableViewCellAccessoryCheckmark;
                
                Praktikum = !Praktikum;
                [defaults setBool:Praktikum forKey:@"Praktikum"];
            }
            break;
        case 2:
            if (!Projektbezogen) {
                if (Freelance && Praktikum && Teilzeit && Vollzeit) {
                    UIAlertView *LastCategory = [[UIAlertView alloc] initWithTitle:@"Achtung" message:@"Eine Kategorie muss aktiviert bleiben." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    [LastCategory show];
                } else {
                    Cell.accessoryType = UITableViewCellAccessoryNone;
                    
                    Projektbezogen = !Projektbezogen;
                    [defaults setBool:Projektbezogen forKey:@"Projektbezogen"];
                }
            } else {
                Cell.accessoryType = UITableViewCellAccessoryCheckmark;
                
                Projektbezogen = !Projektbezogen;
                [defaults setBool:Projektbezogen forKey:@"Projektbezogen"];
            }
            break;
        case 3:
            if (!Teilzeit) {
                if (Freelance && Praktikum && Projektbezogen && Vollzeit) {
                    UIAlertView *LastCategory = [[UIAlertView alloc] initWithTitle:@"Achtung" message:@"Eine Kategorie muss aktiviert bleiben." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    [LastCategory show];
                } else {
                    Cell.accessoryType = UITableViewCellAccessoryNone;
                    
                    Teilzeit = !Teilzeit;
                    [defaults setBool:Teilzeit forKey:@"Teilzeit"];
                }
            } else {
                Cell.accessoryType = UITableViewCellAccessoryCheckmark;
                
                Teilzeit = !Teilzeit;
                [defaults setBool:Teilzeit forKey:@"Teilzeit"];
            }
            break;
        case 4:
            if (!Vollzeit) {
                if (Freelance && Praktikum && Projektbezogen && Teilzeit) {
                    UIAlertView *LastCategory = [[UIAlertView alloc] initWithTitle:@"Achtung" message:@"Eine Kategorie muss aktiviert bleiben." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    [LastCategory show];
                } else {
                    Cell.accessoryType = UITableViewCellAccessoryNone;
                    
                    Vollzeit = !Vollzeit;
                    [defaults setBool:Vollzeit forKey:@"Vollzeit"];
                }
            } else {
                Cell.accessoryType = UITableViewCellAccessoryCheckmark;
                
                Vollzeit = !Vollzeit;
                [defaults setBool:Vollzeit forKey:@"Vollzeit"];
            }
            break;
        default:
            break;
    }
    
    [defaults synchronize];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
