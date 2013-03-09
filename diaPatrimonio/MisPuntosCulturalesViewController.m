//
//  MisPuntosCulturalesViewController.m
//  diaPatrimonio
//
//  Created by Matias Castro on 08-03-13.
//  Copyright (c) 2013 Matias Castro. All rights reserved.
//

#import "MisPuntosCulturalesViewController.h"

@interface MisPuntosCulturalesViewController ()

@end

@implementation MisPuntosCulturalesViewController

@synthesize tablaPuntosCulturales, filaPuntoCultural;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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


@end
