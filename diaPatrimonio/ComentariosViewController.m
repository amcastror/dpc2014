//
//  ComentariosViewController.m
//  DiaDelPatrimonio
//
//  Created by Matias Castro on 19-04-13.
//  Copyright (c) 2013 Matias Castro. All rights reserved.
//

#import "ComentariosViewController.h"
#import "Comentario.h"
#import "GAI.h"
#import "GAITracker.h"

#define bordeInferior 5
#define fuenteTitulo [UIFont fontWithName:@"Helvetica-Bold" size:21]
#define fuenteZona [UIFont fontWithName:@"Arial-BoldMT" size:14]
#define fuenteCategoria [UIFont fontWithName:@"Helvetica" size:16]
#define fuenteDescripciones [UIFont systemFontOfSize:17.0]
#define fuenteInformacion [UIFont systemFontOfSize:17.0]
#define fuenteTituloComentarios [UIFont systemFontOfSize:17.0]
#define fuenteNombreComentarios [UIFont systemFontOfSize:12.0]
#define fuenteFecha [UIFont systemFontOfSize:12.0]
#define colorTitulo [UIColor colorWithRed: 22.0/255.0 green: 82.0/255.0 blue: 158.0/255.0 alpha: 1.0]
#define colorZona [UIColor colorWithRed: 0.0/255.0 green: 0.0/255.0 blue: 0.0/255.0 alpha: 1.0]
#define colorDescripciones [UIColor colorWithRed: 20.0/255.0 green: 20.0/255.0 blue: 20.0/255.0 alpha: 1.0]
#define colorInformacion [UIColor colorWithRed: 20.0/255.0 green: 20.0/255.0 blue: 100.0/255.0 alpha: 1.0]
#define colorTituloComentarios [UIColor colorWithRed: 0.0/255.0 green: 0.0/255.0 blue: 0.0/255.0 alpha: 1.0]
#define colorNombreComentarios [UIColor colorWithRed: 100.0/255.0 green: 100.0/255.0 blue: 100.0/255.0 alpha: 1.0]
#define colorFecha [UIColor colorWithRed: 100.0/255.0 green: 100.0/255.0 blue: 100.0/255.0 alpha: 1.0]

@interface ComentariosViewController ()

@end

@implementation ComentariosViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil AndComentarios:(NSArray *)_comentarios
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        comentarios = _comentarios;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.trackedViewName = @"ver_comentarios";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *MyIdentifier = @"MyIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    int alto_primera_fila = 0;
    if (indexPath.row == 0) {
        alto_primera_fila = 10;
    }
    
    /*
     1 - Label, comentario
     */
    
    UILabel *label = [[UILabel alloc] init];
    
    CGSize size_comentario = [[(Comentario *)[comentarios objectAtIndex:indexPath.row] comentario] sizeWithFont:fuenteDescripciones
                                                                                                                constrainedToSize:CGSizeMake(260, 100000)
                                                                                                                    lineBreakMode:UILineBreakModeTailTruncation];
    CGRect frame;
    frame.origin.x = 20;
    frame.origin.y = alto_primera_fila + 10;
    frame.size.height = size_comentario.height;
    frame.size.width = 260;
    label.frame = frame;
    label.font = fuenteDescripciones;
    label.textColor = colorDescripciones;
    //label.backgroundColor = [UIColor greenColor];
    label.text = [(Comentario *)[comentarios objectAtIndex:indexPath.row] comentario];
    label.numberOfLines = 0;
    [cell addSubview:label];
    
    /*
     1 - Label, autor
     */
    
    label = [[UILabel alloc] init];
    
    CGSize size_autor = [[(Comentario *)[comentarios objectAtIndex:indexPath.row] autor] sizeWithFont:fuenteNombreComentarios
                                                                                                      constrainedToSize:CGSizeMake(260, 100000)
                                                                                                          lineBreakMode:UILineBreakModeTailTruncation];
    frame.origin.x = 20;
    frame.origin.y = alto_primera_fila + 10 + size_comentario.height + 5;
    frame.size.height = size_autor.height;
    frame.size.width = 260;
    label.frame = frame;
    label.font = fuenteNombreComentarios;
    label.textColor = colorNombreComentarios;
    //label.backgroundColor = [UIColor yellowColor];
    label.text = [(Comentario *)[comentarios objectAtIndex:indexPath.row] autor];
    
    [cell addSubview:label];
    int fin_autor = frame.origin.y + frame.size.height;
    
    /*
     1 - Label, fecha
     */
    
    label = [[UILabel alloc] init];
    
    CGSize size_fecha = [[(Comentario *)[comentarios objectAtIndex:indexPath.row] fecha_string] sizeWithFont:fuenteFecha
                                                                                                      constrainedToSize:CGSizeMake(260, 100000)
                                                                                                          lineBreakMode:UILineBreakModeTailTruncation];
    frame.origin.x = 20;
    frame.origin.y = fin_autor + 5;
    frame.size.height = size_fecha.height;
    frame.size.width = 260;
    label.frame = frame;
    label.font = fuenteFecha;
    label.textColor = colorFecha;
    //label.backgroundColor = [UIColor redColor];
    label.text = [(Comentario *)[comentarios objectAtIndex:indexPath.row] fecha_string];
    
    [cell addSubview:label];
    
    //icono-categoria-actividad-02
    
    UIImage *fondo;
    if (indexPath.row == 0) {
        fondo = [UIImage imageNamed:@"ficha-img-fondo-fila-arriba"];
    }else{
        fondo = [UIImage imageNamed:@"ficha-img-fondo-fila"];
    }
    
    UIImage *fondo_resizable = [fondo resizableImageWithCapInsets:UIEdgeInsetsMake(40.0, 40.0, 40.0, 40.0)];
    UIImageView *background = [[UIImageView alloc] initWithImage:fondo_resizable];
    cell.backgroundView = background;
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size_nombre = [[(Comentario *)[comentarios objectAtIndex:indexPath.row] comentario]
                          sizeWithFont:fuenteDescripciones
                          constrainedToSize:CGSizeMake(260, 100000)
                          lineBreakMode:UILineBreakModeTailTruncation];
    CGSize size_autor = [[(Comentario *)[comentarios objectAtIndex:indexPath.row] autor] sizeWithFont:fuenteNombreComentarios
                                                                                                      constrainedToSize:CGSizeMake(260, 100000)
                                                                                                          lineBreakMode:UILineBreakModeTailTruncation];
    CGSize size_fecha = [[(Comentario *)[comentarios objectAtIndex:indexPath.row] fecha_string] sizeWithFont:fuenteFecha
                                                                                                      constrainedToSize:CGSizeMake(260, 100000)
                                                                                                          lineBreakMode:UILineBreakModeTailTruncation];
    
    if (indexPath.row == 0) {
        return MAX((10 + size_nombre.height + 5 + size_autor.height + 5 + size_fecha.height + 10 + 10), 50);
    }else{
        return MAX((10 + size_nombre.height + 5 + size_autor.height + 5 + size_fecha.height + 10), 40);
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return comentarios.count;
}

@end
