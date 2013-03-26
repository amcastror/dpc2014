//
//  BuscadorPuntosCulturalesViewController.m
//  diaPatrimonio
//
//  Created by Matias Castro on 23-02-13.
//  Copyright (c) 2013 Matias Castro. All rights reserved.
//

#import "BuscadorPuntosCulturalesViewController.h"

@interface BuscadorPuntosCulturalesViewController ()

@end

@implementation BuscadorPuntosCulturalesViewController

@synthesize botonCancelar;

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

- (IBAction)botonCancelarPressed:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}

@end
