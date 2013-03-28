//
//  PuntoCulturalViewController.m
//  diaPatrimonio
//
//  Created by Matias Castro on 23-02-13.
//  Copyright (c) 2013 Matias Castro. All rights reserved.
//

#import "PuntoCulturalViewController.h"

@interface PuntoCulturalViewController (){
    PuntoCultural *puntoCultural;
}

@end

@implementation PuntoCulturalViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil AndPuntoCultural:(PuntoCultural *)_puntoCultural;
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"Ficha Cultural", @"Ficha Cultural");
        self.hidesBottomBarWhenPushed = YES;
        puntoCultural = _puntoCultural;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSLog(@"punto: %@", puntoCultural);
    
    [puntoCultural requestCompletarInformacionWithSuccess:^{
        resumen.text = [NSString stringWithFormat:@"id: %@, nombre: %@, descripción: %@, lat: %@, long: %@", puntoCultural.id_punto, puntoCultural.nombre, puntoCultural.descripcion, puntoCultural.latitud, puntoCultural.longitud];
        if (puntoCultural.url_foto) {
            
            ImagenAsincrona *foto = [[ImagenAsincrona alloc] initWithFrame:CGRectMake(40, 30, 240, 120) AndURL:[NSString stringWithFormat:@"http://%@", puntoCultural.url_foto] AndStartNow:YES];
            [self.view addSubview:foto];
        }
    } AndFail:^(NSError *error) {
        //
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
