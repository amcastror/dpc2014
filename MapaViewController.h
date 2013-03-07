//
//  MapaViewController.h
//  diaPatrimonio
//
//  Created by Matias Castro on 22-02-13.
//  Copyright (c) 2013 Matias Castro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MapaViewController : UIViewController <MKMapViewDelegate>{
    IBOutlet MKMapView *mapa;
}

@end
