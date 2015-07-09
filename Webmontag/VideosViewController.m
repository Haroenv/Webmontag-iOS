//
//  VideosViewController.m
//  Webmontag
//
//  Erstellt von Johannes Jakob am 15.03.2015
//  ©2015 Johannes Jakob
//

// Main für Videos

#import "VideosViewController.h"
#import "Reachability.h"  // Importiere Klasse zum Überprüfen der Internetverbindung

@interface VideosViewController () {
    // Deklariere Objekte und Variablen für das Parsen des RSS-Feeds
    
    NSXMLParser *Parser;  // XML-Parser
    NSMutableArray *Feed;  // Array, welches nach dem Parsen alle benötigten Informationen zu den Videos enthält (enthält Dictionarys, welche Strings mit den Informationen enthalten)
    NSMutableDictionary *Item;  // Dictionary, in welchem der Titel, die Beschreibung und der Link des Videos gesichert werden
    NSMutableString *Title;  // Hilfsvariable für Titel des Videos
    NSMutableString *Description;  // Hilfsvariable für Beschreibung des Videos
    NSMutableString *VideoID;  // Hilfsvariable für ID des Videos
    NSString *Element;  // Hilfsvariable für aktuelles XML-Element
}

@end

@implementation VideosViewController

- (void)viewDidLoad {  // Wird nach dem Laden der View aufgerufen
    [super viewDidLoad];
    
    // Erstelle leere View, die als tableFooterView dient, damit keine leeren Tabellen-Zellen angezeigt werden
    
    UIView *TableViewFooter = [[UIView alloc] initWithFrame:(CGRectZero)];
    self.tableView.tableFooterView = TableViewFooter;
    
    // Erstelle refreshControl, damit Tabelle aktualisiert werden kann (ruft Funktion RefreshTable auf)
    
    UIRefreshControl *RefreshControl = [[UIRefreshControl alloc] init];
    [RefreshControl addTarget:self action:@selector(RefreshTable) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = RefreshControl;
    
    // Deklariere Objekte zur Überprüfung der Internetverbindung
    
    Reachability *InternetReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus NetworkStatus = [InternetReachability currentReachabilityStatus];
    
    if (NetworkStatus == NotReachable) {  // Wenn keine Internetverbindung besteht
        // Erstelle UITextView, die Text "Keine Internetverbindung" enthält und als tableFooterView verwendet wird (bei fehlender Internetverbindung wird nur die UITextView angezeigt)
        
        UITextView *NoInternetTextView = [[UITextView alloc] initWithFrame:CGRectMake(5, 0, 290, 100)];
        NoInternetTextView.text = @"Keine Internetverbindung";
        NoInternetTextView.textColor = [UIColor grayColor];
        NoInternetTextView.font = [UIFont systemFontOfSize:20];
        NoInternetTextView.editable = false;
        NoInternetTextView.scrollEnabled = false;
        self.tableView.tableFooterView = NoInternetTextView;
        
        // Zeige Fehlermeldung
        
        UIAlertView *NoInternetAlertView = [[UIAlertView alloc] initWithTitle:@"Keine Internetverbindung" message:@"Es besteht keine Verbindung zum Internet. Bitte überprüfe Deine Einstellungen." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [NoInternetAlertView show];
    } else {  // Wenn Internetverbindung besteht
        Feed = [[NSMutableArray alloc] init];  // Initialisiere Array Feed (zurücksetzen)
        NSURL *FeedURL = [NSURL URLWithString:@"https://www.youtube.com/feeds/videos.xml?channel_id=UCTDokvo5VUEjfDxi_mLqMKg"];  // Deklariere URL als URL für XML-Parser
        Parser = [[NSXMLParser alloc] initWithContentsOfURL:FeedURL];  // Initialisiere XML-Parser mit URL
        [Parser setDelegate:self];  // Setze Delegate des XML-Parsers auf sich selbst
        [Parser setShouldResolveExternalEntities:NO];
        [Parser parse];  // Beginne das Parsen
    }
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {  // Wird aufgerufen, wenn XML-Parser ein neues XML-Element begonnen hat
    Element = elementName;  // Sichere Namen des XML-Elements in Hilfsvariable
    
    if ([Element isEqualToString:@"entry"]) {  // Wenn Element == "entry" (entry entspricht einem Video)
        // Initialisiere folgende Objekte (zurücksetzen)
        
        Item = [[NSMutableDictionary alloc] init];
        Title = [[NSMutableString alloc] init];
        Description = [[NSMutableString alloc] init];
        VideoID = [[NSMutableString alloc] init];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {  // Wird aufgerufen, wenn XML-Parser Text in einem Element findet (z.B. <title>Gefundener Titel</title>)
    if ([Element isEqualToString:@"title"]) {  // Wenn Element == "title"
        [Title appendString:string];  // Sichere gefundenen Text in Title
    } else if ([Element isEqualToString:@"media:description"]) {  // Wenn Element == "media:description"
        [Description appendString:string];  // Sichere gefundenen Text in Description
    } else if ([Element isEqualToString:@"yt:videoId"]) {  // Wenn Element == "yt:videoId"
        [VideoID appendString:string];  // Sichere gefundenen Text in VideoID
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {  // Wird aufgerufen, wenn XML-Parser das Dokument beendet hat
    if ([elementName isEqualToString:@"entry"]) {  // Wenn Element == "entry" (Wenn Video abgeschlossen)
        // Sichere Titel, Beschreibung und ID des Videos in Dictionary und füge dieses dem Array hinzu
        
        Item[@"title"] = Title;
        Item[@"media:description"] = Description;
        Item[@"yt:videoId"] = VideoID;
        [Feed addObject:[Item copy]];
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {  // Wird aufgerufen, wenn XML-Parser das Dokument beendet hat
    [self.tableView reloadData];  // Lade Tabelleninhalt neu
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {  // Anzahl der Sektionen in der Tabelle (1)
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {  // Anzahl der Reihen in der Tabelle (Anzahl der Videos)
    return Feed.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {  // Wird für jede Tabellen-Zelle aufgerufen (indexPath.row = Position der Zelle)
    UITableViewCell *TableViewCell = [tableView dequeueReusableCellWithIdentifier:@"VideosCell" forIndexPath:indexPath];  // Deklariere Tabellen-Zelle als Zelle der Tabelle mit der ID "VideosCell" (im Storyboard festgelegt)
    
    // Ändere Text der Tabellen-Zelle zu Wert mit entsprechendem Schlüssel im Dictionary an der Stelle indexPath.row und lege die Schriftfarbe für das Antippen fest
    
    TableViewCell.textLabel.text = Feed[indexPath.row][@"title"];
    TableViewCell.textLabel.highlightedTextColor = [UIColor whiteColor];
    TableViewCell.detailTextLabel.text = Feed[indexPath.row][@"media:description"];
    TableViewCell.detailTextLabel.highlightedTextColor = [UIColor whiteColor];
    
    // Erstelle View mit grünem Hintergrund und lege sie als Hintergrund-View für angetippte Tabellen-Zellen fest
        
    UIView *TableViewCellSelection = [[UIView alloc] init];
    TableViewCellSelection.backgroundColor = [UIColor colorWithRed:0 green:0.75 blue:0.474 alpha:1];
    [TableViewCell setSelectedBackgroundView:TableViewCellSelection];
    
    return TableViewCell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {  // Wird aufgerufen, wenn ein Wechsel zu einer anderen View bevorsteht
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    NSString *VideoTitel = (Feed[indexPath.row])[@"title"];
    VideoTitel = [VideoTitel stringByReplacingOccurrencesOfString:@"\n" withString:@""];  // Entferne Escape-Zeichen
    VideoTitel = [VideoTitel substringToIndex:[VideoTitel length] - 2];
    NSString *VideoIDString = (Feed[indexPath.row])[@"yt:videoId"];
    VideoIDString = [VideoIDString stringByReplacingOccurrencesOfString:@"\n" withString:@""];  // Entferne Escape-Zeichen
    VideoIDString = [VideoIDString substringToIndex:[VideoIDString length] - 2];
    NSString *VideoURL = [NSString stringWithFormat:@"http://youtube.com/watch?v=%@", VideoIDString];  // URL wird mithilfe der Video-ID erstellt
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:VideoTitel forKey:@"VideoTitel"];
    [defaults setObject:VideoURL forKey:@"VideoURL"];
    [defaults synchronize];
}

- (void)RefreshTable {  // Wird aufgerufen, wenn refreshControl verwendet wird
    // Wiederhole Vorgang aus der Funktion viewDidLoad, damit neu geparst und die Tabelle aktualisiert wird
    
    Reachability *InternetReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus NetworkStatus = [InternetReachability currentReachabilityStatus];
    
    if (NetworkStatus == NotReachable) {
        Feed = [[NSMutableArray alloc] init];
        
        [self.tableView reloadData];
        
        UITextView *NoInternetTextView = [[UITextView alloc] initWithFrame:CGRectMake(5, 0, 290, 100)];
        NoInternetTextView.text = @"Keine Internetverbindung";
        NoInternetTextView.textColor = [UIColor grayColor];
        NoInternetTextView.font = [UIFont systemFontOfSize:20];
        NoInternetTextView.editable = false;
        NoInternetTextView.scrollEnabled = false;
        self.tableView.tableFooterView = NoInternetTextView;
        
        UIAlertView *NoInternetAlertView = [[UIAlertView alloc] initWithTitle:@"Keine Internetverbindung" message:@"Es besteht keine Verbindung zum Internet. Bitte überprüfe Deine Einstellungen." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [NoInternetAlertView show];
    } else {
        UIView *TableViewBackground = [[UIView alloc] initWithFrame:(CGRectZero)];
        self.tableView.tableFooterView = TableViewBackground;
        
        Feed = [[NSMutableArray alloc] init];
        NSURL *FeedURL = [NSURL URLWithString:@"https://www.youtube.com/feeds/videos.xml?channel_id=UCTDokvo5VUEjfDxi_mLqMKg"];
        Parser = [[NSXMLParser alloc] initWithContentsOfURL:FeedURL];
        [Parser setDelegate:self];
        [Parser setShouldResolveExternalEntities:NO];
        [Parser parse];
    }
    
    [self.refreshControl endRefreshing];  // Stoppe refreshControl
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
