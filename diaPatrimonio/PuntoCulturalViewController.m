//
//  PuntoCulturalViewController.m
//  diaPatrimonio
//
//  Created by Matias Castro on 23-02-13.
//  Copyright (c) 2013 Matias Castro. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "PuntoCulturalViewController.h"
#import "MisPuntosCulturales.h" 
#import "ShareViewController.h"
#import "Filtros.h"
#import "DejarComentarioViewController.h"
#import "ComentariosViewController.h"
#import "Comentario.h"
#import "GAI.h"
#import "GAITracker.h"

#define bordeInferior 5
#define fuenteTitulo [UIFont fontWithName:@"HelveticaNeue-Light" size:21]
#define fuenteZona [UIFont fontWithName:@"HelveticaNeue-Light" size:14]
#define fuenteCategoria [UIFont fontWithName:@"HelveticaNeue-Light" size:16.0f]
#define fuenteDescripciones [UIFont fontWithName:@"HelveticaNeue-Light" size:18]
#define fuenteInformacion [UIFont systemFontOfSize:17.0]
#define fuenteTituloComentarios [UIFont fontWithName:@"HelveticaNeue-Light" size:18]
#define fuenteNombreComentarios [UIFont fontWithName:@"HelveticaNeue-Light" size:12]
#define fuenteFecha [UIFont systemFontOfSize:12.0]
#define fuenteBotonTituloLargo [UIFont fontWithName:@"HelveticaNeue-Medium" size:11]
#define fuenteBotonTituloCorto [UIFont fontWithName:@"HelveticaNeue-Medium" size:13]

#define colorCategoria [UIColor colorWithRed: 100.0/255.0 green: 100.0/255.0 blue: 100.0/255.0 alpha: 1.0]
#define colorTitulo [UIColor colorWithRed: 22.0/255.0 green: 82.0/255.0 blue: 158.0/255.0 alpha: 1.0]
#define colorZona [UIColor colorWithRed: 100.0/255.0 green: 100.0/255.0 blue: 100.0/255.0 alpha: 1.0]
#define colorDescripciones [UIColor colorWithRed: 90.0/255.0 green: 90.0/255.0 blue: 90.0/255.0 alpha: 1.0]
#define colorInformacion [UIColor colorWithRed: 20.0/255.0 green: 20.0/255.0 blue: 100.0/255.0 alpha: 1.0]
#define colorComentarios [UIColor colorWithRed: 235.0/255.0 green: 235.0/255.0 blue: 235.0/255.0 alpha: 1.0]
#define colorTituloComentarios [UIColor colorWithRed: 90.0/255.0 green: 90.0/255.0 blue: 90.0/255.0 alpha: 1.0]
#define colorNombreComentarios [UIColor colorWithRed: 100.0/255.0 green: 100.0/255.0 blue: 100.0/255.0 alpha: 1.0]
#define colorFecha [UIColor colorWithRed: 100.0/255.0 green: 100.0/255.0 blue: 100.0/255.0 alpha: 1.0]

@interface PuntoCulturalViewController (){
    PuntoCultural *puntoCultural;
    int largoActualFicha;
    UIView *viewComentarios;
}

@end

@implementation PuntoCulturalViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil AndPuntoCultural:(PuntoCultural *)_puntoCultural;
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        puntoCultural = _puntoCultural;
        largoActualFicha = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.trackedViewName = @"punto_cultural";
    botonAccionPunto.layer.cornerRadius = 3;
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"cargando..."];
    [puntoCultural requestCompletarInformacionWithSuccess:^{
        [self actualizaDisplay];
        [DejalBezelActivityView removeViewAnimated:YES];
    } AndFail:^(NSError *error) {
        [DejalBezelActivityView removeViewAnimated:YES];
    }];
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self actualizaDisplayBotonAccion];
    [self.navigationItem setHidesBackButton:YES];
    
    //Left bar button like back button item.
    UIImage *backImage = [UIImage imageNamed:@"dpc-nav-bar-back"];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.bounds = CGRectMake( 0, 0, backImage.size.width, backImage.size.height );
    [backButton setImage:backImage forState:UIControlStateNormal];
    [backButton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backBarButtonItem;

}

#pragma mark - funciones display

