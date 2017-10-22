## Perl Dancer

Instalación de paquetes de CPANM

    $ sudo apt install cpanminus
    $ curl -L http://cpanmin.us | perl - --sudo Dancer2
    $ sudo cpanm Plack::Middleware::Deflater DBD::SQLite JSON JSON::Create JSON::XS Crypt::MCrypt Try::Tiny

Arrancar Dancer:

    $ plackup -r bin/app.psgi

Arrancar Dancer con autoreload luego de hacer cambios:

    $ plackup -L Shotgun bin/app.psgi

Para imprimir variables:

    #print("\nA\n");print($url);print("\nB\n");
    #print("\n");print Dumper(%temp);print("\n");
    
### Rutas

+ GET '/estado_usuario/listar', to Handler/Estado_Usuario#listar
+ GET '/item/listar/menu', to Handler/Item#menu
+ GET '/item/listar_todos', to Handler/Item#listar_todos
+ GET '/item/listar/@subtitulo_id', to Handler/Item#listar
+ POST '/item/guardar', to Handler/Item#guardar
+ GET '/modulo/listar/@sistema_id', to Handler/Modulo#listar
+ GET '/modulo/listar_menu', to Handler/Modulo#listar_menu
+ POST '/modulo/guardar', to Handler/Modulo#guardar
+ GET '/subtitulo/listar/@modulo_id', to Handler/Subtitulo#listar
+ POST '/subtitulo/guardar', to Handler/Subtitulo#guardar
+ GET '/permiso/listar/@sistema_id', to Handler/Permiso#listar
+ GET '/permiso/listar_asociados/@sistema_id/@rol_id', to Handler/Permiso#listar_asociados
+ POST '/permiso/guardar', to Handler/Permiso#guardar
+ GET '/rol/listar/@sistema_id', to Handler/Rol#listar
+ POST '/rol/guardar', to Handler/Rol#guardar
+ POST '/rol/asociar_permisos', to Handler/Rol#asociar_permisos
+ GET '/sistema/listar', to Handler/Sistema#listar
+ GET '/sistema/usuario/@usuario_id', to Handler/Sistema#usuario
+ POST '/sistema/guardar', to Handler/Sistema#guardar
+ POST '/sistema/asociar_usuario', to Handler/Sistema#asociar_usuario
+ GET '/usuario/listar', to Handler/Usuario#listar
+ GET '/usuario/listar_accesos/@usuario_id', to Handler/Usuario#listar_accesos
+ GET '/usuario/listar_permisos/@sistema_id/@usuario_id', to Handler/Usuario#listar_permisos
+ GET '/usuario/listar_roles/@sistema_id/@usuario_id', to Handler/Usuario#listar_roles
+ GET '/usuario/usuario_correo/@usuario_id', to Handler/Usuario#usuario_correo
+ POST '/usuario/asociar_permisos', to Handler/Usuario#asociar_permisos
+ POST '/usuario/asociar_roles', to Handler/Usuario#asociar_roles
+ POST '/usuario/validar', to Handler/Usuario#validar
+ POST '/usuario/nombre_repetido', to Handler/Usuario#validar_nombre_repetido
+ POST '/usuario/correo_repetido', to Handler/Usuario#validar_correo_repetido
+ POST '/usuario/contrasenia_repetida', to Handler/Usuario#contrasenia_repetida
+ POST '/usuario/guardar_usuario_correo', to Handler/Usuario#guardar_usuario_correo
+ POST '/usuario/guardar_contrasenia', to Handler/Usuario#guardar_contrasenia

---

Fuentes:

+ http://blog.endpoint.com/2015/01/cleaner-redirection-in-perl-dancer.html