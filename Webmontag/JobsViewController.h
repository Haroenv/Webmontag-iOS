//
//  JobsViewController.h
//  Webmontag
//
//  Erstellt von Johannes Jakob am 05.04.2015
//  ©2015 Johannes Jakob
//

// Header für Jobs

#import <UIKit/UIKit.h>

@interface JobsViewController : UITableViewController <NSXMLParserDelegate>  // NSXMLParserDelegate für XML-Parser notwendig

@property (strong, nonatomic) IBOutlet UITableView *JobsTableView;  // Deklariere JobsTableView als IBOutlet

@end
