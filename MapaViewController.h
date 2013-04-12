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
    IBOutlet UIButton *botonBuscarAqui;
    IBOutlet UIButton *boton_aperturas;
    IBOutlet UIButton *boton_recorridos;
    IBOutlet UIButton *boton_rutas;
    IBOutlet UIButton *boton_actividades;
}

@property (nonatomic, readonly) IBOutlet UIButton *botonBuscarAqui;

@end
