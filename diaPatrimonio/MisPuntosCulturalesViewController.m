//
//  MisPuntosCulturalesViewController.m
//  diaPatrimonio
//
//  Created by Matias Castro on 08-03-13.
//  Copyright (c) 2013 Matias Castro. All rights reserved.
//

#import "MisPuntosCulturalesViewController.h"
#import "MisPuntosCulturales.h"

@interface MisPuntosCulturalesViewController ()

@end

@implementation MisPuntosCulturalesViewController

@synthesize tablaPuntosCulturales, filaPuntoCultural;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"Mis puntos culturales", @"Mis puntos culturales");
        [[MisPuntosCulturales instance] requestMisPuntosCulturalesWithSuccess:^(NSArray *puntosCulturales) {
           
        } AndFail:^(NSError *error) {
            
        }];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark table delegate functions

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[MisPuntosCulturales instance] misPuntosCulturales] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *MyIdentifier = @"MyIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"filaPuntoCultural" owner:self options:nil];
        cell = self.filaPuntoCultural;
        self.filaPuntoCultural = nil;
    }
    
    return cell;
    
}

@end
