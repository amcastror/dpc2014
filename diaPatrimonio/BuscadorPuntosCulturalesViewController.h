//
//  BuscadorPuntosCulturalesViewController.h
//  diaPatrimonio
//
//  Created by Matias Castro on 23-02-13.
//  Copyright (c) 2013 Matias Castro. All rights reserved.
//

#import <UIKit/UIKit.h>
enum Busqueda
{
    BUSQUEDA_ZONAS,
    BUSQUEDA_SUB_ZONAS,
    BUSQUEDA_CATEGORIAS,
    BUSQUEDA_NO
};
typedef enum Busqueda Busqueda;

@interface BuscadorPuntosCulturalesViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>{
    IBOutlet UIButton *botonCancelar;
    IBOutlet UIButton *botonBuscar;
    IBOutlet UIButton *botonZonas;
    IBOutlet UIButton *botonSubZonas;
    IBOutlet UIButton *botonCategorias;
    IBOutlet UITextField *textoABuscar;
    IBOutlet UIPickerView *picker;
    IBOutlet UIView *pickerView;
    IBOutlet UILabel *busqueda;
    Busqueda tipoBusqueda;
}

@property (nonatomic, readonly) IBOutlet UIButton *botonCancelar;
@property (nonatomic, readonly) IBOutlet UIButton *botonBuscar;
@property (nonatomic, readonly) IBOutlet UIButton *botonZonas;
@property (nonatomic, readonly) IBOutlet UIButton *botonSubZonas;
@property (nonatomic, readonly) IBOutlet UIButton *botonCategorias;
@property (nonatomic, readonly) IBOutlet UITextField *textoABuscar;

@end
