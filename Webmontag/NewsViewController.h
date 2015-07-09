//
//  NewsViewController.h
//  Webmontag
//
//  Erstellt von Johannes Jakob am 15.03.2015
//  ©2015 Johannes Jakob
//

// Header für News

#import <UIKit/UIKit.h>

@interface NewsViewController : UITableViewController <NSXMLParserDelegate>  // NSXMLParserDelegate für XML-Parser notwendig

@property (strong, nonatomic) IBOutlet UITableView *NewsTableView;  // Deklariere NewsTableView als IBOutlet

@end