-(void) actualizaDisplay{
    //imagen
    if (puntoCultural.url_foto) {
        ImagenAsincrona *foto = [[ImagenAsincrona alloc] initWithFrame:CGRectMake(0, 0, 320, 180) AndURL:puntoCultural.url_foto AndStartNow:YES];
        foto.backgroundColor = [UIColor clearColor];
        largoActualFicha = 180 + bordeInferior;
        [self actualizaLargoScroll];
        [scroll addSubview:foto];
        largoActualFicha += 10;
    }
    
    // imagen categoria
    
    UIImageView *icono_categoria = [[UIImageView alloc] initWithFrame:CGRectMake(20, largoActualFicha, 22, 20)];
    
    //Label categoria
    
    UILabel *label_categoria = [[UILabel alloc] initWithFrame:CGRectMake(50, largoActualFicha, 200, 20)];
    label_categoria.backgroundColor = [UIColor clearColor];
    label_categoria.font = fuenteCategoria;
    label_categoria.textColor = colorCategoria;
    
    switch (puntoCultural.id_tipo.intValue) {
        case TIPO_APERTURA:
            icono_categoria.image = [UIImage imageNamed:@"icono-categoria-apertura-02"];
            label_categoria.text = @"Apertura";
            break;
        case TIPO_RECORRIDO_GUIADO:
            icono_categoria.image = [UIImage imageNamed:@"icono-categoria-recorrido-02"];
            label_categoria.text = @"Recorrido guiado";
            break;
        case TIPO_RUTA_TEMATICA:
            icono_categoria.image = [UIImage imageNamed:@"icono-categoria-rutas-02"];
            label_categoria.text = @"Ruta temática";
            break;
        case TIPO_ACTIVIDAD:
            icono_categoria.image = [UIImage imageNamed:@"icono-categoria-actividad-02"];
            label_categoria.text = @"Actividad";
            break;
            
        default:
            break;
    }
    
    
    largoActualFicha = icono_categoria.frame.origin.y + icono_categoria.frame.size.height + bordeInferior;
    [self actualizaLargoScroll];
    [scroll addSubview:icono_categoria];
    [scroll addSubview:label_categoria];

    //titulo
    
    CGSize size_nombre = [puntoCultural.nombre sizeWithFont:fuenteTitulo
                                          constrainedToSize:CGSizeMake(280, 100000)
                                              lineBreakMode:NSLineBreakByTruncatingTail];
    UILabel *nombre = [[UILabel alloc] initWithFrame:CGRectMake(20, largoActualFicha, 280, size_nombre.height)];
    nombre.text = puntoCultural.nombre;
    nombre.numberOfLines = 0;
    nombre.font = fuenteTitulo;
    nombre.textColor = colorTitulo;
    nombre.backgroundColor = [UIColor clearColor];
    
    largoActualFicha = nombre.frame.origin.y + nombre.frame.size.height + bordeInferior;
    [self actualizaLargoScroll];
    [scroll addSubview:nombre];
    
    //separador
    
    UIImageView *separador = [[UIImageView alloc] initWithFrame:CGRectMake(0, largoActualFicha, 320, 2)];
    separador.image = [UIImage imageNamed:@"ficha-linea-punto-01"];
    
    largoActualFicha = largoActualFicha + bordeInferior;
    [self actualizaLargoScroll];
    [scroll addSubview:separador];
    
    //zona y sub zona
    NSString *string_zona = [NSString stringWithFormat:@"%@ | %@",
                             [[[Filtros instance] nombreZonaConIDSubZona:puntoCultural.id_sub_zona] uppercaseString],
                             [[[Filtros instance] nombreSubZonaConIDSubZona:puntoCultural.id_sub_zona] uppercaseString]];
    CGSize size_zona = [string_zona sizeWithFont:fuenteZona
                                          constrainedToSize:CGSizeMake(280, 100000)
                                              lineBreakMode:NSLineBreakByTruncatingTail];
    UILabel *zona = [[UILabel alloc] initWithFrame:CGRectMake(20, largoActualFicha, 280, size_zona.height)];
    zona.text = string_zona;
    zona.font = fuenteZona;
    zona.textColor = colorZona;
    zona.backgroundColor = [UIColor clearColor];
    zona.numberOfLines = 0;
    largoActualFicha = zona.frame.origin.y + zona.frame.size.height + bordeInferior;
    [self actualizaLargoScroll];
    [scroll addSubview:zona];
    
    //separador
    
    UIImageView *separador2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, largoActualFicha, 320, 2)];
    separador2.image = [UIImage imageNamed:@"ficha-linea-punto-01"];
    
    largoActualFicha = largoActualFicha + 15;
    [self actualizaLargoScroll];
    [scroll addSubview:separador2];

    //Descripción corta
    
    CGSize size_descripcion_corta = [puntoCultural.descripcion sizeWithFont:fuenteDescripciones
                                                          constrainedToSize:CGSizeMake(280, 100000)
                                                              lineBreakMode:NSLineBreakByTruncatingTail];
    UILabel *descripcion_corta = [[UILabel alloc] initWithFrame:CGRectMake(20, largoActualFicha, 280, size_descripcion_corta.height)];
    descripcion_corta.text = puntoCultural.descripcion;
    descripcion_corta.font = fuenteDescripciones;
    descripcion_corta.textColor = colorDescripciones;
    descripcion_corta.backgroundColor = [UIColor clearColor];
    descripcion_corta.numberOfLines = 0;
    descripcion_corta.lineBreakMode = UILineBreakModeWordWrap;
    
    largoActualFicha = descripcion_corta.frame.origin.y + descripcion_corta.frame.size.height;
    [self actualizaLargoScroll];
    [scroll addSubview:descripcion_corta];
    
    //Dirección
    
    largoActualFicha += 15;
    CGSize size_direccion = [puntoCultural.direccion sizeWithFont:fuenteInformacion
                                          constrainedToSize:CGSizeMake(boxDireccionLabel.frame.size.width, 100000)
                                              lineBreakMode:NSLineBreakByTruncatingTail];
    
    CGRect frameBoxDireccionLabel = boxDireccionLabel.frame;
    frameBoxDireccionLabel.size.height = size_direccion.height;
    boxDireccionLabel.frame = frameBoxDireccionLabel;
    
    //UILabel *direccion = [[UILabel alloc] initWithFrame:CGRectMake(20, largoActualFicha, 280, size_direccion.height)];
    boxDireccionLabel.text = puntoCultural.direccion;
    boxDireccionLabel.font = fuenteInformacion;
    boxDireccionLabel.textColor = colorInformacion;
    boxDireccionLabel.backgroundColor = [UIColor clearColor];
    boxDireccionLabel.numberOfLines = 0;
    
    CGRect frameBoxDireccionView = boxDireccionView.frame;
    frameBoxDireccionView.origin.y = largoActualFicha;
    frameBoxDireccionView.size.height = boxDireccionLabel.frame.origin.y + boxDireccionLabel.frame.size.height + 3;
    boxDireccionView.frame = frameBoxDireccionView;
    boxDireccionView.hidden = NO;
    
    largoActualFicha = boxDireccionView.frame.origin.y + boxDireccionView.frame.size.height;
    [self actualizaLargoScroll];
    //[scroll addSubview:direccion];
    
    //Horarios, sitio web, etc.
    if (![puntoCultural.horario isEqualToString:@""]) {
        CGSize size_horario = [puntoCultural.horario sizeWithFont:fuenteInformacion
                                                constrainedToSize:CGSizeMake(boxHorarioLabel.frame.size.width, 100000)];
        
        CGRect frameBoxHorarioLabel = boxHorarioLabel.frame;
        frameBoxHorarioLabel.size.height = size_horario.height;
        boxHorarioLabel.frame = frameBoxHorarioLabel;
        
        boxHorarioLabel.text = puntoCultural.horario;
        boxHorarioLabel.font = fuenteInformacion;
        boxHorarioLabel.textColor = colorInformacion;
        boxHorarioLabel.backgroundColor = [UIColor clearColor];
        boxHorarioLabel.numberOfLines = 0;
        
        CGRect frameBoxHorarioView = boxHorarioView.frame;
        frameBoxHorarioView.origin.y = largoActualFicha;
        frameBoxHorarioView.size.height = boxHorarioLabel.frame.origin.y + boxHorarioLabel.frame.size.height + 3;
        boxHorarioView.frame = frameBoxHorarioView;
        
        largoActualFicha = boxHorarioView.frame.origin.y + boxHorarioView.frame.size.height;
        boxHorarioView.hidden = NO;
        [self actualizaLargoScroll];
        
    }
    
    if (puntoCultural.web && ![puntoCultural.web isEqualToString:@""]) {
        
        boxWebTTTLabel.enabledTextCheckingTypes = NSTextCheckingTypeLink;
        boxWebTTTLabel.delegate = self;
        boxWebTTTLabel.text = puntoCultural.web;
        boxWebTTTLabel.textColor = colorInformacion;
        boxWebTTTLabel.backgroundColor = [UIColor clearColor];
        
        CGRect frameBoxWebView = boxWebView.frame;
        frameBoxWebView.origin.y = largoActualFicha;
        boxWebView.frame = frameBoxWebView;
        boxWebView.hidden = NO;
        
        largoActualFicha = boxWebView.frame.origin.y + boxWebView.frame.size.height;
        [self actualizaLargoScroll];
    }
    
    largoActualFicha += 15;
    
    //Descripción larga
    
    CGSize size_descripcion_larga = [puntoCultural.descripcion_larga sizeWithFont:fuenteDescripciones
                                                          constrainedToSize:CGSizeMake(280, 100000)
                                                              lineBreakMode:NSLineBreakByTruncatingTail];
    UILabel *descripcion_larga = [[UILabel alloc] initWithFrame:CGRectMake(20, largoActualFicha, 280, size_descripcion_larga.height)];
    descripcion_larga.text = puntoCultural.descripcion_larga;
    descripcion_larga.font = fuenteDescripciones;
    descripcion_larga.textColor = colorDescripciones;
    descripcion_larga.backgroundColor = [UIColor clearColor];
    descripcion_larga.numberOfLines = 0;
    descripcion_larga.lineBreakMode = UILineBreakModeWordWrap;
    
    largoActualFicha = descripcion_larga.frame.origin.y + descripcion_larga.frame.size.height + bordeInferior + 15;
    [self actualizaLargoScroll];
    [scroll addSubview:descripcion_larga];
    
    [self muestraComentarios];
}

