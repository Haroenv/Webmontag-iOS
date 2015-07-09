//
//  NewsViewController.m
//  Webmontag
//
//  Erstellt von Johannes Jakob am 15.03.2015
//  ©2015 Johannes Jakob
//

// Main für News

#import "NewsViewController.h"
#import "Reachability.h"  // Importiere Klasse zum Überprüfen der Internetverbindung

@interface NewsViewController () {
    // Deklariere Objekte und Variablen für das Parsen des RSS-Feeds
    
    NSXMLParser *Parser;  // XML-Parser
    NSMutableArray *Feed;  // Array, welches nach dem Parsen alle benötigten Informationen zu den Artikeln enthält (enthält Dictionarys, welche Strings mit den Informationen enthalten)
    NSMutableDictionary *Item;  // Dictionary, in welchem der Titel, die Beschreibung und der Link des Artikels gesichert werden
    NSMutableString *Title;  // Hilfsvariable für Titel des Artikels
    NSMutableString *Description;  // Hilfsvariable für Beschreibung des Artikels
    NSMutableString *Link;  // Hilfsvariable für Link des Artikels
    NSString *Element;  // Hilfsvariable für aktuelles XML-Element
}

@end

@implementation NewsViewController

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
        NSURL *FeedURL = [NSURL URLWithString:@"http://webwirtschaft.net/feed"];  // Deklariere URL als URL für XML-Parser
        Parser = [[NSXMLParser alloc] initWithContentsOfURL:FeedURL];  // Initialisiere XML-Parser mit URL
        [Parser setDelegate:self];  // Setze Delegate des XML-Parsers auf sich selbst
        [Parser setShouldResolveExternalEntities:NO];
        [Parser parse];  // Beginne das Parsen
    }
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {  // Wird aufgerufen, wenn XML-Parser ein neues XML-Element begonnen hat
    Element = elementName;  // Sichere Namen des XML-Elements in Hilfsvariable
    
    if ([Element isEqualToString:@"item"]) {  // Wenn Element == "item" (item entspricht einem Artikel)
        // Initialisiere folgende Objekte (zurücksetzen)
        
        Item = [[NSMutableDictionary alloc] init];
        Title = [[NSMutableString alloc] init];
        Description = [[NSMutableString alloc] init];
        Link = [[NSMutableString alloc] init];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {  // Wird aufgerufen, wenn XML-Parser Text in einem Element findet (z.B. <title>Gefundener Text</title>)
    if ([Element isEqualToString:@"title"]) {  // Wenn Element == "title"
        [Title appendString:string];  // Sichere gefundenen Text in Title
    } else if ([Element isEqualToString:@"description"]) {  // Wenn Element == "description"
        // Erstelle Scanner und Hilfsvariable, um HTML-Tags zu entfernen
        
        NSScanner *HTMLTagsScanner;
        NSString *HTMLTag;
        HTMLTagsScanner = [NSScanner scannerWithString:string];
        while ([HTMLTagsScanner isAtEnd] == NO) {
            [HTMLTagsScanner scanUpToString:@"<" intoString:NULL];
            [HTMLTagsScanner scanUpToString:@">" intoString:&HTMLTag];
            string = [string stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>", HTMLTag] withString:@""];
        }
        
        [Description appendString:string];  // Sichere gefundenen und bereinigten Text in Description
    } else if ([Element isEqualToString:@"link"]) {  // Wenn Element == "link"
        [Link appendString:string];  // Sichere gefundenen Text in Link
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {  // Wird aufgerufen, wenn XML-Parser ein XML-Element beendet hat
    if ([elementName isEqualToString:@"item"]) {  // Wenn Element == "item" (Wenn Artikel abgeschlossen)
        // Sichere Titel, Beschreibung und Link des Artikels in Dictionaray und füge dieses dem Array hinzu
        
        Item[@"title"] = Title;
        Item[@"description"] = Description;
        Item[@"link"] = Link;
        [Feed addObject:[Item copy]];
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {  // Wird aufgerufen, wenn XML-Parser das Dokument beendet hat
    [self.tableView reloadData];  // Lade Tabelleninhalt neu
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {  // Anzahl der Sektionen in der Tabelle (1)
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {  // Anzahl der Reihen in der Tabelle (Anzahl der Artikel)
    return Feed.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {  // Wird für jede Tabellen-Zelle aufgerufen (indexPath.row = Position der Zelle)
    UITableViewCell *TableViewCell = [tableView dequeueReusableCellWithIdentifier:@"NewsCell" forIndexPath:indexPath];  // Deklariere Tabellen-Zelle als Zelle der Tabelle mit der ID "NewsCell" (im Storyboard festgelegt)
    
    // Ändere Text der Tabellen-Zelle zu Wert mit entsprechendem Schlüssel im Dictionary an der Stelle indexPath.row und lege die Schriftfarbe für das Antippen fest
    
    TableViewCell.textLabel.text = Feed[indexPath.row][@"title"];
    TableViewCell.textLabel.highlightedTextColor = [UIColor whiteColor];
    TableViewCell.detailTextLabel.text = Feed[indexPath.row][@"description"];
    TableViewCell.detailTextLabel.highlightedTextColor = [UIColor whiteColor];
    
    // Erstelle View mit grünem Hintergrund und lege sie als Hintergrund-View für angetippte Tabellen-Zellen fest
    
    UIView *TableViewCellSelection = [[UIView alloc] init];
    TableViewCellSelection.backgroundColor = [UIColor colorWithRed:0 green:0.75 blue:0.474 alpha:1];
    [TableViewCell setSelectedBackgroundView:TableViewCellSelection];
    
    return TableViewCell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {  // Wird aufgerufen, wenn ein Wechsel zu einer anderen View bevorsteht
    // Sichere Titel und Link des angetippten Artikels in den NSUserDefaults, damit diese Informationen in der Artikel-View genutzt werden können
    
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    NSString *ArtikelTitel = (Feed[indexPath.row])[@"title"];
    ArtikelTitel = [ArtikelTitel stringByReplacingOccurrencesOfString:@"\n\t\t" withString:@""];  // Entferne Escape-Zeichen
    NSString *ArtikelURL = (Feed[indexPath.row])[@"link"];
    ArtikelURL = [ArtikelURL stringByReplacingOccurrencesOfString:@"\n\t\t" withString:@""];  // Entferne Escape-Zeichen
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:ArtikelTitel forKey:@"ArtikelTitel"];
    [defaults setObject:ArtikelURL forKey:@"ArtikelURL"];
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
        NSURL *FeedURL = [NSURL URLWithString:@"http://webwirtschaft.net/feed"];
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
