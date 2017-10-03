## Perl Dancer

Instalación de paquetes de CPANM

    $ curl -L http://cpanmin.us | perl - --sudo Dancer2
    $ sudo cpanm Plack::Middleware::Deflater

Arrancar Dancer:

    $ plackup -r bin/app.psgi

Arrancar Dancer con autoreload luego de hacer cambios:

    $ plackup -L Shotgun bin/app.psgi

### Mojo Micro Web Framework

    $ sudo apt install cpanminus
    $ curl -L https://cpanmin.us | perl - -M https://cpan.metacpan.org -n Mojolicious
    $ sudo cpanm Mojolicious::Plugin::SecureCORS
    $ sudo apt install libmojolicious-perl

### Instalar SQLite para Perl

    $ sudo cpanm DBD::SQLite

### Instalar JSON para Perl

    $ sudo cpanm JSON
    $ sudo cpanm JSON::XS
    
### Instalar Crypt::MCrypt para Perl
 
    $ sudo cpanm Crypt::MCrypt 
    
### Instalar Try Catch Standar Error para Perl

    $ sudo cpanm Try::Tiny

Para imprimir variables:

    #print("\nA\n");print($url);print("\nB\n");
    #print("\n");print Dumper(%temp);print("\n");


---

Fuentes:

+ http://blog.endpoint.com/2015/01/cleaner-redirection-in-perl-dancer.html