-(void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url{
    [[UIApplication sharedApplication] openURL:url];
}

-(void)muestraComentarios{
    
    [puntoCultural requestComentariosWithSuccess:^{
        
        int cantidad_comentarios = (int)[[puntoCultural comentarios] count];
        
        if (cantidad_comentarios > 0) {
            
            largoActualFicha -= viewComentarios.frame.size.height;
            [viewComentarios removeFromSuperview];
            viewComentarios = [[UIView alloc] initWithFrame:CGRectMake(0, largoActualFicha, 320, 0)];
            
            int largoActualView = 0;
            
            //separador
            UIImageView *separador = [[UIImageView alloc] initWithFrame:CGRectMake(0, largoActualView, 320, 2)];
            separador.image = [UIImage imageNamed:@"ficha-linea-punto-01"];
            
            largoActualView = largoActualView + 2 + bordeInferior;
            //[self actualizaLargoScroll];
            //[scroll addSubview:separador];
            [viewComentarios addSubview:separador];
            
            
            //La gente comenta
            CGSize size_titulo_comentarios = [@"La gente comenta" sizeWithFont:fuenteTituloComentarios
                                                             constrainedToSize:CGSizeMake(280, 100000)
                                                                 lineBreakMode:NSLineBreakByTruncatingTail];
            UILabel *titulo_comentarios = [[UILabel alloc] initWithFrame:CGRectMake(20, largoActualView, 280, size_titulo_comentarios.height)];
            titulo_comentarios.text = @"La gente comenta";
            titulo_comentarios.font = fuenteTituloComentarios;
            titulo_comentarios.textColor = colorTituloComentarios;
            titulo_comentarios.backgroundColor = [UIColor clearColor];
            
            largoActualView = titulo_comentarios.frame.origin.y + titulo_comentarios.frame.size.height + bordeInferior;
            [self actualizaLargoScroll];
            //[scroll addSubview:titulo_comentarios];
            [viewComentarios addSubview:titulo_comentarios];
            
            // Comentarios
            for (int i = 0; i < MIN(4, cantidad_comentarios); i++) {
                
                CGSize size_comentario = [[(Comentario *)[puntoCultural.comentarios objectAtIndex:i] comentario] sizeWithFont:fuenteDescripciones
                                                                                                            constrainedToSize:CGSizeMake(260, 100000)
                                                                                                                lineBreakMode:NSLineBreakByTruncatingTail];
                
                UILabel *comentario = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 260, size_comentario.height)];
                comentario.text = [(Comentario *)[puntoCultural.comentarios objectAtIndex:i] comentario];
                comentario.font = fuenteDescripciones;
                comentario.textColor = colorDescripciones;
                comentario.backgroundColor = [UIColor clearColor];
                comentario.numberOfLines = 0;
                comentario.lineBreakMode = UILineBreakModeWordWrap;
                
                CGSize size_nombre_comentario = [[(Comentario *)[puntoCultural.comentarios objectAtIndex:i] autor] sizeWithFont:fuenteNombreComentarios
                                                                                                              constrainedToSize:CGSizeMake(260, 100000)
                                                                                                                  lineBreakMode:NSLineBreakByTruncatingTail];
                UILabel *nombre_comentario = [[UILabel alloc] initWithFrame:CGRectMake(10, comentario.frame.origin.y + comentario.frame.size.height + 5, 260, size_nombre_comentario.height)];
                nombre_comentario.text = [(Comentario *)[puntoCultural.comentarios objectAtIndex:i] autor];
                nombre_comentario.font = fuenteNombreComentarios;
                nombre_comentario.textColor = colorNombreComentarios;
                nombre_comentario.backgroundColor = [UIColor clearColor];
                nombre_comentario.numberOfLines = 1;
                nombre_comentario.lineBreakMode = UILineBreakModeTailTruncation;
                
                CGSize size_fecha = [[(Comentario *)[puntoCultural.comentarios objectAtIndex:i] fecha_string] sizeWithFont:fuenteFecha
                                                                                                         constrainedToSize:CGSizeMake(260, 100000)
                                                                                                             lineBreakMode:NSLineBreakByTruncatingTail];
                UILabel *fecha_comentario = [[UILabel alloc] initWithFrame:CGRectMake(10, nombre_comentario.frame.origin.y + nombre_comentario.frame.size.height + 5, 260, size_fecha.height)];
                fecha_comentario.text = [(Comentario *)[puntoCultural.comentarios objectAtIndex:i] fecha_string];
                fecha_comentario.font = fuenteFecha;
                fecha_comentario.textColor = colorFecha;
                fecha_comentario.backgroundColor = [UIColor clearColor];
                fecha_comentario.numberOfLines = 1;
                fecha_comentario.lineBreakMode = UILineBreakModeTailTruncation;
                
                UIImageView *comentario_view = [[UIImageView alloc] initWithFrame:CGRectMake(20, largoActualView, 280, fecha_comentario.frame.origin.y + size_fecha.height + 10)];
                //comentario_view.image = fondo_resizable;
                [comentario_view addSubview:comentario];
                [comentario_view addSubview:nombre_comentario];
                [comentario_view addSubview:fecha_comentario];
                comentario_view.backgroundColor = colorComentarios;
                comentario_view.layer.borderWidth = 2;
                comentario_view.layer.borderColor = [UIColor lightGrayColor].CGColor;
                
                largoActualView = comentario_view.frame.origin.y + comentario_view.frame.size.height - 2;
                //[self actualizaLargoScroll];
                //[scroll addSubview:comentario_view];
                [viewComentarios addSubview:comentario_view];
            }
            
            if (cantidad_comentarios > 4) {
                //Agrego el boton de ver más comentarios.
                
                UIButton *ver_todos = [UIButton buttonWithType:UIButtonTypeCustom];
                //[ver_todos setBackgroundImage:fondo_resizable forState:UIControlStateNormal];
                CGRect frame = CGRectMake(20, largoActualView, 280, 70);
                ver_todos.frame = frame;
                ver_todos.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
                [ver_todos setTitle:@"Ver todos los comentarios" forState:UIControlStateNormal];
                [ver_todos setTitleColor:colorDescripciones forState:UIControlStateNormal];
                [ver_todos addTarget:self action:@selector(verTodosPressed:) forControlEvents:UIControlEventTouchUpInside];
                ver_todos.backgroundColor = colorComentarios;
                ver_todos.layer.borderColor = [UIColor lightGrayColor].CGColor;
                ver_todos.layer.borderWidth = 2;
                largoActualView = ver_todos.frame.origin.y + ver_todos.frame.size.height + bordeInferior;
                [self actualizaLargoScroll];
                //[scroll addSubview:ver_todos];
                [viewComentarios addSubview:ver_todos];
            }
            
            CGRect frame = viewComentarios.frame;
            frame.size.height = largoActualView;
            viewComentarios.frame = frame;
            largoActualFicha += largoActualView;
            [scroll addSubview:viewComentarios];
            [self actualizaLargoScroll];
        }
        
    } AndFail:^(NSError *error) {
        //
    }];
}

