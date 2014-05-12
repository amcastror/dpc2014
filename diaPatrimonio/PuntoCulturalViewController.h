//
//  PuntoCulturalViewController.h
//  diaPatrimonio
//
//  Created by Matias Castro on 23-02-13.
//  Copyright (c) 2013 Matias Castro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"
#import "PuntoCultural.h"
#import "ImagenAsincrona.h"
#import "DejarComentarioViewController.h"
#import "TTTAttributedLabel.h"

@interface PuntoCulturalViewController : GAITrackedViewController <ComentarDelegate, TTTAttributedLabelDelegate>{
    IBOutlet UIButton *botonAccionPunto;
    IBOutlet UIButton *botonCompartir;
    IBOutlet UIButton *botonComentar;
    IBOutlet UIScrollView *scroll;
    
    IBOutlet UIView *boxDireccionView;
    IBOutlet UIView *boxHorarioView;
    IBOutlet UIView *boxWebView;
    
    IBOutlet UILabel *boxDireccionLabel;
    IBOutlet UILabel *boxHorarioLabel;
    IBOutlet TTTAttributedLabel *boxWebTTTLabel;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil AndPuntoCultural:(PuntoCultural *)_puntoCultural;
@end
