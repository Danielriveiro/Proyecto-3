{$mode delphi}

program Biblioteca;

uses
  SysUtils, Crt;

type
  Material = record
    titulo: string;
    prestado: boolean;
  end;

  Estudiante = record
    Nombre: string;
    materiales_prestados: integer;
    suspendido: boolean;
  end;

var
  Estudiantes: array[1..100] of Estudiante;
  Libros: array[1..15] of Material;
  Trabajos: array[1..10] of Material;
  numeroDeEstudiante, numeroDeLibros, numeroDeTrabajos: integer;

procedure nuevo_registro();
var
  EstudianteNuevo: Estudiante;
  F: TextFile;
begin
  writeln('Ingrese el nombre del estudiante:');
  readln(EstudianteNuevo.Nombre);
  EstudianteNuevo.materiales_prestados := 0;
  EstudianteNuevo.suspendido := false;
  numeroDeEstudiante := numeroDeEstudiante + 1;
  Estudiantes[numeroDeEstudiante] := EstudianteNuevo;

  // Abre el archivo para escribir
  AssignFile(F, 'estudiantes.txt');
  if FileExists('estudiantes.txt') then
    Append(F)  // Si el archivo existe, añade al final
  else
    Rewrite(F);  // Si el archivo no existe, crea uno nuevo

  // Escribe la información del estudiante en el archivo
  WriteLn(F, 'Nombre: ', EstudianteNuevo.Nombre);
  WriteLn(F, 'Materiales prestados: ', EstudianteNuevo.materiales_prestados);
  if EstudianteNuevo.suspendido then
    WriteLn(F, 'Estado: suspendido')
  else
    WriteLn(F, 'Estado: activo');
  WriteLn(F);

  // Cierra el archivo
  CloseFile(F);
end;

procedure RegistrarLibro();
var
  LibroNuevo: Material;
  F: TextFile;
begin
  writeln('Ingrese el titulo del libro:');
  readln(LibroNuevo.titulo);
  LibroNuevo.prestado := false;
  numeroDeLibros := numeroDeLibros + 1;
  Libros[numeroDeLibros] := LibroNuevo;

  // Abre el archivo para escribir
  AssignFile(F, 'libros.txt');
  if FileExists('libros.txt') then
    Append(F)  // Si el archivo existe, añade al final
  else
    Rewrite(F);  // Si el archivo no existe, crea uno nuevo

  // Escribe la información del libro en el archivo
  WriteLn(F, 'Titulo: ', LibroNuevo.titulo);
  if LibroNuevo.prestado then
    WriteLn(F, 'Estado: prestado')
  else
    WriteLn(F, 'Estado: disponible');
  WriteLn(F);

  // Cierra el archivo
  CloseFile(F);
end;

procedure RegistrarPrestamo();
var
  NombreDelEstudiante, TituloDelMaterial: string;
  i, j: integer;
  F: TextFile;
begin
  writeln('Ingrese el nombre del estudiante:');
  readln(NombreDelEstudiante);
  writeln('Ingrese el titulo del material:');
  readln(TituloDelMaterial);
  for i := 1 to numeroDeEstudiante do
  begin
    if Estudiantes[i].Nombre = NombreDelEstudiante then
    begin
      for j := 1 to numeroDeLibros do
      begin
        if (Libros[j].titulo = TituloDelMaterial) and (not Libros[j].prestado) then
        begin
          Estudiantes[i].materiales_prestados := Estudiantes[i].materiales_prestados + 1;
          Libros[j].prestado := true;
          writeln('Libro "', Libros[j].titulo, '" prestado exitosamente a ', Estudiantes[i].Nombre, '.');

          // Abre el archivo para escribir
          AssignFile(F, 'prestamos.txt');
          if FileExists('prestamos.txt') then
            Append(F)  // Si el archivo existe, añade al final
          else
            Rewrite(F);  // Si el archivo no existe, crea uno nuevo

          // Escribe la información del préstamo en el archivo
          WriteLn(F, 'Estudiante: ', Estudiantes[i].Nombre);
          WriteLn(F, 'Libro: ', Libros[j].titulo);
          WriteLn(F);

          // Cierra el archivo
          CloseFile(F);

          exit;
        end;
      end;
      for j := 1 to numeroDeTrabajos do
      begin
        if (Trabajos[j].titulo = TituloDelMaterial) and (not Trabajos[j].prestado) then
        begin
          Estudiantes[i].materiales_prestados := Estudiantes[i].materiales_prestados + 1;
          Trabajos[j].prestado := true;
          writeln('Trabajo de investigacion prestado exitosamente.');

          // Abre el archivo para escribir
          AssignFile(F, 'prestamos.txt');
          if FileExists('prestamos.txt') then
            Append(F)  // Si el archivo existe, añade al final
          else
            Rewrite(F);  // Si el archivo no existe, crea uno nuevo

          // Escribe la información del préstamo en el archivo
          WriteLn(F, 'Estudiante: ', Estudiantes[i].Nombre);
          WriteLn(F, 'Trabajo de investigacion: ', Trabajos[j].titulo);
          WriteLn(F);

          // Cierra el archivo
          CloseFile(F);

          exit;
        end;
      end;
    end;
  end;
  writeln('No se pudo realizar el prestamo.');
end;

procedure SeleccionarUsuario();
var
  NombreDelEstudiante: string;
  i: integer;
begin
  writeln('Ingrese el nombre del estudiante:');
  readln(NombreDelEstudiante);
  for i := 1 to numeroDeEstudiante do
  begin
    if Estudiantes[i].Nombre = NombreDelEstudiante then
    begin
      writeln('Bienvenido, ', Estudiantes[i].Nombre, '!');
      exit;
    end;
  end;
  writeln('Usuario no encontrado.');
end;

var
  option: integer;

begin
  numeroDeEstudiante := 0;
  numeroDeLibros := 0;
  numeroDeTrabajos := 0;
  while true do
  begin
    ClrScr;
    writeln('1. Registrar nuevo estudiante');
    writeln('2. Registrar prestamo');
    writeln('3. Seleccionar usuario');
    writeln('4. Registrar nuevo libro');
    writeln('Ingrese la opcion deseada:');
    readln(option);
    
    case option of
      1: nuevo_registro();
      2: RegistrarPrestamo();
      3: SeleccionarUsuario();
      4: RegistrarLibro();
    end;
  end;
end.