-(void) verTodosPressed:(id)sender{
    ComentariosViewController *comentarios = [[ComentariosViewController alloc] initWithNibName:@"ComentariosViewController" bundle:[NSBundle mainBundle] AndComentarios:[puntoCultural comentarios]];
    comentarios.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dpc-nav-bar-logos"]];
    [self.navigationController pushViewController:comentarios animated:YES];
}

-(void) actualizaLargoScroll{
    [scroll setContentSize:CGSizeMake(320, largoActualFicha)];
}

-(void) actualizaDisplayBotonAccion{
    
    //ahora actualizo los fondos de los botones
    UIImage *default_image_01;
    UIImage *default_image_02;
    UIImage *default_image_03;
    UIImage *selected_image_01;
    UIImage *selected_image_02;
    UIImage *selected_image_03;
    switch (puntoCultural.id_tipo.intValue) {
        case TIPO_APERTURA:
            default_image_01 = [UIImage imageNamed:@"ficha-tabbar-aper-01"];
            default_image_02 = [UIImage imageNamed:@"ficha-tabbar-aper-02"];
            default_image_03 = [UIImage imageNamed:@"ficha-tabbar-aper-03"];
            selected_image_01 = [UIImage imageNamed:@"ficha-tabbar-aper-01-over"];
            selected_image_02 = [UIImage imageNamed:@"ficha-tabbar-aper-02-over"];
            selected_image_03 = [UIImage imageNamed:@"ficha-tabbar-aper-03-over"];
            break;
        
        case TIPO_ACTIVIDAD:
            default_image_01 = [UIImage imageNamed:@"ficha-tabbar-activ-01"];
            default_image_02 = [UIImage imageNamed:@"ficha-tabbar-activ-02"];
            default_image_03 = [UIImage imageNamed:@"ficha-tabbar-activ-03"];
            selected_image_01 = [UIImage imageNamed:@"ficha-tabbar-activ-01-over"];
            selected_image_02 = [UIImage imageNamed:@"ficha-tabbar-activ-02-over"];
            selected_image_03 = [UIImage imageNamed:@"ficha-tabbar-activ-03-over"];
            break;
        
        case TIPO_RUTA_TEMATICA:
            default_image_01 = [UIImage imageNamed:@"ficha-tabbar-rutas-01"];
            default_image_02 = [UIImage imageNamed:@"ficha-tabbar-rutas-02"];
            default_image_03 = [UIImage imageNamed:@"ficha-tabbar-rutas-03"];
            selected_image_01 = [UIImage imageNamed:@"ficha-tabbar-rutas-01-over"];
            selected_image_02 = [UIImage imageNamed:@"ficha-tabbar-rutas-02-over"];
            selected_image_03 = [UIImage imageNamed:@"ficha-tabbar-rutas-03-over"];
            break;
            
        case TIPO_RECORRIDO_GUIADO:
            default_image_01 = [UIImage imageNamed:@"ficha-tabbar-recorridos-01"];
            default_image_02 = [UIImage imageNamed:@"ficha-tabbar-recorridos-02"];
            default_image_03 = [UIImage imageNamed:@"ficha-tabbar-recorridos-03"];
            selected_image_01 = [UIImage imageNamed:@"ficha-tabbar-recorridos-01-over"];
            selected_image_02 = [UIImage imageNamed:@"ficha-tabbar-recorridos-02-over"];
            selected_image_03 = [UIImage imageNamed:@"ficha-tabbar-recorridos-03-over"];
            break;
        default:
            break;
    }
    
    //13 - 11
    if ([[MisPuntosCulturales instance] puntoCulturalConID:puntoCultural.id_punto]) {
        if (puntoCultural.visitado) {
            botonAccionPunto.titleLabel.font = fuenteBotonTituloLargo;
            [botonAccionPunto setTitle:@"No visitado" forState:UIControlStateNormal];
            [botonAccionPunto setTitle:@"No visitado" forState:UIControlStateSelected];
            [botonAccionPunto setTitle:@"No visitado" forState:UIControlStateHighlighted];
        }else{
            botonAccionPunto.titleLabel.font = fuenteBotonTituloCorto;
            [botonAccionPunto setTitle:@"Visitado" forState:UIControlStateNormal];
            [botonAccionPunto setTitle:@"Visitado" forState:UIControlStateSelected];
            [botonAccionPunto setTitle:@"Visitado" forState:UIControlStateHighlighted];
        }
    }else{
        botonAccionPunto.titleLabel.font = fuenteBotonTituloCorto;
        [botonAccionPunto setTitle:@"Agregar" forState:UIControlStateNormal];
        [botonAccionPunto setTitle:@"Agregar" forState:UIControlStateSelected];
        [botonAccionPunto setTitle:@"Agregar" forState:UIControlStateHighlighted];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//[[[UIAlertView alloc] initWithTitle:@"error" message:@"Sí hay conexión!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
#pragma mark - acciones del punto

- (IBAction)botonAccionPuntoPressed:(id)sender{
    
    if ([[MisPuntosCulturales instance] puntoCulturalConID:puntoCultural.id_punto]) {
        [DejalBezelActivityView activityViewForView:self.view withLabel:@"Cargando..."];
        [puntoCultural cambiarEstadoPuntoWithSuccess:^{
            [self actualizaDisplayBotonAccion];
            [DejalBezelActivityView removeViewAnimated:YES];
            if ([[MisPuntosCulturales instance] puntoCulturalConID:puntoCultural.id_punto]) {
                if (puntoCultural.visitado) {
                    [[[UIAlertView alloc] initWithTitle:@"Excelente!" message:@"Lugar marcado como visitado" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
                }else{
                    [[[UIAlertView alloc] initWithTitle:@"Excelente!" message:@"Lugar marcado como no visitado" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
                }
            }else{
                [[[UIAlertView alloc] initWithTitle:@"Excelente!" message:@"Lugar agregado a tu ruta" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
            }
        } AndFail:^(NSError *error) {
            [self actualizaDisplayBotonAccion];
            [DejalBezelActivityView removeViewAnimated:YES];
            
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Ocurrió un error, intenta de nuevo más tarde" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        }];
        
    }else{
        [DejalBezelActivityView activityViewForView:self.view withLabel:@"Agregando punto..."];
        if ([[MisPuntosCulturales instance] puntoCulturalConID:puntoCultural.id_punto]) {
            [DejalBezelActivityView removeViewAnimated:YES];
            [[[UIAlertView alloc] initWithTitle:@"Alerta" message:@"Este lugar ya está dentro de tu ruta" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            return;
        }
        
        [[MisPuntosCulturales instance] agregarPuntoCultural:puntoCultural AMisPuntosWithSuccess:^{
            [DejalBezelActivityView removeViewAnimated:YES];
            [self actualizaDisplayBotonAccion];
            [[[UIAlertView alloc] initWithTitle:@"Excelente!" message:@"Lugar agregado a tu ruta" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        } AndFail:^(NSError *error) {
            [DejalBezelActivityView removeViewAnimated:YES];
            [self actualizaDisplayBotonAccion];
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Ocurrió un error, intenta de nuevo más tarde" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        }];
    }
    
}

- (IBAction)botonCompartirEnRedesSocialesPressed:(id)sender{
    ShareViewController *share = [[ShareViewController alloc] initWithNibName:@"ShareViewController" bundle:[NSBundle mainBundle]];
    share.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dpc-nav-bar-logos"]];
    [[self navigationController] pushViewController:share
                                           animated:YES];
    /*
    UIBarButtonItem *atras = [[UIBarButtonItem alloc] initWithTitle:@"Ficha" style:UIBarButtonItemStyleBordered target:nil action:nil];
    
    if([[UIBarButtonItem class] instancesRespondToSelector:@selector(setTintColor:)]){
        atras.tintColor = [UIColor darkGrayColor];
    }
    
    [self.navigationItem setBackBarButtonItem:atras];
     */
}

- (IBAction)botonComentarioPressed:(id)sender{
    DejarComentarioViewController *comentario = [[DejarComentarioViewController alloc] initWithNibName:@"DejarComentarioViewController" bundle:[NSBundle mainBundle] AndPuntoCultural:puntoCultural AndDelegate:self];
    [self.navigationController presentViewController:comentario animated:YES completion:^{
        //
    }];
}

//Metodo delegado
-(void)comentarioEnviado{
    [self muestraComentarios];
}

@end
