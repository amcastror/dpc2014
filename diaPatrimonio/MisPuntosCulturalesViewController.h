//
//  MisPuntosCulturalesViewController.h
//  diaPatrimonio
//
//  Created by Matias Castro on 08-03-13.
//  Copyright (c) 2013 Matias Castro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MisPuntosCulturalesViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>{
    IBOutlet UIView *vistaSinPuntos;
}

@property (nonatomic, retain) IBOutlet UITableView *tablaPuntosCulturales;
@property (strong, nonatomic) IBOutlet UITableViewCell *filaPuntoCultural;

@end
