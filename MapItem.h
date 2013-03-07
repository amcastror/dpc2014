//
//  MapItem.h
//  diaPatrimonio
//
//  Created by Matias Castro on 23-02-13.
//  Copyright (c) 2013 Matias Castro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MapItem : NSObject<MKAnnotation>{
    
	NSString *title;
	NSString *subtitle;
    
    NSString *nombre;
    CLLocationCoordinate2D coordinate;
}

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

@property (nonatomic, readonly) NSString *nombre;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

-(id) initWithCoordinate:(CLLocationCoordinate2D)_coordenadas AndNombre:(NSString *)_nombre;

@end
