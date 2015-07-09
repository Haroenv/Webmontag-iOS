//
//  JobsKategorienViewController.h
//  Webmontag
//
//  Erstellt von Johannes Jakob am 05.04.2015
//  ©2015 Johannes Jakob
//

// Header für Jobs-Kategorien

#import <UIKit/UIKit.h>

@interface JobsKategorienViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource> {  // UITableViewDelegate und UITableViewDataSource für UITableView notwendig
    // Deklariere UITableViewCells als IBOutlets
    
    IBOutlet UITableViewCell *FreelanceTableViewCell;
    IBOutlet UITableViewCell *PraktikumTableViewCell;
    IBOutlet UITableViewCell *ProjektbezogenTableViewCell;
    IBOutlet UITableViewCell *TeilzeitTableViewCell;
    IBOutlet UITableViewCell *VollzeitTableViewCell;
}

@end
