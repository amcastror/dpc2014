//
//  ViewPuntoMapa.m
//  DiaDelPatrimonio
//
//  Created by Matias Castro on 12-04-13.
//  Copyright (c) 2013 Matias Castro. All rights reserved.
//

#import "ViewPuntoMapa.h"

@implementation ViewPuntoMapa

@synthesize punto;

- (id)initWithPunto:(PuntoCultural *)_punto
{
    self = [super init];
    if (self) {
        punto = _punto;
        [self dibujaVista];
    }
    return self;
}

- (void) dibujaVista{
    CGRect frame = self.frame;
    frame.size = CGSizeMake(35,29);
    self.frame = frame;
    
    UIImageView *pin = [[UIImageView alloc] initWithFrame:frame];
    [self addSubview:pin];
    
    self.backgroundColor = [UIColor clearColor];
    switch ([punto.id_tipo intValue]) {
        case TIPO_APERTURA:
            pin.image = [UIImage imageNamed:@"icono-categoria-aper-"];
            break;
        case TIPO_RECORRIDO_GUIADO:
            pin.image = [UIImage imageNamed:@"icono-categoria-reco-"];
            break;
        case TIPO_RUTA_TEMATICA:
            pin.image = [UIImage imageNamed:@"icono-categoria-ruta-"];
            break;
        case TIPO_ACTIVIDAD:
            pin.image = [UIImage imageNamed:@"icono-categoria-act-"];
            break;
        case TIPO_OTRO:
            pin.image = [UIImage imageNamed:@"icono-categoria-otro-"];
            break;
            
        default:
            break;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
