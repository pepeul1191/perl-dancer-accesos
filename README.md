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


---

Fuentes:

+ http://blog.endpoint.com/2015/01/cleaner-redirection-in-perl-dancer.html