//
//  TableViewController.m
//  ConnectTheDots
//
//  Created by NSSimpleApps on 15.05.15.
//  Copyright (c) 2015 NSSimpleApps. All rights reserved.
//

#import "TableViewController.h"
#import "MasterViewController.h"
#import "DataTransferProtocol.h"
#import "DataObject.h"
#import "DataManager.h"
#import "SettingsManager.h"

@interface TableViewCell : UITableViewCell

@end

@implementation TableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    
    return self;
}
@end

@interface TableViewController () <DataTransferProtocol>

@property (strong, nonatomic) NSMutableArray<DataObject *> *dataObjects;
@property (strong, nonatomic) NSArray<NSString *> *figures;
@property (nullable, copy, nonatomic) NSIndexPath *selectedIndexPath;

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Select any figure";
    [self.tableView registerClass:[TableViewCell class] forCellReuseIdentifier:@"TableViewCell"];
    
    self.dataObjects = [NSMutableArray array];
    self.figures = @[@"figure1.json", @"figure2.json"];
    
    for (NSString *figure in self.figures) {
        [self.dataObjects addObject:[[DataManager shared] loadDataObjectFromJSON:figure]];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DataObject *dataObject = self.dataObjects[indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCell" forIndexPath:indexPath];
    cell.textLabel.text = dataObject.name;
    
    BOOL result = dataObject.points.count == [[SettingsManager shared] indexForKey:self.figures[indexPath.row]];
    
    if (result) {
        cell.detailTextLabel.text = @"Finished";
        cell.detailTextLabel.textColor = [UIColor greenColor];
        
    } else {
        cell.detailTextLabel.text = @"Unfinished";
        cell.detailTextLabel.textColor = [UIColor redColor];
    }
    cell.imageView.image = [[SettingsManager shared] imageForKey:self.figures[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedIndexPath = indexPath;
    NSInteger row = self.selectedIndexPath.row;
    
    MasterViewController *masterViewController = [[MasterViewController alloc] initWithNibName:nil bundle:nil];
    masterViewController.title = self.dataObjects[row].name;
    masterViewController.points = self.dataObjects[row].points;
    masterViewController.bezierPath = [[SettingsManager shared] bezierPathForKey:self.figures[row]];
    masterViewController.index = [[SettingsManager shared] indexForKey:self.figures[row]];
    masterViewController.delegate = self;
    
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:masterViewController];
    nc.modalPresentationStyle = UIModalPresentationFullScreen;
    
    [self presentViewController:nc animated:YES completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

#pragma mark - DataTransferProtocol

- (void)gameDidFinishWithIndex:(NSInteger)index
                         image:(nullable UIImage *)image
                    bezierPath:(UIBezierPath *)bezierPath {
    if (self.selectedIndexPath != nil) {
        NSString *figure = self.figures[self.selectedIndexPath.row];
        
        [[SettingsManager shared] setIndex:index forKey:figure];
        [[SettingsManager shared] setImage:image forKey:figure];
        [[SettingsManager shared] setBezierPath:bezierPath forKey:figure];
        
        [self.tableView reloadRowsAtIndexPaths:@[self.selectedIndexPath]
                              withRowAnimation:UITableViewRowAnimationAutomatic];
        
        self.selectedIndexPath = nil;
    }
}

@end
