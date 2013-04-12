//
//  ViewPuntoMapa.h
//  DiaDelPatrimonio
//
//  Created by Matias Castro on 12-04-13.
//  Copyright (c) 2013 Matias Castro. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "PuntoCultural.h"

@interface ViewPuntoMapa : MKAnnotationView{
    PuntoCultural *punto;
}

@property (nonatomic, readwrite) PuntoCultural *punto;

- (id)initWithPunto:(PuntoCultural *)_punto;

@end
