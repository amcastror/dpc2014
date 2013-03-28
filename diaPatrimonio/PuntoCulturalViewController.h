//
//  PuntoCulturalViewController.h
//  diaPatrimonio
//
//  Created by Matias Castro on 23-02-13.
//  Copyright (c) 2013 Matias Castro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PuntoCultural.h"
#import "ImagenAsincrona.h"

@interface PuntoCulturalViewController : UIViewController{
    IBOutlet UILabel *resumen;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil AndPuntoCultural:(PuntoCultural *)_puntoCultural;
@end
