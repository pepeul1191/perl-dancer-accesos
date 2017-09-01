## Perl Dancer

Instalación de paquetes de CPANM

	$ curl -L http://cpanmin.us | perl - --sudo Dancer2
	$ sudo cpanm Plack::Middleware::Deflater

Arrancar Dancer:

	$ plackup -r bin/app.psgi

Arrancar Dancer con autoreload luego de hacer cambios:

	$ plackup -L Shotgun bin/app.psgi

---

Fuentes:

+ http://blog.endpoint.com/2015/01/cleaner-redirection-in-perl-dancer.html